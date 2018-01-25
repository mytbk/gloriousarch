#!/bin/bash
set -e

MIRROR=${MIRROR:='http://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch'}
DESKTOP_MATE=(mate mate-extra)
DESKTOP_XFCE=(xfce4 xfce4-goodies)
DESKTOP_LXQT=(lxqt)
DESKTOP_DDE=(deepin deepin-extra)

GUIPKGS=(qemu ovmf \
	ttf-droid ttf-dejavu \
	xorg xorg-apps xorg-drivers xorg-xinit xf86-input-wacom \
	gparted firefox pidgin pidgin-otr riot-web)

case "${DESKTOP}" in
	no)
		DESKTOP=()
		;;
	mate)
		DESKTOP=("${DESKTOP_MATE[@]}")
		;;
	xfce)
		DESKTOP=("${DESKTOP_XFCE[@]}")
		;;
	lxde-gtk3)
		DESKTOP=(lxde-gtk3)
		;;
	lxqt)
		DESKTOP=("${DESKTOP_LXQT[@]}")
		;;
	dde)
		DESKTOP=("${DESKTOP_DDE[@]}")
		;;
	*)
		DESKTOP=()
		;;
esac

if [[ "${#DESKTOP[@]}" -ne 0 ]]; then
	DESKTOP+=("${GUIPKGS[@]}")
fi

pacman-key --init
pacman-key --populate archlinux

cp /etc/pacman.conf /etc/pacman.conf.bak
sed -i 's/CheckSpace/#CheckSpace/g' /etc/pacman.conf

cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
echo "Server = ${MIRROR}" > /etc/pacman.d/mirrorlist

# (re)install linux because the Linux image is not present
pacman --noconfirm -Sy linux
pacman --noconfirm -Syu --needed \
	base-devel \
	git \
	linux-headers dkms archiso \
	wireguard-dkms wireguard-tools \
	flashrom debootstrap htop \
	acpid iasl dmidecode procinfo-ng efibootmgr \
	picocom \
	bash-completion zsh-completions \
	zstd \
	"${DESKTOP[@]}"

if /bin/ls /aur/*.pkg.tar.*; then
	pacman --noconfirm -U --needed /aur/*.pkg.tar.*
fi

mkinitcpio -p archiso

mv /etc/pacman.conf.bak /etc/pacman.conf
mv /etc/pacman.d/mirrorlist.bak /etc/pacman.d/mirrorlist

if ! grep '^arch:' /etc/passwd; then
	useradd -m -G wheel,uucp arch
	echo arch:arch | chpasswd
	sed -i 's/^# %wheel/%wheel/g' /etc/sudoers
	sed -i 's/root/arch/g' /etc/systemd/system/getty@tty1.service.d/autologin.conf
fi

gpgconf --homedir /etc/pacman.d/gnupg/ --kill gpg-agent
rm -f /etc/udev/rules.d/81-dhcpcd.rules
