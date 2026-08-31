#!/usr/bin/env bash

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="${HOME}/.agents/skills"

mkdir -p "$SKILLS_DIR"

for skill in "${SOURCE_DIR}"/skills/*/; do
  SKILL_NAME="$(basename "$skill")"
  [ -f "$skill/SKILL.md" ] || continue
  ln -sfn "$skill" "${SKILLS_DIR}/${SKILL_NAME}"
  echo "Installed ${SKILL_NAME}"
done
