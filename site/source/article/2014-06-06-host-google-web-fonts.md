---
layout: post
title: '解决 Google Web Fonts 无法加载导致网页卡顿的问题'
date: '2014-06-06 10:30'
comments: true
published: true
description: '解决 Google Web Fonts 无法加载导致网页卡顿的问题，可以将字体及相关样式上传至七牛云存储，也可在自己的服务器上放置字体文件。'
excerpt: "近期由于某些原因，Google Https 服务被屏蔽，其它在华服务遭遇大规模干扰，包括 Google Web Fonts 服务。由于目前很多网站(特别是新版的 WordPress)都使用了 Google Web Fonts，导致这些网站在打开时由于无法加载字体而严重卡顿。"
categories: ["website"]
tags: ["Google Web Fonts", "web-fonts", "qiniudn", "WordPress"]
url: '/2014/host-google-web-fonts/'
snapshot: /wp-content/uploads/2014/g-100x100.png
---
近期由于某些原因，[Google Https 服务被屏蔽](http://lin.uno/2014/06/a3872.html)，其它[在华服务遭遇大规模干扰](http://lin.uno/2014/06/a3874.html)，包括 Google Web Fonts 服务。由于目前很多网站都是用了 Google Web Fonts，特别是新版的 WordPress，导致这些网站在打开时由于无法加载字体而严重卡顿。

要解决这个问题，要么不用 Google Web Fonts，要么将字体放到自己的服务器上。

这几天应该出现了很多关于如何禁用 WordPress 中的 Google Web Fonts 的文章，这里不赘述。本文主要讲述如何将字体及样式放到自己的服务器上。


## Step 1: 下载样式及字体
Google Web Fonts 引用的样式单通常是这样的地址 `http//fonts.googleapis.com/css?family=FONT-FAMILY-NAME`。

1. 首先将该文件下载到本地，保存为 `fonts.css`。
1. 打开 `fonts.css`（如图），将每个 url 指向的字体文件（*.woff）都下载到本地的 `fonts/` 目录。
1. 将 `fonts.css` 中的 url 都改成你本地的文件路径，如 `fonts/font-x.woff`。CSS 中的 URL 可以使用相对路径。

![Google Web Fonts CSS](/wp-content/uploads/2014/google-web-fonts-css-snapshot.png)

现在，就可以将这个字体样式单和字体文件放到自己的服务器上了。

## Step 2: 上传样式及字体

可将字体上传至一些云服务，CDN 等，以提高访问速度，也可以上传至自己的服务器。在介绍具体操作步骤之前，先看看什么是 `Access-Control-Allow-Origin`。


### 关于 Access-Control-Allow-Origin

`Access-Control-Allow-Origin` 是 HTML5 中定义的一种服务器端返回 Response header，用来解决资源（比如字体）的跨域权限问题。

它定义了该资源允许被哪个域引用，或者被所有域引用（Google Web Fonts 使用 `*` 表示字体资源允许被所有域引用）。

如果用作字体服务的域（如 static.yourdomain.com）和使用该字体的域（如 www.yourdomain.com）不相同，就必须在用作字体服务的域上设置正确的 `Access-Control-Allow-Origin` 响应头，才能被另外一个域访问。后文详述如何配置。



### 方法 1、将样式及字体上传至七牛云存储

可以如本站一样将样式和字体上传到七牛云存储。

七牛在国内的访问速度是一流的。而且七牛云存储上的字体支持跨域访问，响应头里带有正确的 `Access-Control-Allow-Origin` 属性。

在使用七牛云存储之前，需要[注册成为七牛用户](http://portal.qiniu.com/signup?code=1jfjbktdd1u)，
然后[取得 AccessKey 和 SecretKey](https://portal.qiniu.com/setting/key)。

可使用 [qrsync 工具](http://docs.qiniu.com/tools/v6/qrsync.html)将样式和字体上传到七牛。

然后修改原来引用 Google Web Fonts 样式的路径。如 
```html
<link href="http://xxxxxx.u.qiniudn.com/fonts.css" rel="stylesheet" type="text/css">
```
如果站点还要支持 HTTPS 访问，修改为
```html
<link href="//dn-xxxxxx.qbox.me/fonts.css" rel="stylesheet" type="text/css">
```
注意，要先在`域名设置`里为空间添加一个 `dn-xxxxxx.qbox.me` 的域。[七牛只有 `qbox.me` 这个域支持 HTTPS](http://kb.qiniu.com/https-support)。

### 方法 2、将样式及字体上传至自己的服务器

如果字体和使用字体的网站是同一个域，不存在跨域访问问题（见 Access-Control-Allow-Origin 章节），则简单修改样式的路径即可
```html
<link href="/css/fonts.css" rel="stylesheet" type="text/css">
```
如果静态内容（包括字体）在单独的域上（为了[cookie-free](/tag/cookie-free/) 等目的），则需要对该域的服务器进行配置，以 Apache 服务器为例，需要设置字体文件的响应头信息。
```text
<FilesMatch "\.(?i:ttf|ttc|eot|otf|woff)$">
    <IfModule mod_headers.c>
		Header set access-control-allow-origin "SOMEDOMAIN or *"
    </IfModule>
</FilesMatch>
```
[完整的配置文件参考这里](/about-front-end/)。然后修改引用样式的代码：
```html
<link href="http://static.yourdomain.com/css/fonts.css" rel="stylesheet" type="text/css">
```
