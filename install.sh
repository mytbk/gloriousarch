#!/bin/bash
set -e

ISO="$(realpath "$1")"
MIRROR="$2"

mkdir -p work/mnt work/pkg
cd work
mount "$ISO" mnt
unsquashfs mnt/arch/x86_64/airootfs.sfs

mount -t proc none squashfs-root/proc
mount --bind /dev squashfs-root/dev
mount -t sysfs none squashfs-root/sys
mount --bind pkg squashfs-root/var/cache/pacman/pkg
cp -L /etc/resolv.conf squashfs-root/etc/resolv.conf
cp ../chroot-install.sh squashfs-root/
chroot squashfs-root /usr/bin/env MIRROR="${MIRROR}" \
	/bin/bash /chroot-install.sh

rm squashfs-root/chroot-install.sh
umount squashfs-root/var/cache/pacman/pkg
umount squashfs-root/sys
umount squashfs-root/dev
umount squashfs-root/proc

mksquashfs squashfs-root airootfs.sfs

