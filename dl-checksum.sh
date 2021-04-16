#!/usr/bin/env sh
set -e
DIR=~/Downloads
MIRROR=https://github.com/Yelp/dumb-init/releases/download

dl()
{
    local ver=$1
    local lchecksums=$2
    local arch=$3
    local file="dumb-init_${ver}_${arch}"
    local url=$MIRROR/v${ver}/$file
    printf "    # %s\n" $url
    printf "    %s: sha256:%s\n" $arch $(egrep -e "$file\$" $lchecksums | awk '{print $1}')
}

dl_ver ()
{
    local ver=$1
    local checksums="dumb-init_${ver}_checksums.txt"
    local lchecksums=$DIR/$checksums
    local checksums_url="$MIRROR/v${ver}/sha256sums"
    if [ ! -e $lchecksums ];
    then
        wget -q -O $lchecksums $checksums_url
    fi
    printf "  # %s\n" $checksums_url
    printf "  '%s':\n" $ver

    dl $ver $lchecksums x86_64
    dl $ver $lchecksums ppc64le
    dl $ver $lchecksums s390x
}

dl_ver ${1:-1.2.5}
