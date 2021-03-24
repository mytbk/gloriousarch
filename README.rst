ChinGNUx 启动镜像
===================

ChinGNUx 是一个面向中文用户的操作系统，目前本操作系统是一个定制的 Arch Linux 操作系统。

本项目包含用于从 Arch Linux 启动镜像构建 ChinGNUx 启动镜像的脚本，它基于 `gloriousarch <https://github.com/mytbk/gloriousarch>`__ 项目。

用法
-----

要使用此脚本，你需要一个包含以下软件的 GNU/Linux 操作系统：

- systemd
- squashfs-tools
- xorriso

制作 ChinGNUx 镜像需要以 root 的身份执行脚本，如果担心该脚本破坏你的系统，可以在虚拟机中使用。在源码目录中执行以下命令即可创建 ChinGNUx 镜像::

  sudo ./install.sh <archiso> [--mirror=<mirror>] [--desktop=<desktop>] [--comp=<gzip|xz>]

默认参数为使用TUNA镜像，无桌面环境，使用xz压缩，具体支持的桌面环境参见 `<chroot-install.sh>`__.

用法示例::

  sudo ./install.sh archlinux-2020.03.01-x86_64.iso --mirror 'http://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch' --desktop=lxqt

软件包
--------

ChinGNUx 启动镜像包含以下软件包：

- flashrom: 固件刷写工具
- coreboot-utils: inteltool, intelmetool, ectool, nvramtool, cbmem 等工具
- acpid, iasl: ACPI 工具
- htop: 任务管理器
- debootstrap: 用于安装多种基于 Debian 的操作系统
- picocom: 串口访问工具
- WireGuard VPN

如果启动镜像有桌面环境，还会包含以下软件包:

- QEMU: 可以利用虚拟机安装系统到物理机的硬盘上，参见此 `Grml issue <https://github.com/grml/grml-live/issues/71>`__
- gparted: 分区工具
- Firefox
- Element
- Pidgin
