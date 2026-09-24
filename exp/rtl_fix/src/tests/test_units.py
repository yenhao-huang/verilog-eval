#!/usr/bin/env python3
"""Unit tests for the pure parts of the harness.

Run with: python3 src/tests/test_units.py
"""

from __future__ import annotations

import sys
import unittest
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))

from rtlfix import classify, compiler  # noqa: E402
from rtlfix.extract import extract_verilog  # noqa: E402
from rtlfix.rag import GuidanceDB  # noqa: E402
from rtlfix.tools import Toolkit  # noqa: E402


class TestExtract(unittest.TestCase):
    def test_fenced_block(self):
        text = "Here you go:\n```verilog\nmodule TopModule(output x);\nassign x=0;\nendmodule\n```\n"
        self.assertTrue(extract_verilog(text).startswith("module TopModule"))

    def test_last_block_wins(self):
        text = (
            "First try:\n```verilog\nmodule TopModule(output a);\nendmodule\n```\n"
            "Fixed:\n```verilog\nmodule TopModule(output b);\nendmodule\n```\n"
        )
        self.assertIn("output b", extract_verilog(text))

    def test_begin_done_markers(self):
        text = "[BEGIN]\nmodule TopModule(output x);\nendmodule\n[DONE]"
        self.assertIn("module TopModule", extract_verilog(text))

    def test_bare_module(self):
        self.assertIn("endmodule", extract_verilog("module TopModule(output x);\nendmodule"))

    def test_no_code(self):
        self.assertEqual(extract_verilog("I could not solve it."), "I could not solve it.\n")
        self.assertEqual(extract_verilog(""), "")


class TestGuidanceDB(unittest.TestCase):
    def setUp(self):
        self.db = GuidanceDB.load()

    def test_lvalue_entry_fires(self):
        guidance, ids = self.db.lookup("TopModule.sv:5: error: out is not a valid l-value in TopModule.")
        self.assertIn("not-a-valid-l-value", ids)
        self.assertIn("assign statements", guidance)

    def test_not_match_suppresses_entry(self):
        log = "warning: dangling input port (clk) floating, used as posedge clk"
        _, ids = self.db.lookup(log)
        self.assertIn("dangling-clk-posedge", ids)
        self.assertNotIn("dangling-clk", ids)

    def test_unknown_error_falls_back(self):
        guidance, ids = self.db.lookup("TopModule.sv:3: some brand new error")
        self.assertEqual(ids, [])
        self.assertIn("explain what the compile error is about", guidance)

    def test_empty_log(self):
        self.assertEqual(self.db.lookup(""), ("", []))


class TestClassify(unittest.TestCase):
    def test_outcomes(self):
        self.assertEqual(classify.classify_outcome("pass", "module x; endmodule", ""), "pass")
        self.assertEqual(
            classify.classify_outcome("fail", "module x; endmodule", ""), "functional_mismatch"
        )
        self.assertEqual(classify.classify_outcome("compile_error", "", "boom"), "api_error")
        self.assertEqual(classify.classify_outcome("compile_error", "", ""), "no_code")

    def test_error_kinds(self):
        self.assertEqual(
            classify.classify_compile_error("error: out is not a valid l-value"), "invalid_lvalue"
        )
        self.assertEqual(
            classify.classify_compile_error("error: Index out[8] is out of range."),
            "index_out_of_range",
        )
        self.assertEqual(classify.classify_compile_error("syntax error"), "syntax_error")
        self.assertEqual(classify.classify_compile_error(""), "unknown")

    def test_topics(self):
        self.assertEqual(classify.classify_topic("Prob109_fsm1", "a Moore state machine"), "fsm")
        self.assertEqual(classify.classify_topic("Prob022_mux2to1", "a 2-to-1 mux"), "combinational")


class TestCompilerTool(unittest.TestCase):
    def test_syntax_check_accepts_good_module(self):
        result = compiler.syntax_check("module TopModule(output zero);\nassign zero = 1'b0;\nendmodule\n")
        self.assertTrue(result.ok, result.log)

    def test_syntax_check_rejects_bad_module(self):
        result = compiler.syntax_check("module TopModule(output zero);\nassign zero = ;\nendmodule\n")
        self.assertFalse(result.ok)
        self.assertIn("TopModule.sv", result.log)
        self.assertNotIn("/tmp/", result.log)


class TestToolkit(unittest.TestCase):
    def test_compiler_tool_round_trip(self):
        toolkit = Toolkit(use_rag=True, workdir=Path("/tmp"))
        good = "```verilog\nmodule TopModule(output zero);\nassign zero = 1'b0;\nendmodule\n```"
        self.assertIn("no compile error", toolkit.verilog_compiler(good))
        self.assertEqual(toolkit.compile_calls, 1)
        self.assertTrue(toolkit.last_compile_ok)

    def test_rag_tool_uses_last_log_when_argument_empty(self):
        toolkit = Toolkit(use_rag=True, workdir=Path("/tmp"))
        toolkit.verilog_compiler("module TopModule(output zero);\nassign zero = ;\nendmodule")
        self.assertFalse(toolkit.last_compile_ok)
        answer = toolkit.error_lookup("")
        self.assertTrue(answer)
        self.assertEqual(toolkit.rag_calls, 1)

    def test_rag_tool_absent_without_rag(self):
        toolkit = Toolkit(use_rag=False, workdir=Path("/tmp"))
        names = [schema["function"]["name"] for schema in toolkit.schemas()]
        self.assertEqual(names, ["verilog_compiler"])

    def test_unknown_tool_is_reported(self):
        toolkit = Toolkit(use_rag=False, workdir=Path("/tmp"))
        self.assertIn("Unknown tool", toolkit.call("nope", {}))

    def test_empty_code_is_rejected(self):
        toolkit = Toolkit(use_rag=False, workdir=Path("/tmp"))
        self.assertIn("No Verilog code", toolkit.verilog_compiler("   "))


if __name__ == "__main__":
    unittest.main(verbosity=2)
