#!/bin/bash

MIRROR=${MIRROR:='http://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch'}

pacman-key --init
pacman-key --populate archlinux

cp /etc/pacman.conf /etc/pacman.conf.bak
sed -i 's/CheckSpace/#CheckSpace/g' /etc/pacman.conf
sed -i 's/^#IgnorePkg.*$/IgnorePkg = linux linux-firmware/g' /etc/pacman.conf

cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
echo "Server = ${MIRROR}" > /etc/pacman.d/mirrorlist

pacman --noconfirm -Syu --needed \
	qemu flashrom debootstrap htop \
	xorg xorg-apps xorg-xinit ttf-droid mate mate-extra \
	firefox \
	pidgin pidgin-otr

mv /etc/pacman.conf.bak /etc/pacman.conf
mv /etc/pacman.d/mirrorlist.bak /etc/pacman.d/mirrorlist

useradd -m -G wheel arch
sed -i 's/^# %wheel/%wheel/g' /etc/sudoers
sed -i 's/root/arch/g' /etc/systemd/system/getty@tty1.service.d/autologin.conf

gpgconf --homedir /etc/pacman.d/gnupg/ --kill gpg-agent
