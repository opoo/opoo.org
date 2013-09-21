---
layout: post
title: OpooPress 增强了发布到 GitHub Pages 的功能
date: '2013-09-21 21:08'
comments: true
published: true
keywords: "GitHub Pages, git, opoopress-wagon-github, opoopress-wagon-git"
description: "本文介绍 OpooPress 的两个自定义 wagon，以及将 OpooPress 博客发布到 GitHub Pages 的三种方式。"
categories: ["OpooPress"]
tags: ["OpooPress", "github-pages"]
url: '/opoopress-deploy-to-github-pages-enhanced/'
excerpt: "在即将发布的 1.0.2 版本的 OpooPress 中，发布到 GitHub Pages 的功能将得到增强。该版本将原来插件中定义的 wagon 独立成 opoopress-wagon-github 包，并定义了一个底层使用 git 命令行的 wagon。"
---

免费服务在国内总是被追捧，然后被滥用或者被墙。SourceForge.net 的 Project Web 和 User Web 早已不能访问了，OpenShift 服务常常需要换 IP，连笔者都因为[太折腾](/about-self-hosted-blog/)而改用收费服务了。

但是，就目前而言，GitHub Pages 的免费网页服务还真是比较稳定和可靠的。

在即将发布的 1.0.2 版本的 OpooPress 中，发布到 GitHub Pages 的功能将得到增强。该版本将原来插件中定义的 wagon 独立成 opoopress-wagon-github 包，并定义了一个底层使用 git 命令行的 wagon。

**注意**：目前最新的开发版（1.0.2-SNAPSHOT）中已经包含该功能，阅读 [这个文档](http://www.opoopress.com/zh/faqs/how-to-use-opoopress-snapshots/) 文档了解如何使用开发版（snapshot）的包。

经过测试，以下三种方式都可以将 OpooPress 发布到 GitHub Pages。
1. [使用自定义 wagon: opoopress-wagon-github](http://www.opoopress.com/zh/docs/github-pages/#opoopress-wagon-github)
- [使用自定义 wagon: opoopress-wagon-git](http://www.opoopress.com/zh/docs/github-pages/#opoopress-wagon-git)
- [结合使用 wagon-scm 和 maven-scm-provider-gitexe](http://www.opoopress.com/zh/docs/github-pages/#wagon-scm--maven-scm-provider-gitexe)

第一种方式是纯 Java 的实现，依赖最少。在没有安装 git 客户端工具时，这是你目前唯一的选择。

第二种方式需要安装 git 命令行工具，但运行速度最快。建议选择使用。

第三种方式所使用的包都是 Apache 的官方实现，质量有保证。根据喜欢选择吧。

详细使用说明请点击上述各个链接。
