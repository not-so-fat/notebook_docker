#!/bin/bash
set -eu

repo_dir=$(cd -- "$(dirname -- "$0")" && pwd)
set --
if [ -n "${PLATFORM:-}" ]; then
    set -- --platform "$PLATFORM"
fi
docker build "$@" -t my_notebook:0.0 --build-arg "USERID=$(id -u)" "$repo_dir"
