---
layout: post
title: 通过 U 盘安装 VMware ESXi 5.5 的过程及其注意事项
date: '2014-10-02 13:29'
comments: true
published: true
description: "本文记录了安装 VMware ESXi 5.5 的过程，并记录了安装过程中遇到的问题和应该注意的事项。"
excerpt: "本文记录了安装 VMware ESXi 5.5 的过程，并记录了安装过程中遇到的问题和应该注意的事项。"
categories: [software]
tags: [VMware, ESXi, ESXi-Customizer, Realtek, 虚拟化]
url: '/2014/install-vmware-esxi-from-usb-drive/'
snapshot: '/wp-content/uploads/2014/esxi.jpg'
---
VMware vSphere Hypervisor 是可供小型企业或个人免费使用的虚拟化产品。VMware ESXi 是其重要的组成部分，是一个安装在裸机上的虚拟机管理软件。

可以在 VMware 官网注册并免费下载该软件，通常是一个 ISO 文件，例如当前版本是 `VMware-VMvisor-Installer-5.5.0.update01-1623387.x86_64.iso`。将该文件刻录到 CD 或者 DVD，然后就可以使用该 CD 或 DVD 驱动引导系统，安装 VMware ESXi 了。这种方式通常都比较简单，这里不再赘述。

本文主要介绍如何制作一个可启动的 U 盘，并通过该 U 盘引导启动安装 VMware ESXi。

## 制作可引导的 USB 驱动器

为什么这个过程还值得写下来？因为笔者在这里遇到很多问题，搜索了很多资料，才顺利的做好一个可以引导安装的 U 盘。

首先，在 Windows 下使用 UltraISO 软件制作的可启动 U 盘是无法启动安装的，开机即显示 `Initial menu has no LABEL entries!`，搜索显示这个跟什么 `syslinux` 有关。

其次，在 Windows 下下载 syslinux 包制作启动 U 盘，仍然无法引导，试过 syslinux 6.x 和 4.x 版本，总有这样那样的问题。

最后，老老实实回到官方文档上所使用的 Linux 系统来制作启动盘，才终于成功安装。

以下过程主要参考官方文档[《vSphere 安装和设置》][vmware-installation-setup-guide]中的[格式化 USB 闪存驱动器以引导 ESXi 安装或升级][format-usb-drive]章节。

### 先决条件
- 准备 Linux 系统，笔者使用的是 CentOS 6.2。
- 确保 Linux 中安装了 `syslinux` 软件包， VMware ESXi 5.5 需要使用 syslinux 版本 3.86 来制作启动 U 盘。笔者直接使用 `yum install syslinux` 来安装 syslinux 软件包，其版本其实是 4.x，这将导致一个问题，在后面会详述。
- 确保 Linux 中包含格式化 fat32 (mkfs.vfat 命令) 的软件，需要 `dosfstools` 软件包，在 CentOS 中执行 `yum install dosfstools` 即可安装。


### 步骤

1. 如果您的 USB 闪存驱动器未检测为 /dev/sdb，或者您不确定 USB 闪存驱动器是如何检测到的，请确定该闪存驱动器的检测方式。
    * 在终端窗口中，运行以下命令。
    ````
    tail -f /var/log/messages
    ```
    该命令将在终端窗口中显示当前日志消息。

    * 插入 USB 闪存驱动器。该终端窗口将以类似如下消息的格式显示标识 USB 闪存驱动器的若干条消息。
    ```
    Sep 25 13:25:23 linux kernel:[  712.447080] sd 3:0:0:0:[sdb] Attached SCSI removable disk
    ```
    在此示例中，`[sdb]` 用于标识 USB 设备。如果您设备的标识方式与此不同，则会使用您设备的标识方式（不带方括号）来替换此处的 `sdb`。
1. 在 USB 闪存驱动器上创建分区表。
    ```
    /sbin/fdisk /dev/sdb
    ```
    * 键入 `d` 删除分区，直至将其全部删除。
    * 键入 `n` 创建遍及整个磁盘的主分区 `1`。
    * 键入 `t` 将 FAT32 文件系统的类型设置为适当的设置，选则 `c`。
    * 键入 `a` 在分区 `1` 上设置活动标记。
    * 键入 `p` 打印分区表。结果应类似于以下文本：
    ```
    Disk /dev/sdb:2004 MB, 2004877312 bytes
    255 heads, 63 sectors/track, 243 cylinders
    Units = cylinders of 16065 * 512 = 8225280 bytes
    Device Boot      Start         End      Blocks   Id  System
    /dev/sdb1             1           243      1951866  c   W95 FAT32 (LBA)
    ```
    * 键入 w 写入分区表并退出。
1. 使用 Fat32 文件系统格式化 USB 闪存驱动器。
```
/sbin/mkfs.vfat -F 32 -n USB /dev/sdb1
```
1. 运行下列命令（注意命令参数，一个是 `sdb1`，一个是 `sdb`）。
```
syslinux /dev/sdb1
cat /usr/share/syslinux/mbr.bin > /dev/sdb
```
1. 挂载 USB 闪存驱动器。
```
mkdir /usbdisk
mount /dev/sdb1 /usbdisk
```
1. 挂载 ESXi 安装程序 ISO 映像。
```
mkdir /esxi_cdrom
mount -o loop VMware-VMvisor-Installer-5.x.x-XXXXXX.x86_64.iso /esxi_cdrom
```
1. 将 ISO 映像的内容复制到 `/usbdisk`。
```
cp -r /esxi_cdrom/* /usbdisk
```
1. 将 `isolinux.cfg` 文件重命名为 `syslinux.cfg`。
```
mv /usbdisk/isolinux.cfg /usbdisk/syslinux.cfg
```
1. 在 `/usbdisk/syslinux.cfg` 文件中，将 `APPEND -c boot.cfg` 一行更改为 `APPEND -c boot.cfg -p 1`。
1. 将 Linux 系统中的 syslinux 下的 `menu.c32` 文件复制到 `/usbdisk`（当前 Linux 中安装的 syslinux 版本不是 **3.86** 时需要执行该步骤，否则跳过该步）。
```
cp /usr/share/syslinux/menu.c32 /usbdisk
```
1. 卸载 USB 闪存驱动器。
```
umount /usbdisk
```
1. 卸载安装程序 ISO 映像。
```
umount /esxi_cdrom
```
现在，USB 闪存驱动器可以引导 ESXi 安装程序了。

**注意**
* 从第 5 步开始，以下的步骤都可以在 Windows 环境下完成，总结起来就是把 ISO 包中的内容全部复制到 U 盘，然后将 `isolinux.cfg` 文件重命名为 `syslinux.cfg`，然后修改 `syslinux.cfg` 的内容，将 `APPEND -c boot.cfg` 一行更改为 `APPEND -c boot.cfg -p 1`。
* 使用 syslinux 4.x 制作的 U 盘，如果不执行第 10 步，在启动时会报错 `menu.c32 not a com32r image`。因为 ISO 包中自带的 `menu.c32` 文件是 syslinux 3.86 版本的。

## 安装过程
只要制作的引导 U 盘没有问题，安装过程就极为简单。

图文安装过程，可<a href="http://www.it165.net/admin/html/201404/2857.html" target="_blank" rel="nofollow">浏览这里</a>。

## 注意事项

硬件配置必须满足最低条件，否则安装过程会终止。最基本的需求是，必须 4GB 以上内存，必须有一个以上 ESXi 默认支持的网卡。详见官方文档[硬件需求][hardware-requirements]章节。

比如，台式机上常用的网卡 Realtek 8168, Realtek 8169, Realtek 8139 等就在默认不支持的行列（据说在 ESXi 5.5 之前的版本中是包含这些驱动的），即 VMware ESXi 5.5 的默认安装包中不包含这些网卡的驱动，在安装过程中也就找不到相应的网卡。

此时，我们就需要定制自己的 ISO，将相应的网卡驱动打进自己的 ISO 包中。

步骤相对比较简单：
1. 下载工具 [ESXi-Customizer](http://www.v-front.de/p/esxi-customizer.html#download)，这个工具专门用于修改 ESXi 的 ISO 包。
2. 获取 Realtek 网卡的驱动程序文件，这些文件是 VIB 格式的，可以从 ESXi 5.5 之前版本的 ISO 中解压提取出来，也可以通过以下链接下载（zip文件请解压）。
    * Realtek 8168,8111e: [下载地址1][r8168-link1]，[下载地址2][r8168-link2]
    * Realtek 8169: [下载地址1][r8169-link1]，[下载地址2][r8169-link2]
3. 打开 ESXi-Customizer，分别选择原始 ESXi 5.5 ISO 文件，网卡驱动 VIB 文件和将要生成的 ISO 保存路径，点击运行即可。如图。
    ![ESXi-Customizer](/wp-content/uploads/2014/ESXi-Customizer_ESXi-5.5.0_r8168.jpg)
4. 使用新生成的自定义 ISO 文件制作启动盘即可（U 盘，CD， DVD）。如果已经通过前面的步骤制作好了可引导的 U 盘，只需要将新 ISO 包中的所有文件再次复制覆盖到 U 盘即可（**注意：不要覆盖 menu.c32 文件**）。

## 相关资源
* [VMware vSphere Hypervisor 5.5 下载](https://my.vmware.com/cn/web/vmware/evalcenter?p=free-esxi5&lp=default)
* [VMware vSphere 5.5 文档中心](http://pubs.vmware.com/vsphere-55/index.jsp)
* [VMware vSphere 5.5 PDF文档下载](http://pubs.vmware.com/vsphere-55/topic/com.vmware.ICbase/PDF/ic_pdf.html)


[vmware-installation-setup-guide]: http://pubs.vmware.com/vsphere-55/topic/com.vmware.vsphere.install.doc/GUID-7C9A1E23-7FCD-4295-9CB1-C932F2423C63.html
[format-usb-drive]: http://pubs.vmware.com/vsphere-55/topic/com.vmware.vsphere.install.doc/GUID-33C3E7D5-20D0-4F84-B2E3-5CD33D32EAA8.html
[hardware-requirements]: http://pubs.vmware.com/vsphere-55/topic/com.vmware.vsphere.install.doc/GUID-DEB8086A-306B-4239-BF76-E354679202FC.html
[r8168-link1]: https://www.dropbox.com/s/pfw5pjowb5nuqdb/VMware_bootbank_net-r8168_8.013.00-3vmw.510.0.0.799733.vib
[r8168-link2]: http://dev-random.net/wp-content/uploads/2014/01/VMware_bootbank_net-r8168+r8111e.zip
[r8169-link1]: https://www.dropbox.com/s/vr4ftwoewk9c5lt/VMware_bootbank_net-r8169_6.011.00-2vmw.510.0.0.799733.vib
[r8169-link2]: http://dev-random.net/wp-content/uploads/2014/01/VMware_bootbank_net-r8169.zip
