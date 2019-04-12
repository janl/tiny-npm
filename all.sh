#!/bin/sh

TOP=`cat ~/top1000.txt`

for package in $TOP; do
    ./dl-tiny.sh $package
done

