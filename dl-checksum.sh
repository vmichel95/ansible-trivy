#!/usr/bin/env sh
DIR=~/Downloads
APP=trivy
MIRROR=https://github.com/aquasecurity/${APP}/releases/download

dl()
{
    local ver=$1
    local checksums=$2
    local os=$3
    local arch=$4
    local archive_type=${5:-tar.gz}
    local platform=${os}-${arch}
    local file=${APP}_${ver}_${platform}.$archive_type

    printf "    %s: sha256:%s\n" $platform `fgrep $file $DIR/$checksums | awk '{print $1}'`
}

dl_ver() {
    local ver=$1
    local mirror=$MIRROR/v${ver}

    local checksums=${APP}_${ver}_checksums.txt
    if [ ! -e $DIR/$checksums ];
    then
        wget -q -O $DIR/$checksums $mirror/$checksums
    fi


    printf "  # %s\n" $mirror/$checksums
    printf "  '%s':\n" $ver

    dl $ver $checksums FreeBSD 32bit
    dl $ver $checksums OpenBSD 32bit
    dl $ver $checksums Linux 32bit
    dl $ver $checksums OpenBSD ARM
    dl $ver $checksums Linux 64bit
    dl $ver $checksums FreeBSD ARM
    dl $ver $checksums Linux ARM
    dl $ver $checksums Linux ARM64
    dl $ver $checksums macOS 64bit
    dl $ver $checksums macOS 32bit
    dl $ver $checksums OpenBSD 64bit
    dl $ver $checksums FreeBSD 64bit
}

dl_ver ${1:-0.4.3}
