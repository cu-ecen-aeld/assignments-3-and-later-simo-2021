#!/bin/bash
# Script to install and build kernel.
# Author: Siddhant Jajoo.
# Modified by: Arnaud Simo, 28.01.2025         
# 4 éléments clés de Linux embarqué:
#1_Bootloader, 2_Noyau, 3_RootFS, 4_Bibliothèques/Outils) :

set -e
set -u  # Exit on unset variables

#********************** Configuration Initiale ***********************************#
OUTDIR=${1:-/tmp/aeld}  # Default output directory if not provided as an argument
KERNEL_REPO="git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git"
KERNEL_VERSION="v5.15.163"
BUSYBOX_VERSION="1_33_1"
FINDER_APP_DIR=$(realpath $(dirname "$0"))
ARCH="arm64"
CROSS_COMPILE="aarch64-none-linux-gnu-"
SYSROOT=$(${CROSS_COMPILE}gcc --print-sysroot) ### Racine des bibliothèques cibles
#********************************************************************************#

mkdir -p "${OUTDIR}"
cd "${OUTDIR}"

#******************* Clone and build the Linux kernel_1.c ************************#
if [ ! -d "linux-stable" ]; then
    echo "Cloning Linux stable version ${KERNEL_VERSION}..."
    git clone --depth 1 --branch "${KERNEL_VERSION}" "${KERNEL_REPO}" ## 1.a
fi

cd linux-stable
if [ ! -e "arch/${ARCH}/boot/Image" ]; then
    echo "Building Linux Kernel..."
    make ARCH="${ARCH}" CROSS_COMPILE="${CROSS_COMPILE}" mrproper
    make ARCH="${ARCH}" CROSS_COMPILE="${CROSS_COMPILE}" defconfig
    make -j$(nproc) ARCH="${ARCH}" CROSS_COMPILE="${CROSS_COMPILE}" all modules dtbs
fi
#********************************************************************************#

# *************************** Prepare RootFS_1.e_********************************#
cd "${OUTDIR}"
if [ -d "rootfs" ]; then 
    echo "Cleaning up existing rootfs..."
    sudo rm -rf rootfs
fi
mkdir -p rootfs/{bin,dev,etc,home,lib,lib64,proc,sbin,var,sys,tmp,usr/{bin,lib,sbin},var/log}
#********************************************************************************#

#************************* Clone and build BusyBox ******************************#
if [ ! -d "busybox" ]; then
    echo "Cloning BusyBox..."
    git clone git://busybox.net/busybox.git
fi

cd busybox
git checkout "${BUSYBOX_VERSION}"
make distclean
make ARCH="${ARCH}" CROSS_COMPILE="${CROSS_COMPILE}" defconfig
make -j$(nproc) ARCH="${ARCH}" CROSS_COMPILE="${CROSS_COMPILE}" CONFIG_PREFIX="${OUTDIR}/rootfs" install
#********************************************************************************#


#************************* Add library dependencies *****************************#
echo "Library dependencies"
${CROSS_COMPILE}readelf -a bin/busybox | grep "program interpreter"
${CROSS_COMPILE}readelf -a bin/busybox | grep "Shared library"
cd "${OUTDIR}/rootfs"
LIBS=$(find "${SYSROOT}"/lib -type f -name "*.so*" -exec cp {} lib/ \;)
LIB64S=$(find "${SYSROOT}"/lib64 -type f -name "*.so*" -exec cp {} lib64/ \;)
#********************************************************************************#


#***************************  Create device nodes *******************************#
sudo mknod -m 666 dev/null c 1 3
sudo mknod -m 666 dev/console c 5 1
#********************************************************************************#

echo "# writer application from Assignment 2 should be cross compiled "
aarch64-none-linux-gnu-gcc -Wall -static /home/tchuinkou/linux_sys/finder-app/writer.c -o writer
read -p "Appuyez sur Entrée pour continuer..."
 
#*************** Build and copy finder app to home Dir_1.d_&_1.f_****************#
cd "${FINDER_APP_DIR}"
make clean && make
cp finder.sh finder-test.sh writer.sh writer autorun-qemu.sh    "${OUTDIR}/rootfs/home/"
cp -r /home/tchuinkou/linux_sys/finder-app/conf  				"${OUTDIR}/rootfs/home"
cp -r /home/tchuinkou/linux_sys/finder-app/finder-test.sh 	 	"${OUTDIR}/rootfs/home/"
#cp -r /home/tchuinkou/linux_sys/finder-app/autorun-qemu.sh writer writer.c writer.sh  /tmp/aeld/rootfs/home/

sudo chown -R root:root "${OUTDIR}/rootfs"
#********************************************************************************#


#************************ Create initramfs_1.e_ ***************************#
cd "${OUTDIR}/rootfs"
sudo find . | cpio -H newc -ov --owner root:root | gzip > "${OUTDIR}/initramfs.cpio.gz"

echo "Build completed: ${OUTDIR}/initramfs.cpio.gz"
#********************************************************************************#



