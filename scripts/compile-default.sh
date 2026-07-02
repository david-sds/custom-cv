#!/usr/bin/env bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$SCRIPT_DIR/.."
cd $ROOT_DIR

mkdir -p "$ROOT_DIR/output/default/"

typst compile "$ROOT_DIR/templates/david-sds.typ" \
  --root="$ROOT_DIR" \
  --input data="../resume.yaml" \
  "$ROOT_DIR/output/default/cv.pdf"
