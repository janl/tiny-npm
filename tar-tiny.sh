#!/bin/sh

P=$1

if [ -z "$P" ]; then
    echo Usage: $0 package
    exit 1
fi

# unzip tarballs in new dir
PFS=`echo $P | sed -e s,/,_,g`
cd $PFS

mkdir -p tar

cd tar

FILES=`ls ../original/*`

echo unzipping all tgz files
for file in $FILES; do
    target=`basename $file | sed -e s/tgz/tar/`
    # -kdc keep, decompress, to stdout
    if [ ! -f "$target" ]; then
	gzip -kdc $file > $target
    fi
done

cd ..

if [ ! -f "$PFS-all.tgz" ]; then
    echo gzipping all .tar files
    tar czf $PFS-all.tgz tar
fi

if [ ! -f "$PFS-all.tbz" ]; then
    echo bzipping all .tar files
    tar cjf $PFS-all.tbz tar
fi

du -h original tar $PFS-all.tgz $PFS-all.tbz

cd ..
