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

generate_cv() {
  echo "Paste the job description. Press Ctrl+D when done:"
  ROLE=$(cat)
  echo "$ROLE"

  ERR=$(mktemp)
  OUT=$(mktemp)

  opencode run "$ROLE" 2>"$ERR" |
    sed '/^```yaml$/d; /^```$/d' >"$OUT" &

  PID=$!
  spinner "$PID"
  wait "$PID"

  STATUS=$?

  if [ $STATUS -ne 0 ]; then
    cat "$ERR"
    exit $STATUS
  fi

  RES=$(cat "$OUT")
  rm -f "$ERR" "$OUT"

  echo "$RES"
  STATUS=$?

  if [ $STATUS -ne 0 ]; then
    cat "$ERR"
    rm -f "$ERR"
    exit $STATUS
  fi

  RESUME_DATA=$(printf '%s\n' "$RES" | prettierd teste.yaml)

  git diff --no-index --color \
    "$ROOT_DIR/resume.yaml" \
    <(echo "$RES" | prettierd teste.yaml) | less -R

  read -rp "Apply changes? [Y/n] " answer
  case "$answer" in
  [Nn]*) echo "Cancelling..." ;;
  [Yy]*)
    i=1
    while [ -d "$ROOT_DIR/output/cv${i}" ]; do
      i=$((i + 1))
    done

    OUTPUT_DIR="$ROOT_DIR/output/cv${i}"
    mkdir "$OUTPUT_DIR"
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
