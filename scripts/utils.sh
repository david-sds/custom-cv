#!/usr/bin/env bash

require() {
  command -v "$1" &>/dev/null && return
  printf "Required tool missing: %s\n" "$1" >&2
  exit 1
}

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
