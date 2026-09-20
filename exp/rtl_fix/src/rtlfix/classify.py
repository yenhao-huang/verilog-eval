"""Taxonomies for the error-distribution analysis.

Three orthogonal labels are attached to every attempt:

``outcome``       what happened overall (pass / compile_error / ...)
``error_kind``    for compile errors, which class of syntax error
``topic``         what kind of circuit the problem asks for
"""

from __future__ import annotations

import re

# --- outcome -----------------------------------------------------------------

OUTCOMES = (
    "pass",
    "functional_mismatch",
    "compile_error",
    "simulation_timeout",
    "runtime_error",
    "no_code",
    "api_error",
)


def classify_outcome(status: str, code: str, agent_error: str) -> str:
    if agent_error and not code.strip():
        return "api_error"
    if not code.strip():
        return "no_code"
    return {
        "pass": "pass",
        "fail": "functional_mismatch",
        "compile_error": "compile_error",
        "timeout": "simulation_timeout",
        "runtime_error": "runtime_error",
    }.get(status, "runtime_error")


# --- compile-error kind -------------------------------------------------------

# Ordered: the first pattern that matches wins.
ERROR_KINDS: tuple[tuple[str, str], ...] = (
    ("port_mismatch", r"port .* is not a port of|Port \d+ .* is not|too many ports|Unknown module type"),
    ("undeclared_identifier", r"Unable to bind wire/reg/memory|is not declared|Unknown identifier"),
    ("invalid_lvalue", r"not a valid l-value"),
    ("index_out_of_range", r"out of range|cannot be outside the declared range"),
    ("bad_constant", r"Extra digits given for sized|digits given for sized|Malformed"),
    ("multiple_drivers", r"driven by more than one|Cannot perform procedural assignment"),
    ("dangling_port", r"dangling input port|floating"),
    ("module_instantiation", r"invalid module instantiation|Instantiation of"),
    ("type_error", r"cannot be driven by primitives|Incomparable|incompatible|width mismatch"),
    ("syntax_error", r"syntax error"),
)


def classify_compile_error(log: str) -> str:
    if not log:
        return "unknown"
    for name, pattern in ERROR_KINDS:
        if re.search(pattern, log, re.IGNORECASE):
            return name
    return "other_elaboration_error"


# --- problem topic ------------------------------------------------------------

TOPICS: tuple[tuple[str, tuple[str, ...]], ...] = (
    ("fsm", ("fsm", "state machine", "moore", "mealy", "lemmings", "ps2", "hdlc", "serial")),
    ("sequential", ("always @(posedge", "flip-flop", "flipflop", "register", "counter",
                    "shift", "latch", "clocked", "clk")),
    ("arithmetic", ("adder", "add", "subtract", "multiply", "bcd", "carry", "alu")),
    ("kmap_logic", ("karnaugh", "k-map", "kmap", "truth table", "minterm", "sum-of-products")),
    ("combinational", ("mux", "multiplexer", "decoder", "encoder", "gate", "and", "or",
                       "xor", "vector", "priority")),
)


def classify_topic(name: str, prompt: str) -> str:
    haystack = f"{name}\n{prompt}".lower()
    for topic, keywords in TOPICS:
        if any(keyword in haystack for keyword in keywords):
            return topic
    return "other"
