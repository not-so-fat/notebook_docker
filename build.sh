#!/bin/bash

USERID=`id -u`
PASSWORD=$1
echo $USERID
docker build -t my_notebook:0.0 --build-arg USERID=$USERID --build-arg PASSWORD=$PASSWORD ./
