---
layout: post
title: VMware ESXi 6.0（88SE9230 Raid卡，RTL8111e网卡）安装注意事项
date: '2015-05-25 13:29'
comments: true
published: true
description: "本文介绍在插有 Marvell 88SE9230 Raid 磁盘阵列卡、板载 Realtek RTL8111e 网卡的机器上安装 VMware ESXi 6.0 时的注意事项。"
excerpt: "本文介绍在插有 Marvell 88SE9230 Raid 磁盘阵列卡、板载 Realtek RTL8111e 网卡的机器上安装 VMware ESXi 6.0 时的注意事项。"
categories: [software]
tags: [VMware, vSphere, ESXi, ESXi-Customizer, Realtek, 虚拟化, RTL8111e, 88SE9230]
url: '/2015/install-vmware-esxi-6.0-with-88se9230-and-rtl8111e/'
snapshot: '/wp-content/uploads/2014/esxi.jpg'
---

本文仅简单记录安装 ESXi 6.0 的注意事项，具体安装过程可参考 [通过 U 盘安装 ESXi 5.5](/2014/install-vmware-esxi-from-usb-drive/)。

1. 下载 VMware 6.0 的 ISO 文件，文件名 `VMware-VMvisor-Installer-6.0.0-2494585.x86_64.iso`。

2. 修改 ISO 文件，制作自定义的 ESXi ISO 文件。

    当前使用的机器插有一张 Raid 卡（PCIe SATA 6Gb/S Controller，芯片是 Marvell 88SE9230），板载网卡是 Realtek RTL8111e。
    
    这两个硬件都不被 ESXi 6.0 默认支持，安装时会看不到硬盘，也会由于找不到网络适配器而导致安装失败，所以在安装前先修改 ISO 文件，将对应的驱动放进去。

    * 下载工具 [ESXi-Customizer](http://www.v-front.de/p/esxi-customizer.html#download)，这个工具专门用于修改 ESXi 的 ISO 包。
    * 下载 [Marvell 88SE9230 驱动](https://vibsdepot.v-front.de/wiki/index.php/Sata-xahci)，下载 VIB 文件即可，这实际上是个[比较通用的 SATA AHCI 驱动包](http://www.v-front.de/2013/11/how-to-make-your-unsupported-sata-ahci.html)。文件名为 `sata-xahci-1.30-1.x86_64.vib`。
    * 下载 [Realtek RTL8111e 驱动](http://vibsdepot.v-front.de/depot/vft/net51-drivers-1.0/net51-drivers-1.0.0-1vft.510.0.0.799733.x86_64.vib)（右键，另存为，亲测可用），文件名为 `net51-drivers-1.0.0-1vft.510.0.0.799733.x86_64.vib`。另外，[这个驱动](https://vibsdepot.v-front.de/wiki/index.php/Net55-r8168)应该也能用，没有亲自试过。
    * 解压并打开 ESXi-Customizer，分 2 步将上面的 2 个 VIB 并入 ISO 文件。第一步，选择 `VMware-VMvisor-Installer-6.0.0-2494585.x86_64.iso`，选择 VIB `sata-xahci-1.30-1.x86_64.vib`，生成新的 ISO；第二步，选择第一步生成的 ISO，选择 VIB `net51-drivers-1.0.0-1vft.510.0.0.799733.x86_64.vib`，生成最终的 ISO。（最好先对第一步生成的 ISO 文件改名）。

3. 写入安装 U 盘。

   通过 [UNetbootin](http://unetbootin.sourceforge.net/) 工具将 ISO 写进 U 盘。UNetbootin 绝对是利器，使用 UltraISO 制作的启动 U 盘常常有问题。

4. 进行安装。

   在目标机器插入 U 盘，在 BIOS 设置 USB Controller 启动，进行安装。
