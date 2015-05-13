---
layout: post
title: 在多线程中生成 OpooPress 站点
date: '2014-05-11 15:38'
comments: true
published: true
description: OpooPress 1.1.1 将开始支持多线程，本文预览一下通过多线程构建 OpooPress 站点时的性能情况。
categories: [website]
tags: [OpooPress]
url: '/2014/opoopress-site-generated-in-multi-thread/'
snapshot: //static.opoo.org/oplogo/220x220.png
---
OpooPress 1.1.1 将开始支持多线程，本文预览一下通过多线程构建 OpooPress 站点时的性能情况。
<!--more-->

## 如何在 OpooPress 构建时使用多线程

1. 使用 OpooPress 1.1.1 以上版本，默认在 10 个线程中执行关键构建程序
2. 在 Maven 命令行中指定参数 `-Dthreads=10`，后面的数字代表线程数，为 `1` 时，表示使用单线程


## 准备环境
1. [安装站点](http://www.opoopress.com/zh/docs/installation/#pom-only)
1. 通过[这里](/why-i-develop-opoopress/)介绍的方法生成了 **10,000** 篇文章，总共 10,001 篇文章

准备好数据后，`site` 目录共 197,509,023 字节，10,191 个文件，44 个文件夹。

## Windows 下运行结果
（配置：Intel Core2 Due P8400 CPU, 2GB 内存，便携式电脑， Windows XP, Oracle JDK 1.6, Maven 3.1.0）

1. 单线程（即 `-Dthreads=1`）
```
[INFO] Executing build in single thread.
[INFO] No last generate info, regenerate site.
[INFO] Reading sources ...
[INFO] Reading assets ...
[INFO] Rendering 10001 posts...
[INFO] Rendering 1025 pages...
[INFO] cleanup...
[INFO] Writing 10001 posts, 1025 pages, and 112 static files ...
[INFO] Generate time: 216968ms
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 3:38.562s
[INFO] Finished at: Sun May 11 15:28:12 CST 2014
[INFO] Final Memory: 45M/989M
```
总用时3分38秒，生成站点用时约217秒，CPU占用非常少。

1. 10线程（即 `-Dthreads=10` 或不指定线程数）
```
[INFO] Executing build in threads: 10
...
[INFO] Generate time: 176687ms
[INFO] Total time: 3:04.969s
```
总用时3分04秒，生成站点用时约177秒，CPU占用较高。

1. 50线程（即 `-Dthreads=50`）
```
[INFO] Executing build in threads: 50
...
[INFO] Generate time: 81906ms
[INFO] Total time: 1:23.328s
```
总用时1分23秒，生成站点用时约82秒，CPU占用很高。

1. 100线程（即 `-Dthreads=100`）
```
[INFO] Executing build in threads: 100
...
[INFO] Generate time: 67282ms
[INFO] Total time: 1:09.562s
```
总用时1分09秒，生成站点用时约67秒，CPU占用很高。

可见，在文章较多时，使用多线程来生成 OpooPress 站点可以显著提高生成速度，缩短生成时间。但线程数量也应该设置一个合理的值，过多的线程也会造成系统运行负担。

## Linux 下运行结果
（配置：4 核 CPU，2GB内存，Virtual Private Server，CentOS 6.5 32bit，OpenJDK 1.7，Maven 3.2.1）

1. 单线程（即 `-Dthreads=1`）
```
[INFO] Executing build in single thread.
[INFO] No last generate info, regenerate site.
[INFO] Reading sources ...
[INFO] Reading assets ...
[INFO] Rendering 10001 posts...
[INFO] Rendering 1025 pages...
[INFO] Writing 10001 posts, 1025 pages, and 112 static files ...
[INFO] Generate time: 36202ms
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time: 37.653 s
[INFO] Finished at: 2014-05-11T16:42:28+08:00
[INFO] Final Memory: 10M/810M
```
总用时37.653秒，生成站点用时约36秒，CPU占用较高。

1. 10线程（即 `-Dthreads=10` 或不指定线程数）
```
[INFO] Executing build in threads: 10
...
[INFO] Generate time: 39185ms
[INFO] Total time: 40.690 s
```
总用时40.690秒，生成站点用时约39秒，CPU占用较高。

1. 50线程（即 `-Dthreads=50`）
```
[INFO] Executing build in threads: 50
...
[INFO] Generate time: 68062ms
[INFO] Total time: 01:09 min
```
总用时1分09秒，生成站点用时约68秒，CPU占用较高。

1. 100线程（即 `-Dthreads=100`）
```
[INFO] Executing build in threads: 100
...
[INFO] Generate time: 89168ms
[INFO] Total time: 01:30 min
```
总用时1分30秒，生成站点用时约89秒，CPU占用较高。

意料之中的是：Linux 和 Windows 的 I/O 机制不同，内存管理机制不同，Linux 的效率更高些。但**意料之外**的是：在 Linux 下增加线程不但没有提升生成速度，反而有所降低，不知是不是使用**VPS**的缘故。