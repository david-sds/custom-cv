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

compile() {
  local resume_data="$1"

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
      confirm_cv "$res"
      ;;
    *)
      echo "Invalid option" >&2
      confirm_cv "$resume_data"
      ;;
    esac

  else
    echo "$OUTPUT_DIR/cv.pdf generated!" >&2
  fi
}

confirm_cv() {
  local resume_data="$1"
  git diff --no-index --color "$ROOT_DIR/resume.yaml" <(echo "$resume_data")

  read -rp "Apply changes? [Y]es/[N]o/[E]dit " answer
  case "$answer" in
  [Nn]*) echo "Cancelling..." >&2 ;;
  [Yy]*)
    compile "$resume_data"
    ;;
  [Ee]*)
    res=$(edit "$resume_data")
    confirm_cv "$res"
    ;;
  *)
    echo "Invalid option" >&2
    confirm_cv "$resume_data"
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
  echo $role >"$OUTPUT_DIR/job.txt"
  tmp=$(mktemp)

  opencode run "/custom-cv" --format json 2>/dev/null |
    jq -r '.sessionID? // empty' >"$tmp" &

  pid=$!
  spinner "$pid" "Starting OpenCode session" >&2
  wait "$pid" || true

  session_id=$(head -n1 "$tmp")
  rm -f "$tmp"
  echo $session_id >"$OUTPUT_DIR/opencodeSessionId"

  RESUME_DATA=$(generate_resume_data "$role" "$session_id") || exit $?

  confirm_cv "$RESUME_DATA"
}

while true; do
  generate_cv
done
