#!/bin/sh
set -eu

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 PORT" >&2
    exit 1
fi

docker run --rm --platform linux/amd64 -p "127.0.0.1:$1:8888" \
    -v "$PWD:/home/neo/notebook_workspace" my_notebook:0.0
