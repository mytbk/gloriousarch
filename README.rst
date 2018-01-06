Oh my Glorious Arch
===================

`Arch is the best! <https://wiki.archlinux.org/index.php/Arch_is_the_best>`_

I need a good Live CD, but I still cannot find a perfect one for me.

- `SystemRescueCd <https://www.system-rescue-cd.org/>`_ is awesome, but it's Gentoo-based and not so easy to extend it.
- Debian-based distributions are easy to make, but I don't like the style of deb/rpm packages.
- Arch is glorious, but its Live CD is a bit simple.

So now I'll make another Arch Live CD of my own. I'll make a new airootfs.sfs from any other GNU/Linux distribution, and package it in an iso file. My `liveusb-builder <https://github.com/mytbk/liveusb-builder>`_ also supports it.

The name `glorious` comes from `r/linuxmasterrace <https://www.reddit.com/r/linuxmasterrace>`_.

Usage
-----

You need root to run the install script, because chroot is needed. The command is very simple::

  sudo ./install.sh <archiso> [--mirror=<mirror>] [--desktop=<desktop>] [--comp=<gzip|xz>]

To add more packages, you can put your Arch packages to ``aur-packages/``.

The format of <mirror> is the string after ``Server =`` in /etc/pacman.d/mirrorlist.

<desktop> can be ``mate``, ``xfce``, ``dde``, ``lxde-gtk3`` and ``lxqt``.

Default mirror and desktop is TUNA mirror and MATE desktop.

Example::

  sudo ./install.sh archlinux-2017.05.01-x86_64.iso --mirror 'http://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch' --desktop=lxqt

Packages
--------

I now have these tools in my Live CD:

- a good desktop environment: now gloriousarch has MATE, Xfce, LXQt and DDE support
- QEMU: to install other OS with an ISO image, including Windows (using my disk as virtual disk). This is the most glorious feature of this Live CD.
- flashrom: to flash coreboot to my machine
- gparted: the glorious partition manager
- debootstrap: to install a Debian-based system easily
- Firefox to access the Internet
- Pidgin to chat, and it should support OTR
- picocom: to access the serial console
- WireGuard VPN


Download
--------

I built a gloriousarch Xfce4 iso and uploaded it to `sourceforge <https://sourceforge.net/projects/garchiso/files/>`_. It's signed by a PGP key whose primary key fingerprint is 0x9E5B817BFF338DD701676C276DBD8BFE8600BEAA.
