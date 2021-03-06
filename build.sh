#!/bin/bash
# simple bash script for executing build

RDIR=$(pwd)

TOOLCHAIN=/home/jc/build/toolchain/arm-cortex_a9-linux-gnueabihf-linaro_4.9.4-2015.06

THREADS=5

[ -z $VERSION ] && \
# version number
VERSION=$(cat $RDIR/VERSION)

export ARCH=arm
export CROSS_COMPILE=$TOOLCHAIN/bin/arm-cortex_a9-linux-gnueabihf-
export LOCALVERSION=$VERSION

cd $RDIR

[ -z "$1" ] && {
	DEFCONFIG=grouper_defconfig
} || {
	DEFCONFIG=${1}_defconfig
}

FILE=arch/arm/configs/$DEFCONFIG

[ -e "$FILE" ] || {
	echo "Defconfig not found: $FILE"
	exit -1
}

echo "Cleaning build..."
rm -rf build
mkdir build

make -C $RDIR O=build $DEFCONFIG
echo "Starting build..."
make -C $RDIR O=build -j"$THREADS"

echo "Done."
