#!/usr/bin/env bash

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

  res=$(prettierd teste.yaml <"$out")

  rm -f "$err" "$out"

  echo "$res"
}

edit() {
  value=$1
  tmp=$(mktemp)

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
    --input data="../output/cv${i}/data.yaml" \
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
  *)
    echo "Invalid option" >&2
    confirm_cv "$resume_data" "$session_id"
    ;;
  esac
}

generate_cv() {
  echo "Paste the job description. Press Ctrl+D when done:"
  local role=$(cat)

  i=1
  while [ -d "$ROOT_DIR/output/cv${i}" ]; do
    i=$((i + 1))
  done

  local job_id="cv${i}"
  OUTPUT_DIR="$ROOT_DIR/output/$job_id"
  mkdir "$OUTPUT_DIR"
  echo $role >>"$OUTPUT_DIR/job.txt"
  tmp=$(mktemp)

  opencode run "/custom-cv" \
    --model opencode/mimo-v2.5-free \
    --format json 2>/dev/null |
    jq -r '.sessionID? // empty' >"$tmp" &

  pid=$!
  spinner "$pid" "Starting OpenCode session" >&2
  wait "$pid" || true
  printf '\r\033[K' >&2

  session_id=$(head -n1 "$tmp")
  printf '\nRunning on %s\n' "$session_id" >&2
  rm -f "$tmp"
  echo $session_id >"$OUTPUT_DIR/opencodeSessionId"

  local resume_data=$(generate_resume_data "$role" "$session_id") || exit $?

  confirm_cv "$resume_data" "$session_id"
}

while true; do
  generate_cv
done
