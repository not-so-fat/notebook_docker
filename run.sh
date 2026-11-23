#!/bin/sh
set -eu

if [ "$#" -eq 0 ] || [ "$#" -gt 2 ] || { [ "$#" -eq 2 ] && [ "$2" != --detach ]; }; then
    echo "Usage: $0 PORT [--detach]" >&2
    exit 1
fi

port=$1
shift
if [ -n "${PLATFORM:-}" ]; then
    set -- "$@" --platform "$PLATFORM"
fi
exec docker run "$@" --rm -p "127.0.0.1:$port:8888" \
    -v "$PWD:/home/neo/notebook_workspace" my_notebook:0.0
