#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/.."

source "$SCRIPT_DIR/utils.sh"
source "$SCRIPT_DIR/core.sh"
source "$SCRIPT_DIR"/agents/*.sh

require typst
require jq
require fzf

fix_errors() {
  local resume_data=$1
  local session_id=$2

  read -rp "Fix errors? [Y]es/[N]o" ans
  case "$ans" in
  [Nn]*) echo "Cancelling..." >&2 ;;
  [Yy]*)
    res=$(edit "$resume_data")
    confirm_cv "$res" "$session_id"
    ;;
  *)
    echo "Invalid option" >&2
    confirm_cv "$resume_data" "$session_id"
    ;;
  esac
}

compile() {
  local resume_data=$1
  local session_id=$2

  echo "$resume_data" >"$OUTPUT_DIR/data.yaml"

  typst compile "$ROOT_DIR/templates/david-sds.typ" \
    --root "$ROOT_DIR" \
    --input data="../$OUTPUT_SUB_DIR/data.yaml" \
    "$OUTPUT_DIR/cv.pdf"
}

confirm_cv() {
  local resume_data="$1"
  local session_id="$2"
  git diff --no-index --color "$ROOT_DIR/resume.yaml" <(echo "$resume_data")

  read -rp "Apply changes? [Y]es/[N]o/[S]ugest/[E]dit/[C]over letter " answer
  case "$answer" in
  [Nn]*) echo "Cancelling..." >&2 ;;
  [Yy]*)
    compile "$resume_data" "$session_id"
    if [ "$?" -ne 0 ]; then
      fix_errors "$resume_data" "$session_id"
    else
      echo "$OUTPUT_DIR/cv.pdf generated!" >&2
    fi
    ;;
  [Ss]*)
    echo "Write your suggestions for a new version. Press Ctrl+D when done:" >&2
    local sugestions=$(cat)
    local res=$(sugest "$sugestions" "$session_id")
    confirm_cv "$res" "$session_id"
    ;;
  [Ee]*)
    local res=$(edit "$resume_data")
    confirm_cv "$res" "$session_id"
    ;;
  [Cc]*)
    cover_letter "$resume_data" "$session_id"
    ;;
  *)
    echo "Invalid option" >&2
    confirm_cv "$resume_data" "$session_id"
    ;;
  esac
}

generate_cv() {
  local role=$1

  local session_id=$(init_opencode_session "$role")
  echo "Session id: $session_id"

  i=1
  while [ -d "$ROOT_DIR/output/${i}" ]; do
    i=$((i + 1))
  done
  OUTPUT_SUB_DIR="output/${i}"
  OUTPUT_DIR="$ROOT_DIR/$OUTPUT_SUB_DIR"
  mkdir "$OUTPUT_DIR"
  printf '%s\n' "$session_id" >"$OUTPUT_DIR/opencodeSessionId"
  echo "$role" >"$OUTPUT_DIR/job.txt"

  local resume_data=$(generate_resume_data "$role" "$session_id") || exit $?

  confirm_cv "$resume_data" "$session_id"
}

load_cv() {
  mkdir -p "$ROOT_DIR/output"
  OUTPUT_DIR=$(
    find "$ROOT_DIR/output" -mindepth 1 -maxdepth 1 -type d |
      awk -F/ '{print $NF "\t" $0}' |
      fzf --delimiter=$'\t' --with-nth=1 |
      awk -F'\t' '{print $2}'
  )
  OUTPUT_SUB_DIR="output/$(basename "$OUTPUT_DIR")"

  local role=$(cat "$OUTPUT_DIR/job.txt" 2>/dev/null)
  local resume_data=$(cat "$OUTPUT_DIR/data.yaml" 2>/dev/null)
  local session_id=$(cat "$OUTPUT_DIR/opencodeSessionId" 2>/dev/null)

  if ! is_opencode_session "$session_id"; then
    local context=$(generate_context_prompt "$role" "$resume_data")
    session_id=$(init_opencode_session "$context")
    printf '%s\n' "$session_id" >"$OUTPUT_DIR/opencodeSessionId"
  fi

  echo "Session id: $session_id"

  if [ -z "$resume_data" ]; then
    local resume_data=$(generate_resume_data "$role" "$session_id") || exit $?
  fi

  confirm_cv "$resume_data" "$session_id"
}

RUNNING=true

main_menu() {
  read -rp "Main Menu [N]ew/[L]oad/[Q]uit/ " answer
  case "$answer" in
  [Nn]*)
    echo "Paste the job description. Press Ctrl+D when done:"
    local role=$(cat)
    generate_cv "$role"
    ;;
  [Ll]*)
    load_cv
    ;;
  [Qq]*)
    RUNNING=false
    echo "Bye!" >&2
    ;;
  *)
    echo "Invalid option" >&2
    main_menu
    ;;
  esac
}

while "$RUNNING"; do
  main_menu
done
