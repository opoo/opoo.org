---
layout: post
title: 将 OpooPress 发布到 Google App Engine(GAE)
date: '2013-10-25 17:56'
comments: true
published: true
description: "本文讲解如何将 OpooPress 生成的静态博客部署到 Google App Engine。"
categories: [website]
tags: [OpooPress, Google App Engine]
url: '/deploy-opoopress-to-google-app-engine/'
---
Google App Engine(GAE) 相信都不陌生，最近 GAE 又增加了 Push-to-Deploy 功能，意味着可以通过 git 工具部署 GAE 应用了。
本文就主要介绍如何将 OpooPress 生成的静态博客部署到 GAE。
<!--more-->

前文所说的七牛云存储在国内的速度的确非常优秀，但在国外表现就属于普通了。

GAE 则不同，笔者使用多点 PING，发现自己的应用所在的 GAE 节点在全球的响应速度都非常好，所有线路平均 60 多毫秒。
但 GAE 的缺点也是很明显的：一是免费配额比较低，二是它提供的二级域名是无法直接访问的。

同样本文不介绍如何安装 OpooPress 静态博客，以及如何通过命令生成静态网站，相关知识请参考 [OpooPress 文档](http://www.opoopress.com/zh/download/)。

将 OpooPress 静态博客发布到 GAE 有两种方式：通过 App Engine SDK 提供的工具；通过 git 客户端。

由于 OpooPress 生成的是全静态的网站，所以选择 Python 版配置即可，配置文件 `app.yaml` 如下：
```
application: <your-app-id>
version: <version>
runtime: python27
api_version: 1
threadsafe: yes

default_expiration: "10d"

handlers:
- url: /
  static_files: index.html
  upload: index.html

- url: /(.*)/
  static_files: \1/index.html
  upload: (.*)/index.html

- url: /app.yaml
  static_files: index.html
  upload: index.html

- url: /(.*)
  static_files: \1
  upload: (.*)
```
注意替换 `your-app-id` 为你的应用的 id，`version` 仅仅是一个标识，你可以随意设置，在 GAE 中将当前版本设置成默认即可。绑定泛域名可以访问所有版本，[参考这篇文章](/google-app-engine/)。

关于 `app.yaml` 更详细的内容请阅读官方文档[《Python 应用程序配置》](https://developers.google.com/appengine/docs/python/config/appconfig?hl=zh-cn)。

将 `app.yaml` 放在 OpooPress 的生成目录中（如 D:\myblog\target\public\site）或者静态资源目录中
（如 D:\myblog\site\assets，会自动复制到站点生成目录），就可以将生成目录变成一个 GAE 的应用。

## 通过 Google App Engine Launcher 发布

以 Windows 为例，在下载安装 [Python 版本的 App Engine SDK](https://developers.google.com/appengine/downloads#Google_App_Engine_SDK_for_Python) 之后，
就可以从 Windows 开始菜单启动 Google App Engine Launcher 了。其界面如下：

![Google App Engine Launcher Snapshot](//opoo.org/wp-content/uploads/2013/google-app-engine-launcher.png)

打开菜单 File -> Add Existing Application...，选择 OpooPress 博客的生成目录，即可将博客站点添加进来。之后就可以点击 `Run` 按钮运行站点，进行阅览，或者直接点击 `Deploy` 按钮将博客站点发布到 GAE 上。

## 通过 Git 客户端发布

Google App Engine 最近增加了一个叫着 `Push-to-Deploy` 的功能，
可以通过 git 客户端 push GAE 应用到一个特定的库，push 完成后，会自动将库中的文件部署到 GAE。

可参考官方文档[《Using Git and Push-to-Deploy》](https://developers.google.com/appengine/docs/push-to-deploy)。

由于文档目前只有英文版本，所以这里还是大致叙述一下步骤。

**在 GAE 添加 Google Cloud 集成**

这一点在文档中似乎没有提到。

在 [Google App Engine 管理页面](https://appengine.google.com/)选择进入你的应用，在左边菜单选择 `Application Settings`，在页面底部，找到 `Cloud Integration`，点击 `Add project` 完成设置。

**启用 Push-to-Deploy**

1. 进入 [Google Cloud Console](https://cloud.google.com/console#c=l)，选择你要启用 Push-to-Deploy 的项目。
1. 通过左侧菜单 `Cloud Development` 进入 Push-to-Deploy 配置页面。如果没有在 GAE 中添加 Cloud 集成，这里将看不到这个菜单。
1. 点击 ` Create new repository` 按钮来创建一个 git 库。创建完成后会显示库的 url（形式如 https://code.google.com/id/xxxxxxx/），请记住该 url。
1. 点击 `Get password` 按钮，在弹出的窗口中点击 `Accept`，即可显示登录该 git 库的密码。
1. 在 Windows 下用户主目录（例如 C:\Documents and Settings\xxx\）中创建名称为 `_netrc` 的文本文件，内容如下
	```
	machine code.google.com login <email-address> password <auth-token>
	```
  其中 `email-address` 为等路 GAE 的 Email 帐号，`auth-token` 就是上一步中获取的密码。

**使用 Push-to-Deploy 发布 OpooPresss**
有三种方式可以使用 Push-to-Deploy，选任一种即可。

- 将 GAE 远程库作为非 origin 库
	```
	cd <directory of OpooPress output, containing app.yaml file>
	git init
	git add ./
	git commit -m 'Initial version' -a
	git remote add appengine <repo-url>

	git push appengine master
	```
- 将 GAE 远程库作为 origin 库
	```
	git clone <repo-url> mysite
	# 复制博客输出文件到 mysite 目录
	cd mysite
	git commit -a -m "Add my site"
	git push
	```
- 使用 OpooPress 本身的 deploy 功能
	
  可参考文档[《发布到 GitHub Pages》](http://www.opoopress.com/zh/docs/github-pages/#opoopress-wagon-git)，选用 `opoopress-wagon-git` 即可。

  此时需要在 OpooPress 博客主配置文件中配置 `deploy_server`。
	```
	deploy_server: {id: "gae", url: "git:https://code.google.com/id/xxxxxxx/", branch: "master"}
	```
  然后执行 `mvn op:deploy` 即可发布。

## 已知问题

这是一个部署在 GAE 上的 OpooPress 站点：<a href="http://opstatic.web.wondor.com/" rel="nofollow" target="_blank">http://opstatic.web.wondor.com/</a>

当前已知的问题是，通常意义上的目录默认页面 `index.html` 对于 GAE 来说是无效的，因为它没有目录这个概念。所以访问 `/about/` 时并不能直接访问到 `/about/index.html` 而引发 404 错误。
当然在 `app.yaml` 中明确的映射这个 url 是可以解决问题的，但是对于以 `/` 结尾的固定链接来说，不可能一个个在映射里写明。所以目前看来，解决办法有 2 个，一是写出一个满足条件的 URL 映射，
二是使用 `.html` 结尾的固定链接形式。
