Oh my Glorious Arch
===================

`Arch is the best! <https://wiki.archlinux.org/index.php/Arch_is_the_best>`_

I need a good Live CD, but I still cannot find a perfect one for me.

- `SystemRescueCd <https://www.system-rescue-cd.org/>`_ is awesome, but it's Gentoo-based and not so easy to extend it.
- Debian-based distributions are easy to make, but I don't like the style of deb/rpm packages.
- Arch is glorious, but its Live CD is a bit simple.

So now I'll make another Arch Live CD of my own. I'll make a new airootfs.sfs from any other GNU/Linux distribution, and make a simple package so that my `liveusb-builder <https://github.com/mytbk/liveusb-builder>`_ can use it.

Packages
--------

I need these tools in my Live CD:

- flashrom and coreboot utilities: to access or flash coreboot to my machine
- debootstrap: to install a Debian-based system easily
- qemu: to install other OS with an ISO image (using my disk as virtual disk)
- a good desktop environment

