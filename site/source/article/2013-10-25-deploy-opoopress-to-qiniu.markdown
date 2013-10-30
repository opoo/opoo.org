---
layout: post
title: 将 OpooPress 静态博客部署到七牛云存储
date: '2013-10-25 16:29'
comments: true
published: true
description: "OpooPress 作为一个静态博客，可部署的环境非常之广。本文就讲讲如何将 OpooPress 生成的静态博客部署到七牛云存储。"
categories: [website]
tags: [OpooPress, qiniudn]
url: '/deploy-opoopress-to-qiniu/'
---
[OpooPress](http://www.opoopress.com/) 作为一个静态博客，可部署的环境非常之广。本文就讲讲如何将 OpooPress 生成的静态博客部署到七牛云存储。
<!--more-->

## 关于七牛云存储

七牛云存储致力于提供最适合开发者的数据在线托管、传输加速以及云端处理的服务。

在国内，七牛云存储的访问速度非常快，PING 值也很低。七牛云存储为用户免费提供 2 个二级域名，
一个仅支持 HTTP 协议的 `*.qiniudn.com` 和一个支持 HTTP/HTTPS 的 `*.qbox.me`。笔者测试的结果显示
似乎 `*.qbox.me` 的 PING 值比 `*.qiniudn.com` 稍高，即使同一个存储空间，2 个域名似乎也会解析到
不同的 CDN 服务器上。

注意，七牛云存储不是完全免费的产品，但它提供一定的免费配额，包括：
- 存储空间10GB
- 每月下载流量10GB
- 每月PUT/DELETE 10万次请求
- 每月GET 100万次请求

## 发布 OpooPress 到七牛

本文不介绍如何安装 OpooPress 静态博客，以及如何通过命令生成静态网站，相关知识请参考 [OpooPress 文档](http://www.opoopress.com/zh/download/)。这里只介绍如何将生成好的静态博客发布到七牛云存储。

1. 在使用七牛云存储之前，需要[注册成为七牛用户](https://portal.qiniu.com/signup?code=3l8tdavesmwk2)，
然后[取得 AccessKey 和 SecretKey](https://portal.qiniu.com/setting/key)。
  
1. [下载 qrsync 工具](http://docs.qiniu.com/tools/v6/qrsync.html)。根据操作系统下载特定的包，并解压。
以 Windows 为例，假设加压到目录 `D:\qrsync`。

1. 在博客的根目录（其它目录也可以）创建一个文本文件，命名为 `myblog-qiniu.conf`（文件名可随意）.
	```	
	{
	    "access_key": "Please apply your access key here",
	    "secret_key": "Dont send your secret key to anyone",
	    "bucket": "Bucket name on qiniu resource storage",
	    "sync_dir": "Local directory to upload",
	    "async_ops": "",
	    "debug_level": 1
	}
	```

  其中，`access_key` 和 `secret_key` 在上步中注册后取得。

  `sync_dir` 是本地需要上传的目录，即 OpooPress 博客的生成目录，绝对路径完整表示。OpooPress 博客的生成目录通常是在 `博客目录/target/public/site`，例如 `/root/myblog/target/public/site`。Windows 平台上路径的表示格式为：`盘符:/目录`，例如 `D:/myblog/target/public/site` 。
  
  更多参数请阅读 [qrsync 文档](http://docs.qiniu.com/tools/v6/qrsync.html)。

  **注意：SecretKey 是非常重要的。如果你将博客源码提交到 GitHub 之类的公开库中进行版本管理，切勿将该配置文件放在博客目录中，或者在 `.gitignore` 将它忽略。**

1. 运行命令 `/path/to/qrsync /path/to/myblog-qiniu.conf` 发布博客。例如：
	- Linux
		```
		$ /usr/local/qrsync/qrsync /root/myblog/myblog-qiniu.conf
		```
	- Windows
		```
		> D:\qrsync\qrsync.exe /root/myblog/myblog-qiniu.conf
		```

这是部署在七牛上的 OpooPress 站点: <a href="http://opoopress.u.qiniudn.com/" rel="nofollow" target="_blank">http://opoopress.u.qiniudn.com</a>
