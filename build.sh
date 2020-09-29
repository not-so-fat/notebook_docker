#!/bin/bash

USERID=`id -u`
PASSWORD=$1

if [ $# -eq 0 ]
  then
    echo "No password supplied"
    exit 1
fi

echo $USERID
docker build -t my_notebook:0.0 --build-arg USERID=$USERID --build-arg PASSWORD=$PASSWORD ./
