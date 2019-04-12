#!/bin/sh
P=$1

if [ -z "$P" ]; then
    echo Usage: $0 package
    exit 1
fi


cd $P
mkdir -p zfs
cd zfs


COMPRESSIONS="lzjb gzip-1 gzip-3 gzip-5 gzip-7 gzip-9 zle lz4"

for COMPRESSION in $COMPRESSIONS; do
    echo setting up $COMPRESSION

    PC=$P-$COMPRESSION
    POOLFILE=pool_$PC
    echo $POOLFILE
    # create zfs backing file
    if [ ! -f "pool_$PC" ]; then
	echo create backing file $POOLFILE
	dd if=/dev/zero of=$POOLFILE bs=4k count=256000 # 500MB
    fi

    # create zpool on backing file
    if [ ! -f "/$PC/.created" ]; then
	echo create zpool $PC
	zpool create $PC `pwd`/$POOLFILE
	touch "/$PC/.created"
    fi

    # set compression=on (lz)
    echo enable compression
    zfs set compression=$COMPRESSION $PC

    # check backing file size
    #  - if zerofilled or whatever, see if we can get real size
    echo file system usage BEFORE copying all .tar files
    zpool iostat $PC

    # copy over all the .tar files

    if [ ! -d "/$PC/tar" ]; then
	echo copy tar files
	cp -r ../tar /$PC/
    fi

    # show backing file size again
    echo file system usage AFTER copying all .tar files
    zpool iostat $PC

    # show compressratio
    zfs get compressratio $PC
    echo
    echo
    echo "************************************"
    echo
    echo
done

zfs get compressratio | grep $P
