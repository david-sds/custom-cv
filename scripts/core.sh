#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/.."

source "$SCRIPT_DIR/utils.sh"
source "$SCRIPT_DIR"/agents/*.sh

require prettierd
require typst

generate_context_prompt() {
  local role=$1, resume_data=$2

  local context=$(
    cat <<-EOF_DELIM
    /custom-curriculum

    Role description:
    \`\`\`
    $role
    \`\`\`

    Resume data:
    \`\`\`yaml
    $resume_data
    \`\`\`
EOF_DELIM
  )

  printf '%s\n' "$context"
}

generate_resume_data() {
  local role=$1
  local session_id=$2

  local out=$(prompt_opencode "$role" "$session_id" "Generating customized resume.yaml" |
    sed '/^```yaml$/d; /^```$/d')

  res=$(printf "%s\n" "$out" | prettierd .yaml)

  printf '%s\n' "$res"
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
  local sugestions=$1
  local session_id=$2

  local resume_data=$(generate_resume_data "$sugestions" "$session_id") || exit $?

  printf '%s\n' "$resume_data"
}

cover_letter() {
  local resume_data=$1
  local session_id=$2
  local dirname=$3
  local output_dir="$ROOT_DIR/output/$dirname"

  local res=$(prompt_opencode "/custom-cover-letter" "$session_id" "Generating cover letter")

  echo "$res" >"$output_dir/cover-letter.txt"

  printf '%s\n' "$res"
}

compile() {
  local resume_data=$1
  local session_id=$2
  local dirname=$3
  local output_dir="$ROOT_DIR/output/$dirname"

  echo "$resume_data" >"$output_dir/data.yaml"

  typst compile "$ROOT_DIR/templates/david-sds.typ" \
    --root "$ROOT_DIR" \
    --input data="../output/$dirname/data.yaml" \
    "$output_dir/cv.pdf"
}
