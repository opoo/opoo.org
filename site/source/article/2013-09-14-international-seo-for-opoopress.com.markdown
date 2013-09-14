---
layout: post
title: '关于 OpooPress 网站两种语言的 SEO 问题'
date: '2013-09-14 13:15'
comments: true
published: true
keywords: "多语言, SEO, OpooPress, rel-alternate-hreflang-x"
description: "本文总结与记录一下网站 opoopress.com 的两个语言之间的处理问题，以及在提高用户体验和 SEO 方面努力。"
categories: ["OpooPress"]
tags: ["OpooPress", "SEO"]
url: '/international-seo-for-opoopress.com/'
---

为了使得 [OpooPress](http://press.opoo.org/) 有更广的受众面，也为了展示该博客的一些特性（比如子目录），所以[网站](http://press.opoo.org/)准备了两种语言的版本，中文站在 <http://www.opoopress.com/zh/>，英文站在 <http://www.opoopress.com/en/>。 

之前为了获得更好的用户体验，在 Apache rewrite 规则中加入了如下规则（*注意，现在觉得这种配置可能是错误的*）：

	# root
	RewriteCond %{HTTP:Accept-Language} ^zh [NC]
	RewriteRule ^/$ /zh/ [L,R=301]
	RewriteRule ^/$ /en/ [L,R=301]

	# zh
	RewriteCond %{HTTP:Accept-Language} ^zh [NC]
	RewriteCond %{REQUEST_URI} !^/icons/
	RewriteCond %{REQUEST_URI} !^/error/
	RewriteCond /var/www/html/%{REQUEST_FILENAME} !-f
	RewriteCond /var/www/html/%{REQUEST_FILENAME} !-d
	RewriteRule ^/(.*)$ /zh/$1 [L,R=301]

	# others
	RewriteCond %{REQUEST_URI} !^/icons/
	RewriteCond %{REQUEST_URI} !^/error/
	RewriteCond /var/www/html/%{REQUEST_FILENAME} !-f
	RewriteCond /var/www/html/%{REQUEST_FILENAME} !-d
	RewriteRule ^/(.*)$ /en/$1 [L,R=301]

即根据用户浏览器语言进行判断，如果浏览器语言(HTTP 请求头 `Accept-Language`)是 `zh` 开头，则跳转到 `/zh/` 下对应页面，其它语言则跳转到 `/en/` 下对应页面。

直到最近查看 Apache 访问日志，发现基本上搜索引擎机器人发送的 HTTP 请求都不带有适当的 `Accept-Language` 参数，所以机器人基本上都只能访问英文版的网站，这可能会是一个问题。

我对“多语言站点应该使用子域名还是子目录”这个话题进行了搜索，结果发现了 Google 网站站长工具中的这篇文章——[多区域和多语言网站](https://support.google.com/webmasters/answer/182192?hl=zh-Hans)，其中一段指出：

> 避免根据推测的用户语言使用自动重定向功能。这些重定向可能会阻止用户（和搜索引擎）浏览您网站的所有版本。

根据该指南，我使用 [rel="alternate" hreflang="x"](https://support.google.com/webmasters/answer/189077) 和 [站点地图：rel="alternate" hreflang="x"](https://support.google.com/webmasters/answer/2620865) 重新对网站进行 SEO，并修改原来的 Apache rewrite 规则。

**rel="alternate" hreflang="x"**

对每个页面的头部加上类似以下的一段
	<link href="/zh/xxx/" rel="alternate" hreflang="zh">
	<link href="/en/xxx/" rel="alternate" hreflang="en">
	<link href="/en/xxx/" rel="alternate" hreflang="x-default">

这里指定英文页面作为不针对任何语言或语言区域的默认页。URL 中 xxx 在每个页面都是不同的。


**站点地图：rel="alternate" hreflang="x"**

可以使用站点地图来向 Google 提供 rel="alternate" hreflang="x"。见 [sitemap.xml](http://www.opoopress.com/sitemap.xml)。

**Apache rewrite 规则**
	# root
	RewriteRule ^/$ /zh/ [L,R=301]

	# others
	RewriteCond %{REQUEST_URI} !^/icons/
	RewriteCond %{REQUEST_URI} !^/error/
	RewriteCond /var/www/html/%{REQUEST_FILENAME} !-f
	RewriteCond /var/www/html/%{REQUEST_FILENAME} !-d
	RewriteRule ^/(.*)$ /zh/$1 [L,R=301]

对于访问根 `/` 和其它不存在的路径是，跳转到 `/zh` 下对应的路径。

总体来说：对于搜索用户，如果没有适合用户语言（非中文和英文）的页面，则默认显示英文页面；而对于用户直接敲入网址进入网站，如果没有选择合适的语言则默认跳转至中文页面。

这似乎挺矛盾！暂时还没想好，是不是应该统一。

