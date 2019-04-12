#!/bin/sh

P=$1

if [ -z "$P" ]; then
    echo Usage: $0 package
    exit 1
fi

# make per package dir

PFS=`echo $P | sed -e s,/,_,g` # encode slashes
mkdir -p $PFS
cd $PFS

# download json
echo Downloading $P.json
curl -so $PFS https://registry.npmjs.com/$P
mv $PFS $PFS.json

# grep all tgz urls from json
URLS=$(cat $PFS.json | jq .versions[].dist.tarball | sed -e s/\"//g)
URLS_COUNT=$(cat $PFS.json | jq .versions[].dist.tarball | sed -e s/\"//g | wc -l)
# download all tgz files
echo Attempting to download $URLS_COUNT files

mkdir -p original
cd original

echo $URLS | xargs -L 1 -n 1 -P 25 curl -sO

cd .. # original

cd .. # $PFS

echo Managed to get `ls $PFS/original/* | wc -l`

