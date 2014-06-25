---
layout: post
title: '使用 Apache SSL 反向代理 Google 搜索'
date: '2014-06-25 10:30'
comments: true
published: true
description: '本文简单通过 Apache 使用 SSL 的方式，反向代理 Google 搜索，当然该方法也可以代理其它站点。'
excerpt: "通过 Apache 反向代理，可以在自己的服务器（VPS）上搭建一个支持 SSL 的 Google 搜索。"
categories: ["website"]
tags: ["Apache", "反向代理", "Google"]
url: '/2014/apache-proxypassreverse-google/'
snapshot: /wp-content/uploads/2014/g-100x100.png
---
安装 Apache httpd 和 mod_ssl 模块，然后修改 `ssl.conf`，核心配置如下：

```text
LoadModule ssl_module modules/mod_ssl.so
Listen 443

SSLPassPhraseDialog  builtin
SSLSessionCache         shmcb:/var/cache/mod_ssl/scache(512000)
SSLSessionCacheTimeout  300
SSLMutex default
SSLRandomSeed startup file:/dev/urandom  256
SSLRandomSeed connect builtin
SSLCryptoDevice builtin

<VirtualHost _default_:443>
	ServerAdmin root@localhost
	DocumentRoot /var/www/html
	ServerName www.yourdomain.com
	ErrorLog "/var/log/httpd/ssl-error_log"
	TransferLog logs/ssl-transfer_log

	SSLEngine on
	SSLProtocol all -SSLv2
	SSLCipherSuite ALL:!ADH:!EXPORT:!SSLv2:RC4+RSA:+HIGH:+MEDIUM

	SSLCertificateFile /etc/ssl/domain.crt
	SSLCertificateKeyFile /etc/ssl/domain.key
	SSLCertificateChainFile /etc/ssl/domain.ca-bundle.crt
	#SSLCACertificateFile /etc/ssl/root.pem
	
	CustomLog logs/ssl-access_log \
		 "%t %h %{SSL_PROTOCOL}x %{SSL_CIPHER}x \"%r\" %b \"%{Referer}i\" \"%{User-Agent}i\""
	SetEnvIf User-Agent ".*MSIE.*" \
		 nokeepalive ssl-unclean-shutdown \
		 downgrade-1.0 force-response-1.0


	SSLProxyEngine On
	RequestHeader set Front-End-Https "On"
	ProxyPass / https://www.google.co.jp/
	ProxyPassReverse / https://www.google.co.jp/
	CacheDisable *

	#RequestHeader unset Accept-Encoding
	#AddOutputFilterByType INFLATE;SUBSTITUTE;DEFLATE text/html text/xml
	#Substitute s|www.google.co.jp|www.yourdomain.com|ni

</VirtualHost>
```

核心的部分就是
```text
	SSLProxyEngine On
	RequestHeader set Front-End-Https "On"
	ProxyPass / https://www.google.co.jp/
	ProxyPassReverse / https://www.google.co.jp/
	CacheDisable *
```

下面这些指令用于替换网页中的链接。对于 Google 搜索，页面中关键链接都不是全路径的，不必替换。
```text
	RequestHeader unset Accept-Encoding
	AddOutputFilterByType INFLATE;SUBSTITUTE;DEFLATE text/html text/xml
	Substitute s|www.google.co.jp|www.yourdomain.com|ni
```

要代理的站可以根据需要替换。
