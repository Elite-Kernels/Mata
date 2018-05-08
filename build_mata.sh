#!/bin/bash

# Path to build your kernel
  k=~/kernel/mata
# Directory for the any kernel updater
  t=$k/packages
# Date to add to zip
  today=$(date +"%m_%d_%Y")

# Clean old builds
#   echo "Clean"
#     rm -rf $k/out
#     make clean

# Setup the build
 cd $k/arch/arm64/configs/BBKconfigs
    for c in *
      do
        cd $k
# Setup output directory
    mkdir -p "out/$c"
    mkdir -p "out/$c/system/lib/modules/"
    cp -R "$t/system" out/$c
    cp -R "$t/META-INF" out/$c
    cp -R "$t/patch" out/$c
    cp -R "$t/ramdisk" out/$c
    cp -R "$t/tools" out/$c
    cp -R "$t/anykernel.sh" out/$c

  m=$k/out/$c/system/lib/modules
  z=$c-$today

#TOOLCHAIN=/home/forrest/kernel/gcc-linaro-6.4.1/bin/aarch64-linux-gnu-
export CLANG_PATH=/home/forrest/kernel/clang5/bin
export PATH=${CLANG_PATH}:${PATH}
export LD_LIBRARY_PATH=/home/forrest/kernel/clang5/lib64:${LD_LIBRARY_PATH}
export CLANG_TRIPLE=aarch64-linux-gnu-
export CROSS_COMPILE=/home/forrest/kernel/gcc4.9_aarch64/bin/aarch64-linux-android-
export ARCH=arm64
export SUBARCH=arm64

# make mrproper
#make CROSS_COMPILE=$TOOLCHAIN -j`grep 'processor' /proc/cpuinfo | wc -l` mrproper
 
# remove backup files
find ./ -name '*~' | xargs rm
# rm compile.log

# make kernel

make O=out CC=clang elite_kasan_defconfig
make O=out CC=clang -j`grep 'processor' /proc/cpuinfo | wc -l`

# Grab zImage-dtb
#   echo ""
#   echo "<<>><<>>  Collecting modules <<>><<>>"
#   echo ""
#   for mo in $(find . -name "*.ko"); do
#		cp "${mo}" $m
   echo ""
   echo "<<>><<>>  Collecting Image.gz-dtb <<>><<>>"
   echo ""
   cp $k/out/arch/arm64/boot/Image.gz-dtb out/$c/zImage
   done
   
# Build Zip
 clear
   echo "Creating $z.zip"
     cd $k/out/$c/
       7z a -tzip -mx5 "$z.zip"
         mv $z.zip $k/out/$z.zip
# cp $k/out/$z.zip $db/$z.zip
#           rm -rf $k/out/$c
# Line below for debugging purposes,  uncomment to stop script after each config is run
#read this
#      done
