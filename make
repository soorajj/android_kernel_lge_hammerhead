#!/bin/bash

KER_NAME="Sooplus"
DAY=$(date +"%d")
MONTH=$(date +"%m")
BASE_KER_VER=$MONTH.$DAY
CODENAME="hammerhead"
AUTHOR="soorajj"
OUT_DIR="kernel_flashable"
TOOLCHAIN_DIR=~/android/toolchain/arm-cortex_a15-linux-gnueabihf-linaro_4.9.3-2015.01/bin/arm-cortex_a15-linux-gnueabihf-
export LOCALVERSION="-"`echo $KER_NAME~$BASE_KER_VER`
export CROSS_COMPILE=$TOOLCHAIN_DIR
export ARCH=arm
export SUBARCH=arm
export KBUILD_BUILD_USER="soorajj"
export KBUILD_BUILD_HOST="me.com"
echo 
echo "Making defconfig"
DATE=$(date +"%d-%m-%Y-%H.%M.%S")
COMPILER="LINARO-4.9"
ARCHIVE_FILE="$KER_NAME~$BASE_KER_VER-$CODENAME-$COMPILER-$DATE"

make "cyanogenmod_hammerhead_defconfig"

echo "LOCALVERSION="$LOCALVERSION
echo "CROSS_COMPILE="$CROSS_COMPILE
echo "ARCH="$ARCH

echo "Start of build: $DATE...";
sleep 3
echo "kernel version: $KER_NAME~$BASE_KER_VER...";
script -q ~/android/logs/$ARCHIVE_FILE.txt -c "
make -j16 "

echo "Build completed."
echo "Copying zImage to flashable zip."
cp arch/arm/boot/zImage-dtb kernel_flashable/kernel/zImage
find . -name '*ko' -exec cp '{}' kernel_flashable/system/lib/modules/ \;

echo "[BUILD]: Changing aroma version/data/device to: $ARCHIVE_FILE...";
sed -i "/ini_set(\"rom_name\",/c\ini_set(\"rom_name\", \""$KER_NAME"\");" $OUT_DIR/META-INF/com/google/android/aroma-config
sed -i "/ini_set(\"rom_version\",/c\ini_set(\"rom_version\", \""$BASE_KER_VER"\");" $OUT_DIR/META-INF/com/google/android/aroma-config
sed -i "/ini_set(\"rom_date\",/c\ini_set(\"rom_date\", \""$DATE"\");" $OUT_DIR/META-INF/com/google/android/aroma-config
sed -i "/ini_set(\"rom_device\",/c\ini_set(\"rom_device\", \""$CODENAME"\");" $OUT_DIR/META-INF/com/google/android/aroma-config
sed -i "/ini_set(\"rom_author\",/c\ini_set(\"rom_author\", \""$AUTHOR"\");" $OUT_DIR/META-INF/com/google/android/aroma-config

cd $OUT_DIR
find . -name '*zip' -exec cp '{}' ~/my-works/ \;
find . -name '*zip' -exec rm '{}' \;
zip -r `echo $ARCHIVE_FILE`.zip *
find . -name '*zip' -exec cp '{}' ~/my-works/ \;
echo "Flashable zip made."
echo "cleaning."
find . -name '*ko' -exec rm '{}' \;
find . -name 'zImage' -exec rm '{}' \;
cd ../
make "clean"
make "mrproper"
git clean -f -d
git reset --hard
echo "everything completed."
echo "End of build: $DATE...";
exit
