---
layout: post
title: 关于网站前端
date: '2013-10-21 11:49'
comments: true
published: true 
categories: [website]
tags: [Theme, front-end-optimization, web-fonts, cookie-free]
url: '/about-front-end/'
excerpt: "<p>最近部署了个新的博客主题，并花了些时间来做前端优化，在这过程中有不少收获，也遇到不少问题。现就部分笔者比较感兴趣的点拿出来记录一下。</p><p>本文主要涉及内容为 <b>Web 前端优化</b> 和 <b>Web Fonts</b>。</p>"
---

最近部署了个新的博客主题，并花了些时间来做前端优化，在这过程中有不少收获，也遇到不少问题。现就部分笔者比较感兴趣的点拿出来记录一下。

## 关于前端优化

笔者没有相关知识和技能，主要是按照 YSlow 和 Google PageSpeed 所建议的做，有些项是比较容易出问题的。

1. 减少请求次数

	通常的做法是将同类资源合并。例如将多个 JavaScript 脚本合并，将多个 CSS 文件合并，将每个图标一个图片的形式改为 CSS sprites（单个图片，基于背景定位及分割）。

1. 减少 HTTP 传输数据量
	
	A) 启用 HTTP 压缩（Gzip）。B) 压缩(Minify) JavaScript 和 CSS 文件。

1. 正确设置外部资源引入顺序
	
	将 CSS 放在 HTML 的头部，将 JavaScript 放在 HTML 的底部。CSS 用于渲染页面，需要放在前面。而 JavaScript 会阻塞式加载，应该放在最后。

1. 充分利用浏览器缓存
	
	给静态资源加上比较长的过期时间和缓存有效期。设置 ETags（通常 Apache 会自动设置）。

1. 使用 cookie-free 域
	
	静态资源通常都不需要发送和设置 cookie 信息，所以应该使用一个单独的域来做 [cookie-free domain](/tag/cookie-free/)。

1. 使用 CDN（Content Delivery Network）

	A) 整个站点使用 CDN。这需要较高的成本。

	B) 仅公共资源使用 CDN。这是比较通常的做法，可以非常好的利用浏览器缓存，并能分散服务器压力。比如多个网站都使用了 Google CDN 提交的 jQuery.js 时，浏览器仅在第一次访问第一个站点时下载该文件，访问其它站点时，可直接从缓存中获取。
	
	目前有这样一些提供公共资源的CDN：
	
	- [Google Hosted Libraries](https://developers.google.com/speed/libraries/devguide) - *AngularJS, Chrome Frame, Dojo, Exe Core, jQuery, MooTools, Prototype, script.aculo.us, SWFObject, Web Font Loader*
	- [Microsoft Ajax CDN](http://www.asp.net/ajaxlibrary/cdn.ashx) - *jQuery, Modernizr, JSHint, Knockout, Globalize, Bootstrap, ASP.NET MVC*
	- [CDNJS](http://cdnjs.com/) - *非常齐全，实质上使用 CloudFlare CDN*
	- [jQuery](http://code.jquery.com/) - *jQuery Core, jQuery UI, jQuery Mobile, jQuery Color, QUnit*
	- [Bootstrap CDN](http://www.bootstrapcdn.com/) - *bootstrap js & css*
	- [Public Resources on SAE](http://lib.sinaapp.com/) - *新浪 SAE 上的公共资源，国内速度好。*
	- [百度 CDN 公共库](http://developer.baidu.com/wiki/index.php?title=docs/cplat/libs) - *国内速度好。*


1. 减少 DNS 查询
	
	使用 Cookie-free 域和使用公共资源 CDN 都会增加整个网站要访问的域的数量，同时也增加了 DNS 查询数，一个 DNS 查询通常需要 20 到 120 毫秒的时间，在 DNS 查询期间浏览器无法下载任何数据。所以 YSlow 建议一个页面的使用的域不要超过 4 个。

1. 较少 DOM 对象数量
	
	保持比较简单的 HTML 结构，减少标签嵌套层次，这样可以增加页面渲染速度。对于负责页面来说优化该项比较有效果，但需要较高的设计水平。


以上优化建议其实需要辩证统一的，因为有些是有矛盾的，笔者就曾主要纠结于与公共资源相关的部分：

- 如果公共资源使用公共 CDN 或者静态资源使用 cookie-free 域，都会增加域数量，会增加 DNS 查询时间，且增加了 HTTP 请求次数。
- 如果将公共资源合并到网站的 JS 或者 CSS 中，则会增大网站服务器压力，且不能很好的利用 CDN 速度和缓存。

笔者最终将 jQuery，Bootstrap 脚本压缩合并到网站的脚本中了，主要是考虑到使用 Google Hosted 的 jQuery 会偶尔抽风。


以下是笔者优化时的 Apache 配置
```
<IfModule mod_mime.c>
	# Text
	AddType text/css .css
	AddType application/x-javascript .js
	AddType text/html .html .htm
	AddType text/richtext .rtf .rtx
	AddType text/plain .txt
	AddType text/xml .xml

	# Image
	AddType image/gif .gif
	AddType image/x-icon .ico
	AddType image/jpeg .jpg .jpeg .jpe
	AddType image/png .png
	AddType image/svg+xml .svg .svgz

	# Video
	AddType video/asf .asf .asx .wax .wmv .wmx
	AddType video/avi .avi
	AddType video/quicktime .mov .qt
	AddType video/mp4 .mp4 .m4v
	AddType video/mpeg .mpeg .mpg .mpe

	# PDF
	AddType application/pdf .pdf

	# Flash
	AddType application/x-shockwave-flash .swf

	# Font
	AddType application/x-font-ttf .ttf .ttc
	AddType application/vnd.ms-fontobject .eot
	AddType application/x-font-otf .otf
	AddType application/font-woff .woff

	# Audio
	AddType audio/mpeg .mp3 .m4a
	AddType audio/ogg .ogg
	AddType audio/wav .wav
	AddType audio/wma .wma

	# Zip/Tar
	AddType application/x-tar .tar
	AddType application/x-gzip .gz .gzip
	AddType application/zip .zip
</IfModule>

<IfModule mod_expires.c>
	ExpiresActive On

	# Text
	ExpiresByType text/css A31536000
	ExpiresByType application/x-javascript A31536000
	ExpiresByType text/html A3600
	ExpiresByType text/richtext A3600
	ExpiresByType text/plain A3600
	ExpiresByType text/xml A3600

	# Image
	ExpiresByType image/gif A31536000
	ExpiresByType image/x-icon A31536000
	ExpiresByType image/jpeg A31536000
	ExpiresByType image/png A31536000
	ExpiresByType image/svg+xml A31536000

	# Video
	ExpiresByType video/asf A31536000
	ExpiresByType video/avi A31536000
	ExpiresByType video/quicktime A31536000
	ExpiresByType video/mp4 A31536000
	ExpiresByType video/mpeg A31536000

	# PDF
	ExpiresByType application/pdf A31536000

	# Flash
	ExpiresByType application/x-shockwave-flash A31536000

	# Font
	ExpiresByType application/x-font-ttf A31536000
	ExpiresByType application/vnd.ms-fontobject A31536000
	ExpiresByType application/x-font-otf A31536000
	ExpiresByType application/font-woff A31536000

	# Audio
	ExpiresByType audio/mpeg A31536000
	ExpiresByType audio/ogg A31536000
	ExpiresByType audio/wav A31536000
	ExpiresByType audio/wma A31536000

	# Zip/Tar
	ExpiresByType application/x-tar A31536000
	ExpiresByType application/x-gzip A31536000
	ExpiresByType application/zip A31536000
</IfModule>
<FilesMatch "\.(?i:css|js|htm|html|rtf|rtx|txt|xml|gif|ico|jpg|jpeg|jpe|png|svg|svgz|asf|asx|wax|wmv|wmx|avi|mov|qt|mp4|m4v|mpeg|mpg|mpe|pdf|swf|ttf|ttc|eot|otf|woff|mp3|m4a|ogg|wav|wma|tar|gz|gzip|zip)$">
	<IfModule mod_headers.c>
		Header set Pragma "public"
		Header append Cache-Control "public, must-revalidate, proxy-revalidate"
		Header unset ETag
	</IfModule>
</FilesMatch>
<FilesMatch "\.(?i:css|js|gif|ico|jpg|jpeg|jpe|png|pdf|swf|ttf|ttc|eot|otf|woff)$">
    <IfModule mod_headers.c>
		Header unset Set-Cookie
	</IfModule>
</FilesMatch>
<FilesMatch "\.(?i:ttf|ttc|eot|otf|woff)$">
    <IfModule mod_headers.c>
		Header set access-control-allow-origin "SOMEDOMAIN or *"
    </IfModule>
</FilesMatch>

<IfModule mod_deflate.c>
	SetOutputFilter DEFLATE
	SetEnvIfNoCase Request_URI \.(?:exe|t?gz|zip|iso|tar|bz2|sit|rar)$ no-gzip dont-vary
	SetEnvIfNoCase Request_URI \.(?:gif|jpe?g|jpg|ico|png)$  no-gzip dont-vary
	SetEnvIfNoCase Request_URI \.pdf$ no-gzip dont-vary
	SetEnvIfNoCase Request_URI \.flv$ no-gzip dont-vary
	BrowserMatch ^Mozilla/4 gzip-only-text/html
	BrowserMatch ^Mozilla/4\.0[678] no-gzip
	BrowserMatch \bMSIE !no-gzip !gzip-only-text/html
	Header append Vary User-Agent env=!dont-vary
</IfModule>

```
	

## 关于 Web Fonts

如上一篇文章提到的，Web Fonts 似乎越来越流行了，而且不仅仅用做字体，还有个主要的用途就是图标。将字体用作图标有很多便利，比如可以随意调整大小而不会失真（因为字体是矢量的），可以随意设置颜色等。当前博客的部分图标就是基于自定义字体的。

说道自定义字体，不得不说说 [IcoMoon App](http://icomoon.io/app/) 这个超牛的工具。通过这个工具，你可以在线选择你需要的图标，然后生成 CSS Sprites 的图片或者生成 Web Fonts 下载，下载包中已经包含了定义好的 CSS 和实例 HTML 文件。此外，你还可以上传自己的 SVG 或者其它图片文件， IcoMoon App 会自动转成 CSS Sprites 或者 Web Fonts。

<i class="opoo-opooorg" style="font-size:36px;color:blue;"></i>

上面的这个图标，实质上是一个字符，就是通过 Web Fonts 定义的。
	<i class="opoo-opooorg" style="font-size:36px;color:blue;"></i>
