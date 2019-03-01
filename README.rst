Oh my Glorious Arch
===================

`Arch is the best! <https://wiki.archlinux.org/index.php/Arch_is_the_best>`_

I need a good Live CD, but I still cannot find a perfect one for me.

- `SystemRescueCd <https://www.system-rescue-cd.org/>`_ is awesome, but it's Gentoo-based and not so easy to extend it. Now it's based on Arch, and it becomes bigger and lacks some tools I need.
- Debian-based distributions are easy to make, but I don't like the style of deb/rpm packages. Well, `Grml <https://grml.org/>`__ is awesome for admins.
- Arch is glorious, but its Live CD is a bit simple.

So now I'll make another Arch Live CD of my own. I'll make a new airootfs.sfs from any other GNU/Linux distribution, and package it in an iso file. My `liveusb-builder <https://github.com/mytbk/liveusb-builder>`_ also supports it.

The name `glorious` comes from `r/linuxmasterrace <https://www.reddit.com/r/linuxmasterrace>`_.

Usage
-----

Dependencies:

- systemd (for systemd-nspawn)
- squashfs-tools
- xorriso

To prevent you from screwing up your machine, you'd better use this script in a VM.

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

- flashrom: to flash coreboot to my machine
- coreboot-utils: cbmem, inteltool, intelmetool, ectool, etc.
- acpid and iasl: for handling ACPI things
- htop: the glorious task manager
- debootstrap: to install a Debian-based system easily
- picocom: to access the serial console
- WireGuard VPN

For the Live CDs with a desktop environment, I have:

- a good desktop environment: MATE, Xfce, LXDE-GTK3, LXQt or DDE
- QEMU: to install other OS with an ISO image, including Windows (using my disk as virtual disk). This is the most glorious feature of this Live CD. `And Grml adopted my idea. <https://github.com/grml/grml-live/issues/71>`__
- gparted: the glorious partition manager
- Firefox to access the Internet
- Riot web
- Pidgin with OTR plugin


Download
--------

I built a gloriousarch Xfce4 iso and uploaded it to `sourceforge <https://sourceforge.net/projects/garchiso/files/>`_. It's signed by a PGP key whose primary key fingerprint is 7079B481F04B5D8B65A0ECDEEA2DB82FE04A9403.
