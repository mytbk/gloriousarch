#!/bin/bash
set -e

# check if the needed tools exist
mksquashfs -version | grep 'mksquashfs version'
xorriso -version 2>/dev/null | grep 'xorriso version'

ROOTDIR="$(dirname $(realpath "$0"))"
WORKDIR=/tmp/work
ISO="$(realpath "$1")"
MIRROR=
DESKTOP=nox
COMP=xz

shift
while [ -n "$1" ]; do
	case "$1" in
		--mirror)
			shift
			MIRROR="$1"
			shift
			;;
		--mirror=*)
			MIRROR="${1/--mirror=}"
			shift
			;;
		--desktop)
			shift
			DESKTOP="$1"
			shift
			;;
		--desktop=*)
			DESKTOP="${1/--desktop=}"
			shift
			;;
		--comp)
			shift
			COMP="$1"
			shift
			;;
		--comp=*)
			COMP="${1/--comp=}"
			shift
			;;
		*)
			;;
	esac
done

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

# copy all iso files to target/
mkdir -p target/arch/x86_64
cp -a mnt/{EFI,syslinux,loader} target/
cp -a mnt/arch/boot target/arch/

unsquashfs mnt/arch/x86_64/airootfs.sfs

#mount -t proc none squashfs-root/proc
#mount --bind /dev squashfs-root/dev
#mount -t sysfs none squashfs-root/sys
mount --bind "${PKGDIR}" squashfs-root/var/cache/pacman/pkg

mkdir -p squashfs-root/aur
mount --bind -o ro "${ROOTDIR}/aur-packages" squashfs-root/aur

#cp -L /etc/resolv.conf squashfs-root/etc/resolv.conf
cp "${ROOTDIR}/chroot-install.sh" squashfs-root/
#install -D "${ROOTDIR}/archiso.preset" squashfs-root/etc/mkinitcpio.d/
cd squashfs-root
systemd-nspawn /usr/bin/env MIRROR="${MIRROR}" DESKTOP="${DESKTOP}" \
	/bin/bash /chroot-install.sh
cd "${WORKDIR}"

rm squashfs-root/chroot-install.sh
install "${ROOTDIR}/syncarch" squashfs-root/usr/local/bin/syncarch
install "${ROOTDIR}/xinitrc" squashfs-root/home/arch/.xinitrc
chroot squashfs-root chown -R arch:arch \
	/home/arch/.xinitrc
cat "${ROOTDIR}/motd" >> squashfs-root/etc/motd
mv squashfs-root/boot/vmlinuz-linux target/arch/boot/x86_64/
mv squashfs-root/boot/initramfs-linux.img target/arch/boot/x86_64/
#mv squashfs-root/boot/*-ucode.img target/arch/boot/
rm -f squashfs-root/boot/initramfs*

umount squashfs-root/aur
umount squashfs-root/var/cache/pacman/pkg
rmdir squashfs-root/aur
mv squashfs-root/opt/*.pkg.tar* squashfs-root/var/cache/pacman/pkg/
#umount squashfs-root/sys
#umount squashfs-root/dev
#umount squashfs-root/proc

mksquashfs squashfs-root target/arch/x86_64/airootfs.sfs -comp $COMP
umount mnt

_label_line=$(grep -m 1 -o  'archisolabel=ARCH_[0-9]*' target/syslinux/archiso_sys-linux.cfg)
iso_label=${_label_line/archisolabel=}

xorriso -as mkisofs \
	-iso-level 3 \
	-full-iso9660-filenames \
	-volid "${iso_label}" \
	-eltorito-boot syslinux/isolinux.bin \
	-eltorito-catalog syslinux/boot.cat \
	-no-emul-boot -boot-load-size 4 -boot-info-table \
	-isohybrid-mbr target/syslinux/isohdpfx.bin \
	-output "gloriousarch-${DESKTOP}.iso" \
	target/

echo "gloriousarch.iso is at ${WORKDIR}/gloriousarch-${DESKTOP}.iso"
printf 'clean up...'
rm -rf squashfs-root target
echo 'done'
