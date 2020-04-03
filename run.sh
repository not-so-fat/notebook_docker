#!/bin/sh

PORT=$1
docker run --rm -p ${PORT}:8888 -v $(pwd):/home/neo/notebook_workspace my_notebook:0.0
