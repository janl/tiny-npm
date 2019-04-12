# tiny-npm

A bunch of scripts to tinker with npm registry data.

Use at your own risk, mostly written for BSD-sh and BSD utils, not GNU utils or bash, only ever tested on FreeBSD 11.

ZFS ftw.


Get a list of all packages:

```
curl https://replicate.npmjs.com/registry/_changes > _changes.json
grep -Eo id\":\"\[^\"\]+\" _changes.json | sed -e s/id\":\"// | sed -e s/\"// >all.txt # -E might be GNU grep only
```

Download all .tgz files for a package:

```
./dl-tiny.sh package
```

Unzip, but not untar all .tgz files for a package

```
./tar-tiny.sh
```

Make a dedicated ZFS pool with custom compression settings and copy all unzipped tarballs over

```
./zfs-tiny.sh
```


```
All run on FreeBSD 11

All tarballs from the [top 1000 npm packages](https://gist.github.com/anvaka/8e8fa57c7ee1350e3491)
unzipped and copied onto pristine ZFS volumes.

Sum of all original .tgz file sizes: 28GB
Sum of all unzipped .tar files: 35GB

List of compression types/configs and their compression ratios:

all_gzip-5                                    compressratio  4.11x  -
all_gzip-9                                    compressratio  4.20x  -
all_lz4                                       compressratio  2.79x  -
all_lzjb                                      compressratio  2.10x  -
all_zle                                       compressratio  1.06x  -

And for fun, one ZFS volume with deduplication enabled:      1.13x

gzip-9 and deduplication is rather slow, and given that gzip-5 gives a nearly
equally good result, that’s probably where this needs to live.

It would be fun to see the dedupe ratio on the full data set, but I don’t
expect this to change a lot.





* * *


3 popular packages


6.0M	original    # sum of all .tgz file sizes
 28M	tar         # sum or all .tar files
5.4M	async-all.tgz (1.1x) # size of all tar files compressed together with tar czf
3.6M	async-all.tbz (1.6x) # size of all tar files compressed together with tar cjf

List of compressratios on ZFS file systems with varying compression options
async-gzip-1                                  compressratio  4.11x  -
async-gzip-3                                  compressratio  4.40x  -
async-gzip-5                                  compressratio  4.81x  -
async-gzip-7                                  compressratio  4.92x  -
async-gzip-9                                  compressratio  4.95x  -
async-lz4                                     compressratio  1.00x  -
async-lzjb                                    compressratio  2.36x  -
async-zle                                     compressratio  1.20x  -

 82M	original
202M	tar
 74M	lodash-all.tgz (1.1x)
 66M	lodash-all.tbz (1.2x)
lodash-gzip-1                                 compressratio  2.14x  -
lodash-gzip-3                                 compressratio  2.49x  -
lodash-gzip-5                                 compressratio  2.59x  -
lodash-gzip-7                                 compressratio  2.61x  -
lodash-gzip-9                                 compressratio  2.61x  -
lodash-lz4                                    compressratio  2.18x  -
lodash-lzjb                                   compressratio  1.76x  -
lodash-zle                                    compressratio  1.23x  -

 25M	original
138M	tar
 23M	express-all.tgz (1.1x)
 16M	express-all.tbz (1.6x)
express-gzip-1                                compressratio  4.74x  -
express-gzip-3                                compressratio  5.00x  -
express-gzip-5                                compressratio  5.52x  -
express-gzip-7                                compressratio  5.63x  -
express-gzip-9                                compressratio  5.65x  -
express-lz4                                   compressratio  3.91x  -
express-lzjb                                  compressratio  1.00x  -
express-zle                                   compressratio  1.20x  -
```
