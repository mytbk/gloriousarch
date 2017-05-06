#!/bin/bash
set -e

ROOTDIR="$(dirname $(realpath "$0"))"
WORKDIR=/tmp/work
ISO="$(realpath "$1")"
MIRROR="$2"
DESKTOP="$3"

mkdir -p "${WORKDIR}/mnt"

if test -d /var/cache/pacman/pkg
then
	PKGDIR=/var/cache/pacman/pkg
else
	mkdir -p "${WORKDIR}/pkg"
	PKGDIR=pkg
fi

cd "${WORKDIR}"
mount "$ISO" mnt
unsquashfs mnt/arch/x86_64/airootfs.sfs

mount -t proc none squashfs-root/proc
mount --bind /dev squashfs-root/dev
mount -t sysfs none squashfs-root/sys
mount --bind "${PKGDIR}" squashfs-root/var/cache/pacman/pkg
cp -L /etc/resolv.conf squashfs-root/etc/resolv.conf
cp "${ROOTDIR}/chroot-install.sh" squashfs-root/
chroot squashfs-root /usr/bin/env MIRROR="${MIRROR}" \
	/bin/bash /chroot-install.sh

rm squashfs-root/chroot-install.sh
install "${ROOTDIR}/xinitrc" squashfs-root/home/arch/.xinitrc

umount squashfs-root/var/cache/pacman/pkg
umount squashfs-root/sys
umount squashfs-root/dev
umount squashfs-root/proc

mksquashfs squashfs-root airootfs.sfs
umount mnt

echo "airootfs.sfs is at ${WORKDIR}/airootfs.sfs"