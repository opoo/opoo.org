---
layout: post
title: 如何同时使用 Maven 2 和 Maven 3
date: '2014-04-09 11:38'
comments: true
published: true
description: 本文介绍如何在同一台机器上使用多个不同版本的 Apache Maven。这个方法也适合类似软件多版本并存的情况，比如 Apache Ant。
categories: [maven]
tags: [Maven]
url: '/how-to-use-multiple-maven-versions/'
snapshot: /wp-content/uploads/2014/maventxt_logo_205.png
---

本文介绍如何在同一台机器上使用多个不同版本的 Apache Maven。这个方法也适合类似软件多版本并存的情况，比如 Apache Ant。
<!--more-->

![Apache Maven](//maven.apache.org/images/maventxt_logo_200.gif)

以 Windows 下同时使用 Maven 2.2.1 和 Maven 3.1.0 为例。

1. 下载 Maven 并解压，分别解压到 `C:\Program Files\apache-maven-2.2.1\` 和 `C:\Program Files\apache-maven-3.1.0\` 目录。
1. 创建目录 `C:\Program Files\apache-maven\`
1. 在目录 `C:\Program Files\apache-maven\` 中创建批处理文件 `m2.bat`，内容如下
	```
	@setlocal
	@set M2_HOME=C:\Program Files\apache-maven-2.2.1
	@"%M2_HOME%\bin\mvn.bat" %*
	@endlocal
	```
1. 在目录 `C:\Program Files\apache-maven\` 中创建批处理文件 `m3.bat`，内容如下
	```bat
	@setlocal
	@set M2_HOME=C:\Program Files\apache-maven-3.1.0
	@"%M2_HOME%\bin\mvn.bat" %*
	@endlocal
	```
1. 将 `C:\Program Files\apache-maven\` 加到环境变量 `Path` 中

此时调用 `m2 xxx`  即可使用 Mavne 2，调用 `m3 xxx` 即可使用 Maven 3。也可以根据需求安装更多的 Maven 版本，并定义更多的批处理文件，调用时使用对应的批处理名称即可。

```
D:\>m2 -version
Apache Maven 2.2.1 (r801777; 2009-08-07 03:16:01+0800)
Java version: 1.7.0_45
Java home: C:\Java\jdk1.7.0_45\jre
Default locale: zh_CN, platform encoding: GBK
OS name: "windows 2003" version: "5.2" arch: "x86" Family: "windows"
```

```
D:\>m3 -version
Apache Maven 3.1.0 (893ca28a1da9d5f51ac03827af98bb730128f9f2; 2013-06-28 10:15:32+0800)
Maven home: C:\Program Files\apache-maven-3.1.0
Java version: 1.7.0_45, vendor: Oracle Corporation
Java home: C:\Java\jdk1.7.0_45\jre
Default locale: zh_CN, platform encoding: GBK
OS name: "windows 2003", version: "5.2", arch: "x86", family: "windows"
```

当然，通常我们已经习惯了 `mvn` 命令，如果默认使用 Maven 3，则将 `m3.bat` 修改为 `mvn.bat` 即可。

