#!/usr/bin/env bash

RUNNING=true

require() {
  command -v "$1" &>/dev/null && return
  printf "Required tool missing: %s\n" "$1" >&2
  exit 1
}

require typst
require opencode
require jq
require prettierd
require fzf

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/.."

spinner() {
  local pid=$1
  local msg=${2:-"Working"}
  local spin='|/-\'

  while kill -0 "$pid" 2>/dev/null; do
    printf "\r\033[K[%c] %s..." "${spin:0:1}" "$msg"
    spin="${spin:1}${spin:0:1}"
    sleep 0.1
  done
}

generate_resume_data() {
  local role=$1
  local session_id=$2
  local err out pid status

  err=$(mktemp) || return 1
  out=$(mktemp) || {
    rm -f "$err"
    return 1
  }

  opencode run "$role" -s "$session_id" 2>"$err" |
    sed '/^```yaml$/d; /^```$/d' >"$out" &

  pid=$!
  spinner "$pid" "Generating customized resume.yaml" >&2
  wait "$pid"
  printf '\r\033[K' >&2
  status=$?

  if [ "$status" -ne 0 ]; then
    cat "$err" >&2
    rm -f "$err" "$out"
    return "$status"
  fi

  res=$(prettierd .yaml <"$out")

  rm -f "$err" "$out"

  echo "$res"
}

edit() {
  value=$1
  tmp=$(mktemp --suffix=.yaml resume.XXXXXX)

  printf '%s' "$value" >"$tmp"

  ${VISUAL:-${EDITOR:-vi}} "$tmp" </dev/tty >/dev/tty 2>&1

  value=$(cat "$tmp")
  rm "$tmp"

  printf '%s\n' "$value"
}

sugest() {
  local session_id=$1

  echo "Write your suggestions for a new version. Press Ctrl+D when done:" >&2
  local sugestions=$(cat)

  local resume_data=$(generate_resume_data "$sugestions" "$session_id") || exit $?

  printf '%s\n' "$resume_data"
}

compile() {
  local resume_data=$1
  local session_id=$2

  echo "$resume_data" >"$OUTPUT_DIR/data.yaml"

  typst compile "$ROOT_DIR/templates/david-sds.typ" \
    --root "$ROOT_DIR" \
    --input data="../$OUTPUT_SUB_DIR/data.yaml" \
    "$OUTPUT_DIR/cv.pdf"

  if [ "$?" -ne 0 ]; then
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

  else
    echo "$OUTPUT_DIR/cv.pdf generated!" >&2
  fi
}

cover_letter() { # TODO
}

confirm_cv() {
  local resume_data="$1"
  local session_id="$2"
  git diff --no-index --color "$ROOT_DIR/resume.yaml" <(echo "$resume_data")

  read -rp "Apply changes? [Y]es/[N]o/[S]ugest/[E]dit " answer
  case "$answer" in
  [Nn]*) echo "Cancelling..." >&2 ;;
  [Yy]*)
    compile "$resume_data" "$session_id"
    ;;
  [Ss]*)
    local res=$(sugest "$session_id")
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

is_opencode_session() {
  local session_id=$1
  [ -n "$session_id" ] || return 1
  opencode session list |
    awk '{print $1}' |
    grep -qx "$session_id"
}

start_opencode_session() {
  tmp=$(mktemp)
  local data=$1

  opencode run "/custom-cv ${data}" \
    --model opencode/mimo-v2.5-free \
    --format json 2>/dev/null |
    jq -r '.sessionID? // empty' >"$tmp" &

  local session_pid=$!

  spinner "$session_pid" "Starting OpenCode session" >&2
  wait "$session_pid" || return 1
  printf '\r\033[K' >&2

  local session_id=$(head -n1 "$tmp")
  echo "$session_id"

  rm -f "$tmp"
}

generate_cv() {
  echo "Paste the job description. Press Ctrl+D when done:"
  local role=$(cat)

  local session_id=$(start_opencode_session "$role")
  echo "Session id: $session_id"

  i=1
  while [ -d "$ROOT_DIR/output/${i}" ]; do
    i=$((i + 1))
  done
  OUTPUT_SUB_DIR="output/${i}"
  OUTPUT_DIR="$ROOT_DIR/$OUTPUT_SUB_DIR"
  mkdir "$OUTPUT_DIR"
  printf '%s\n' "$session_id" >"$OUTPUT_DIR/opencodeSessionId"
  echo "$role" >>"$OUTPUT_DIR/job.txt"

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
    local context=$(cat <<EOF_DELIM
Role description:
```
$role
```

Resume data:
```yaml
$resume_data
```
EOF_DELIM)
    session_id=$(start_opencode_session "$context")
    printf '%s\n' "$session_id" >"$OUTPUT_DIR/opencodeSessionId"
  fi

  if [ -n "$resume_data" ]; then
    confirm_cv "$resume_data" "$session_id"
  else
    local resume_data=$(generate_resume_data "$role" "$session_id") || exit $?

    confirm_cv "$resume_data" "$session_id"
  fi
}

main_menu() {
  read -rp "Main Menu [N]ew/[L]oad/[Q]uit/ " answer
  case "$answer" in
  [Nn]*)
    generate_cv
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
