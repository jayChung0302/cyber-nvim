#!/usr/bin/env bash
set -euo pipefail

PY_FILE="${1:-}"
if [[ -z "${PY_FILE}" ]]; then
  echo "Usage: run_cases.sh path/to/solution.py"
  exit 2
fi

IN_DIR="${CASES_IN_DIR:-cases/in}"
OUT_DIR="${CASES_OUT_DIR:-cases/out}"

if [[ ! -d "${IN_DIR}" ]]; then
  echo "No ${IN_DIR} directory. Create cases/in and put *.txt inputs."
  exit 2
fi

shopt -s nullglob
inputs=("${IN_DIR}"/*.txt)
if (( ${#inputs[@]} == 0 )); then
  echo "No input cases found in ${IN_DIR}/*.txt"
  exit 2
fi

echo "== Running: ${PY_FILE}"
echo "== Inputs:  ${IN_DIR}/*.txt"
echo "== Outputs: ${OUT_DIR}/*.txt (if exists)"
echo

fail=0

for in_path in "${inputs[@]}"; do
  name="$(basename "${in_path}" .txt)"
  out_path="${OUT_DIR}/${name}.txt"

  echo "---- CASE: ${name} ----"
  actual="$(mktemp)"
  uv run python "${PY_FILE}" < "${in_path}" > "${actual}"

  if [[ -f "${out_path}" ]]; then
    if diff -u "${out_path}" "${actual}"; then
      echo "✅ PASS"
    else
      echo "❌ FAIL (diff above)"
      fail=1
    fi
  else
    echo "(no expected output: ${out_path})"
    echo "----- ACTUAL -----"
    cat "${actual}"
  fi

  rm -f "${actual}"
  echo
done

if (( fail == 1 )); then
  echo "Some cases failed."
  exit 1
fi

echo "All cases passed."

