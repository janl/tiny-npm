#!/bin/sh
P=$1

if [ -z "$P" ]; then
    echo Usage: $0 package
    exit 1
fi

./dl-tiny.sh $P
./tar-tiny.sh $P

