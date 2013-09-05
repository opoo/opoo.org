---
layout: post
title: "安装配置 OpooPress 最快捷的方式—— Maven Plugin 版即将发布"
date: '2013-07-11 20:32'
comments: true
published: true
keywords: "OpooPress, Blog, static site/blog generator"
description: "安装配置 OpooPress 最快捷的方式—— “Maven Plugin 版”即将发布，本文预览该版本用法。"
url: /opoopress-maven-plugin-will-be-released/
categories: [opoopress]
tags: [opoopress, Maven]
---

Maven Plugin 版是笔者觉得目前最便捷的发布和部署方式了。目前插件已经发布至 Sonatype OSS Snapshots 仓库，待测试没有问题就会同步到 Maven Central 库，毕竟使用 Snapshots 库是一件比较浪费时间的事情。

使用该插件，安装、配置、部署 OpooPress 博客系统将变得非常简单。

1. 第一步：先安装 [Java](http://www.oracle.com/technetwork/java/) 1.6 (JDK) 和 [Maven](http://maven.apache.org/download.cgi#Installation) 2.2.1 以上版本。

2. 第二步：安装、配置 OpooPress 博客系统

Linux 下执行以下命令即可：

```bash
[root@vps ~]# mkdir myblog
[root@vps ~]# cd myblog
[root@vps myblog]# wget http://www.opoopress.com/downloads/pom.xml
[root@vps myblog]# mvn op:install op:generate op:preview
```
用浏览器打开 `http://localhost:8080/` ，是不是已经看到效果了呢。 



Windows 下：
   * 创建目录，然后进入该目录
   * 下载 [pom.xml](http://www.opoopress.com/downloads/pom.xml) 并放在这个目录中
   * 在命令行（cmd.exe）中进到该目录
   * 运行 Maven 指令 `mvn op:install op:generate op:preview`
   * 用浏览器打开 `http://localhost:8080/` 即可预览。

是的，就是这么快捷。

了解更多请访问 [OpooPress 网站](http://www.opoopress.com/)。
