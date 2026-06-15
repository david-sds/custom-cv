#!/usr/bin/env bash

SOURCE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_NAME="$(basename "$SOURCE_DIR")"
SKILLS_DIR="${HOME}/.agents/skills"

mkdir -p "$SKILLS_DIR"

ln -sfn "$SOURCE_DIR" "${SKILLS_DIR}/${SKILL_NAME}"
