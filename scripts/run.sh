#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/.."

source "$SCRIPT_DIR/utils.sh"
source "$SCRIPT_DIR/core.sh"
source "$SCRIPT_DIR"/agents/*.sh

require jq
require fzf

new_cv() {
  local role=$1

  local session_id=$(init_opencode_session "/custom-curriculum")
  echo "Session id: $session_id"

  i=1
  while [ -d "$ROOT_DIR/output/${i}" ]; do
    i=$((i + 1))
  done
  local dirname="${i}"
  local output_dir="$ROOT_DIR/output/$dirname"
  mkdir "$output_dir"
  printf '%s\n' "$session_id" >"$output_dir/opencodeSessionId"
  echo "$role" >"$output_dir/job.txt"

  local resume_data=$(generate_resume_data "$role" "$session_id") || exit $?

  view_cv_diff "$resume_data"
  job_menu "$resume_data" "$session_id" "$dirname"
}

load_cv() {
  mkdir -p "$ROOT_DIR/output"
  local output_dir=$(
    find "$ROOT_DIR/output" -mindepth 1 -maxdepth 1 -type d |
      awk -F/ '{print $NF "\t" $0}' |
      fzf --delimiter=$'\t' --with-nth=1 |
      awk -F'\t' '{print $2}'
  )
  local dirname=$(basename "$output_dir")

  local role=$(cat "$output_dir/job.txt" 2>/dev/null)
  local resume_data=$(cat "$output_dir/data.yaml" 2>/dev/null)
  local session_id=$(cat "$output_dir/opencodeSessionId" 2>/dev/null)

  if ! is_opencode_session "$session_id"; then
    local context=$(generate_context_prompt "$role" "$resume_data")
    session_id=$(init_opencode_session "$context")
    printf '%s\n' "$session_id" >"$output_dir/opencodeSessionId"
  fi

  echo "Session id: $session_id"

  if [ -z "$resume_data" ]; then
    local resume_data=$(generate_resume_data "$role" "$session_id") || exit $?
  fi

  job_menu "$resume_data" "$session_id" "$dirname"
}

fix_errors() {
  local resume_data=$1
  local session_id=$2
  local dirname=$3

  read -rp "Fix errors? [Y]es/[N]o" ans
  case "$ans" in
  [Nn]*) echo "Cancelling..." >&2 ;;
  [Yy]*)
    res=$(edit "$resume_data")
    job_menu "$res" "$session_id" "$dirname"
    ;;
  *)
    echo "Invalid option" >&2
    job_menu "$resume_data" "$session_id" "$dirname"
    ;;
  esac
}

view_cv_diff() {
  local resume_data=$1

  git diff --no-index --color "$ROOT_DIR/resume.yaml" <(echo "$resume_data")
}

job_menu() {
  local resume_data=$1
  local session_id=$2
  local dirname=$3

  read -rp "Job Menu [C]ompile/[D]iff/[S]ugest/[E]dit/Cover [L]etter/[O]pen Agent/[N]ew " answer
  case "$answer" in
  [Cc]*)
    compile "$resume_data" "$session_id" "$dirname"
    if [ "$?" -ne 0 ]; then
      fix_errors "$resume_data" "$session_id"
    else
      echo "$dirname/cv.pdf generated!" >&2
    fi
    ;;
  [Dd]*)
    view_cv_diff "$resume_data"
    job_menu "$resume_data" "$session_id" "$dirname"
    ;;
  [Ss]*)
    echo "Write your suggestions for a new version. Press Ctrl+D when done:" >&2
    local sugestions=$(cat)
    resume_data=$(sugest "$sugestions" "$session_id")
    view_cv_diff "$resume_data"
    job_menu "$resume_data" "$session_id" "$dirname"
    ;;
  [Ee]*)
    resume_data=$(edit "$resume_data")
    job_menu "$resume_data" "$session_id" "$dirname"
    ;;
  [Ll]*)
    cover_letter "$resume_data" "$session_id" "$dirname"
    job_menu "$resume_data" "$session_id" "$dirname"
    ;;
  [Nn]*)
    echo "Paste the job description. Press Ctrl+D when done:"
    local role=$(cat)
    new_cv "$role"
    ;;
  [Oo]*)
    attach_opencode "$session_id"
    job_menu "$resume_data" "$session_id" "$dirname"
    ;;
  [Mm]*)
    echo "Going back to Main Menu..."
    ;;
  *)
    echo "Invalid option" >&2
    job_menu "$resume_data" "$session_id" "$dirname"
    ;;
  esac
}

RUNNING=true

main_menu() {
  read -rp "Main Menu [N]ew/[L]oad/[Q]uit " answer
  case "$answer" in
  [Nn]*)
    echo "Paste the job description. Press Ctrl+D when done:"
    local role=$(cat)
    new_cv "$role"
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
