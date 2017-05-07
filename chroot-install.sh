#!/bin/bash
set -e

MIRROR=${MIRROR:='http://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch'}
DESKTOP_MATE=(mate mate-extra)
DESKTOP_XFCE=(xfce4 xfce4-goodies)
DESKTOP_LXQT=(lxqt)
DESKTOP_DDE=(deepin deepin-extra)

case "${DESKTOP}" in
	mate)
		DESKTOP=("${DESKTOP_MATE[@]}")
		;;
	xfce)
		DESKTOP=("${DESKTOP_XFCE[@]}")
		;;
	lxqt)
		DESKTOP=("${DESKTOP_LXQT[@]}")
		;;
	dde)
		DESKTOP=("${DESKTOP_DDE[@]}")
		;;
	*)
		DESKTOP=("${DESKTOP_MATE[@]}")
		;;
esac

pacman-key --init
pacman-key --populate archlinux

cp /etc/pacman.conf /etc/pacman.conf.bak
sed -i 's/CheckSpace/#CheckSpace/g' /etc/pacman.conf
sed -i 's/^#IgnorePkg.*$/IgnorePkg = linux linux-firmware/g' /etc/pacman.conf

cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
echo "Server = ${MIRROR}" > /etc/pacman.d/mirrorlist

pacman --noconfirm -Syu --needed \
	qemu flashrom debootstrap htop \
	iasl dmidecode procinfo-ng efibootmgr ovmf \
	ttf-droid ttf-dejavu \
	xorg xorg-apps xorg-xinit "${DESKTOP[@]}" \
	xf86-input-wacom \
	gparted \
	firefox \
	pidgin pidgin-otr

mv /etc/pacman.conf.bak /etc/pacman.conf
mv /etc/pacman.d/mirrorlist.bak /etc/pacman.d/mirrorlist

useradd -m -G wheel arch
sed -i 's/^# %wheel/%wheel/g' /etc/sudoers
sed -i 's/root/arch/g' /etc/systemd/system/getty@tty1.service.d/autologin.conf

gpgconf --homedir /etc/pacman.d/gnupg/ --kill gpg-agent
