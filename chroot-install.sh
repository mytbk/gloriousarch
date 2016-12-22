#!/bin/bash

MIRROR=${MIRROR:='http://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch'}

pacman-key --init
pacman-key --populate archlinux

cp /etc/pacman.conf /etc/pacman.conf.bak
sed -i 's/CheckSpace/#CheckSpace/g' /etc/pacman.conf
sed -i 's/^#IgnorePkg.*$/IgnorePkg = linux linux-firmware/g' /etc/pacman.conf

cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
echo "Server = ${MIRROR}" > /etc/pacman.d/mirrorlist

pacman --noconfirm -Syu qemu flashrom debootstrap htop

mv /etc/pacman.conf.bak /etc/pacman.conf
mv /etc/pacman.d/mirrorlist.bak /etc/pacman.d/mirrorlist

gpgconf --homedir /etc/pacman.d/gnupg/ --kill gpg-agent
