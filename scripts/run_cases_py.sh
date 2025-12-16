#!/usr/bin/env bash
set -euo pipefail

PY_FILE="${1:-}"
if [[ -z "${PY_FILE}" ]]; then
  echo "Usage: run_cases_py.sh path/to/solution.py"
  exit 2
fi

PY_BIN="${PY_BIN:-.venv/bin/python}"
if [[ ! -x "${PY_BIN}" ]]; then
  echo "PY_BIN not found/executable: ${PY_BIN}"
  echo "Tip: uv venv (creates .venv) or set PY_BIN env."
  exit 2
fi

IN_DIR="${CASES_IN_DIR:-cases/in}"
OUT_DIR="${CASES_OUT_DIR:-cases/out}"

shopt -s nullglob
inputs=("${IN_DIR}"/*.txt)
if (( ${#inputs[@]} == 0 )); then
  echo "No input cases found in ${IN_DIR}/*.txt"
  exit 2
fi

fail=0
for in_path in "${inputs[@]}"; do
  name="$(basename "${in_path}" .txt)"
  out_path="${OUT_DIR}/${name}.txt"

  echo "---- CASE: ${name} ----"
  actual="$(mktemp)"
  "${PY_BIN}" "${PY_FILE}" < "${in_path}" > "${actual}"

  if [[ -f "${out_path}" ]]; then
    if diff -u "${out_path}" "${actual}"; then
      echo "✅ PASS"
    else
      echo "❌ FAIL"
      fail=1
    fi
  else
    echo "(no expected output)"; cat "${actual}"
  fi
  rm -f "${actual}"
  echo
done

exit "${fail}"

