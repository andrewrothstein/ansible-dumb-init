#!/usr/bin/env sh
VER=${1:-1.2.2}
DIR=~/Downloads
APP=dumb-init
MIRROR=https://github.com/Yelp/dumb-init/releases/download/v${VER}
CHECKSUMS=${APP}_${VER}_checksums.txt
CHECKSUMS_URL=$MIRROR/sha256sums
if [ ! -e $DIR/$CHECKSUMS ];
then
    wget -q -O $DIR/$CHECKSUMS $CHECKSUMS_URL
fi

dl()
{
    local arch=$1
    local file=${APP}_${VER}_${arch}
    local url=$MIRROR/$file
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $arch `egrep -e "$file\$" $DIR/$CHECKSUMS | awk '{print $1}'`
}

printf "  # %s\n" $CHECKSUMS_URL
printf "  '%s':\n" $VER

dl amd64
dl ppc64el
dl s390x
