#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"

source "$SCRIPT_DIR/utils.sh"

require opencode

is_opencode_session() {
  local session_id=$1
  [ -n "$session_id" ] || return 1
  opencode session list |
    awk '{print $1}' |
    grep -qx "$session_id"
}

init_opencode_session() {
  tmp=$(mktemp)
  local data=$1

  opencode run "${data}" \
    --model opencode/big-pickle \
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

prompt_opencode() {
  local prompt=$1
  local session_id=$2
  local loading_msg=${3:-"Loading"}
  local err out pid status

  err=$(mktemp) || return 1
  out=$(mktemp) || {
    rm -f "$err"
    return 1
  }

  opencode run "$prompt" -s "$session_id" 2>"$err" >"$out" &

  pid=$!
  spinner "$pid" "$loading_msg" >&2
  wait "$pid"
  printf '\r\033[K' >&2
  status=$?

  if [ "$status" -ne 0 ]; then
    cat "$err" >&2
    rm -f "$err" "$out"
    return "$status"
  fi

  res=$(cat "$out")
  rm -f "$err" "$out"

  printf '%s\n' "$res"
}

attach_opencode() {
  local session_id=$1

  opencode -s "$session_id"
}
