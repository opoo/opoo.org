---
layout: post
title: 将 OpooPress 静态博客发布到 GitCafe Pages
date: '2014-07-31 13:29'
comments: true
published: false
description: "本文介绍如何将 OpooPress 生成的静态博客发布到 GitCafe Pages，并强调通过 Git 客户端发布博客时的应注意的几个问题。"
categories: [website]
tags: [OpooPress, GitCafe, GitCafe Pages]
url: '/2014/deploy-opoopress-to-gitcafe-pages/'
snapshot: '/wp-content/uploads/2014/gitcafe-logo-130x130.png'
---
本文介绍如何将 OpooPress 生成的静态博客发布到 GitCafe Pages，并强调通过 Git 客户端发布博客时的应注意的几个问题。
<!--more-->

## 关于 GitCafe Pages {#about-gitcafe-pages}

GitCafe 是一个基于代码托管服务打造的技术协作与分享平台，程序开发爱好者们可以通过使用代码版本控制系统 git 来将他们所写的开源或商业项目的代码托管在 GitCafe 上，与其他程序员针对这些项目在线协作开发。

GitCafe 则是一个类似于 GitHub Pages 的服务，为 GitCafe 用户提供网页服务。

主要特点：
- 免费托管公开库
- 支持静态内容和 Jekyll
- 支持绑定域名（且不需要备案，这点不同于七牛或其他云存储服务）
- 国内访问速度好


## 发布 OpooPress 到 GitCafe Pages {#how-to}

本文不介绍如何安装 OpooPress 静态博客，以及如何通过命令生成静态网站，相关知识请参考 [OpooPress 文档](http://www.opoopress.com/zh/download/)。这里只介绍如何将生成好的静态博客发布到 GitCafe Pages。

1. 在使用 GitCafe Pages 之前，先在 gitcafe.com 注册一个账户。

1. 参考[这个文档](https://gitcafe.com/GitCafe/Help/wiki/Pages-%E7%9B%B8%E5%85%B3%E5%B8%AE%E5%8A%A9)创建一个用于 Pages 服务的库，例如 `https://gitcafe.com/opoo/opoo`。

1. 在发布生成的静态网站之前，先为该库创建一个名为 `gitcafe-pages` 的远程分支。可参考上述文档或者 [GitHub 的这个文档](https://help.github.com/articles/creating-project-pages-manually)。总结起来，使用 Git 客户端创建该分支的步骤大致如下：
```shell
$ git clone git@gitcafe.com:opoo/opoo.git
$ cd opoo
$ git checkout --orphan gitcafe-pages
# Creates our branch, without any parents (it's an orphan!)
# 在当前分支新建一个文件，以便于将该分支提交到远程库
$ echo "My OpooPress Blog" > index.html
$ git add index.html
$ git commit -a -m 'First pages commit'
$ git push origin gitcafe-pages
```

1. 配置 OpooPress 博客的发布信息：打开配置文件 ` config.yml`，在最后添加 `deploy_server` 变量。由于我们选用 [opoopress-wagon-git](http://www.opoopress.com/zh/docs/github-pages/#opoopress-wagon-git) 方式，所以配置如下：
 
  HTTPS 方式
  ```
  deploy_server: {id: "gitcafe", url: "git:https://gitcafe.com/opoo/opoo.git", branch: "gitcafe-pages"}
  ```
  SSH 方式
  ```
  deploy_server: {id: "gitcafe", url: "git:default://git@gitcafe.com:opoo/opoo.git", branch: "gitcafe-pages"}
  ```
  
  其中，HTTPS 方式可能需要输入密码而导致发布失败([#ISSUE 9](https://github.com/opoo/opoopress/issues/9))，所以推荐使用基于 [Public Key](https://help.github.com/articles/generating-ssh-keys) 的 SSH 方式来访问 Git 库。

1. 运行 `mvn op:deploy` 发布 OpooPress 即可。


这是发布在 GitCafe Pages 的 OpooPress 站点: <a href="http://opoo.gitcafe.io/" rel="nofollow" target="_blank">http://opoo.gitcafe.io/</a>

## 注意要点 {#notes}
1. 需要在本地安装 Git 客户端；
1. 发布前必须先创建远程分支；
1. 在通过 [opoopress-wagon-git](http://www.opoopress.com/zh/docs/github-pages/#opoopress-wagon-git) 方式 SSH 协议发布到 GitHub Pages 和 GitCafe Pages 时，由于这两个服务提供的 git url 都是省略格式（即没有明确指明 SSH 协议），所以配置时使用 `default://` 作为其协议名称，完全 url 形式为 `git:default://git@gitcafe.com:opoo/opoo.git`，在明确指定 SSH 协议时，url 应为 `git:ssh://git@gitserver/opt/gitrepos/pages.git`。


## 创意用法 {#creative}

OpooPress 用户 [RenAd3](https://github.com/lawzizhuang/) 提供了一个很有创意的用法：由于 GitHub Pages 和 GitCafe Pages 都支持绑定域名，一个在国外访问快，一个在国内访问快，所以 RenAd3 将 OpooPress 同时发布到了 GitHub Pages 和 GitCafe Pages，再通过 DNSPod 之类的智能 DNS 解析服务，将国外流量执向 GitHub Pages，国内流量则指向 GitCafe Pages，实现了某种程度的　CDN。

真是生命不息，折腾不止啊！

## 写在最后
特别感谢 [RenAd3](https://github.com/lawzizhuang/) 和 [sconfield](https://github.com/sconfield)，他们的热心参与和贡献促成了本文的产生。