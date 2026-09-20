#!/usr/bin/env bash
# Fetch RTLFixer's VerilogEval-syntax dataset: 174 erroneous implementations
# derived from VerilogEval, each with the compiler log that the paper's Table 1
# is measured on.
#
# Not vendored into this repository — it belongs to NVlabs/RTLFixer.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXP_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
DEST="${DEST:-$EXP_DIR/data}"
URL="${URL:-https://raw.githubusercontent.com/NVlabs/RTLFixer/main/src/benchmarks/verilogeval-syntax.jsonl}"

mkdir -p "$DEST"
if [ -s "$DEST/verilogeval-syntax.jsonl" ]; then
  echo ">> already present: $DEST/verilogeval-syntax.jsonl"
else
  curl -fsSL "$URL" -o "$DEST/verilogeval-syntax.jsonl"
  echo ">> fetched $DEST/verilogeval-syntax.jsonl"
fi

python3 - "$DEST/verilogeval-syntax.jsonl" <<'PY'
import json, sys
rows = [json.loads(line) for line in open(sys.argv[1])]
print(f">> {len(rows)} erroneous implementations over "
      f"{len({r['task_id'] for r in rows})} distinct problems")
PY
