#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/.."
ROLE="$1"

ERR=$(mktemp)
RES=$(
  opencode run "$ROLE" 2>"$ERR" |
    sed '/^```yaml$/d; /^```$/d'
)
STATUS=$?

if [ $STATUS -ne 0 ]; then
  cat "$ERR"
  rm -f "$ERR"
  exit $STATUS
fi

RESUME=$(printf '%s\n' "$RES" | prettierd teste.yaml)

git diff --no-index --color \
  "$ROOT_DIR/resume.yaml" \
  <(printf '%s\n' "$RES" | prettierd teste.yaml) | less -R

read -rp "Apply changes? [Y/n] " answer
case "$answer" in
[Nn]*) echo "No" ;;
[Yy]*) echo "Yes" ;;
*) echo "Invalid option" ;;
esac
