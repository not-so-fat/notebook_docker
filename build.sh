#!/bin/bash
set -eu

repo_dir=$(cd -- "$(dirname -- "$0")" && pwd)
docker build --platform linux/amd64 -t my_notebook:0.0 --build-arg "USERID=$(id -u)" "$repo_dir"
