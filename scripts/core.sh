#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/.."

source "$SCRIPT_DIR/utils.sh"
source "$SCRIPT_DIR/core.sh"
source "$SCRIPT_DIR"/agents/*.sh

require prettierd

generate_context_prompt() {
  local role=$1, resume_data=$2

  local context=$(
    cat <<-EOF_DELIM
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
    sed '/^```yaml$/d; /^```$/d' >"$out")

  res=$(prettierd .yaml <"$out")

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
  local sugestions=$2
  local session_id=$1

  local resume_data=$(generate_resume_data "$sugestions" "$session_id") || exit $?

  printf '%s\n' "$resume_data"
}

cover_letter() {
  local resume_data="$1"
  local session_id="$2"
  local prompt="Now write me a cover letter in plain text based on this role and my profile."

  local res=$(prompt_opencode "$prompt" "$session_id" "Generating cover letter")

  printf '%s\n' "$res"
}
