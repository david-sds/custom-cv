#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/.."

spinner() {
  local pid=$1
  local spin='|/-\'

  while kill -0 "$pid" 2>/dev/null; do
    printf "\r[%c] Working..." "${spin:0:1}"
    spin="${spin:1}${spin:0:1}"
    sleep 0.1
  done

  printf "\rDone.\n"
}

generate_resume_data() {
  local role=$1
  local err out pid status

  err=$(mktemp) || return 1
  out=$(mktemp) || {
    rm -f "$err"
    return 1
  }

  opencode run "$role" 2>"$err" |
    sed '/^```yaml$/d; /^```$/d' >"$out" &

  pid=$!
  spinner "$pid" >&2
  wait "$pid"
  status=$?

  if [ "$status" -ne 0 ]; then
    cat "$err" >&2
    rm -f "$err" "$out"
    return "$status"
  fi

  if ! prettierd teste.yaml <"$out"; then
    status=$?
    cat "$err" >&2
    rm -f "$err" "$out"
    return "$status"
  fi

  rm -f "$err" "$out"
}

generate_cv() {
  echo "Paste the job description. Press Ctrl+D when done:"
  ROLE=$(cat)

  i=1
  while [ -d "$ROOT_DIR/output/cv${i}" ]; do
    i=$((i + 1))
  done

  OUTPUT_DIR="$ROOT_DIR/output/cv${i}"
  mkdir -p "$OUTPUT_DIR"
  echo $ROLE >"$OUTPUT_DIR/job.txt"

  RESUME_DATA=$(generate_resume_data "$ROLE") || exit $?

  git diff --no-index --color "$ROOT_DIR/resume.yaml" <(echo "$RESUME_DATA")

  read -rp "Apply changes? [Y/n] " answer
  case "$answer" in
  [Nn]*) echo "Cancelling..." ;;
  [Yy]*)
    echo "$RESUME_DATA" >"$OUTPUT_DIR/data.yaml"
    typst compile "$ROOT_DIR/templates/david-sds.typ" \
      --root "$ROOT_DIR" \
      --input data="../output/cv${i}/data.yaml" \
      "$OUTPUT_DIR/cv.pdf"
    echo "$OUTPUT_DIR/cv.pdf generated!"
    ;;
  *) echo "Invalid option" ;;
  esac
}

while true; do
  generate_cv
done
