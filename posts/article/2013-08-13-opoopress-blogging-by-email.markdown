---
layout: post
title: 使用邮件发表 OpooPress 博客
date: '2013-08-13 17:52'
comments: true
published: true
description: "通过 OpooPress Mailet，可以使用邮件发表 OpooPress 博客。"
url: '/opoopress-blogging-by-email/'
keywords: "OpooPress, Blog, static site/blog generator, open source"
categories: [website]
tags: [opoopress, Mailet, VPS]
---
现在，通过 OpooPress Mailet 软件包，我们可以轻松地使用邮件来发表 OpooPress 文章了。这极大的增强了 OpooPress 的移动性。

## 基本用法
只需要向指定的 Email 地址发送邮件即可发表博客文章。邮件格式最好采用**纯文本**，但不是强制的。

邮件的标题就是文章的标题，邮件的内容就是文章的正文，这就是 OpooPress Mailet 最基本的用法。关于自定义文章文件名、发布时间、标签、分类等高级应用请阅读后续章节。
<!--more-->

## 基本原理
利用邮件发表博客文章其实是一个比较通用的思路，不仅仅可以用在 OpooPress 这类的静态博客，也可以用在 WordPress 之类的动态博客上。其大致处理流程如下：
1. 监听指定邮件地址的邮箱，发现新邮件则调用`邮件转博客`程序进行处理；
	- 对于第三方邮件服务器
		- 可使用 API 监听新邮件事件，例如 [Google App Engine](https://appengine.google.com/) 就可以[处理 Incoming Email](https://developers.google.com/appengine/docs/python/mail/receivingmail)；
		- 可通过 POP3、IMAP 等协议定时检查新邮件。
	- 对于自有邮件服务器
		- 可直接在邮件服务器端进行扩展来监听新邮件事件，这个处理过程将是实时的。OpooPress Mailet 采用这种机制。
2. 邮件转博客：根据邮件发送人地址、标题、内容等生成博客文章。
	- WordPress 类动态博客：调用博客 API（XML-RPC）生成新文章，或者直接将文章信息保存进博客的数据库。
	- OpooPress 类静态博客：
		- 生成博客文章源文件（Markdown, Textile 等格式）；
		- 调用静态博客引擎生成网站；
		- 调用静态博客引擎发布网站。
3. 将处理过程和结果信息自动回复邮件给发送者。

## OpooPress Mailet
OpooPress Mailet 是使用 [Apache Mailet API](http://james.apache.org/mailet/api/index.html) 编写的邮件处理程序，只能运行在 [Apache James Server](http://james.apache.org/server/index.html)上，所以必须自己搭建邮件服务器。

**基本需求**
- 邮件服务器 (域名，IP等。例如 VPS)
- 邮件服务器应用软件 [Apache James Server 2.3.2](http://james.apache.org/download.cgi#Apache_James_2.3.2_is_the_stable_version)
- OpooPress Mailet 软件包

### 搭建流程

示例环境如下：
- Virtual Private Server (VPS) 
	- RAM: 512M
	- OS: CentOS 6.4
	- 域名: opoopress.mail.opoo.org
	- IP: 1.2.3.4
- Java OpenJDK 1.7.0
- Apache Maven 3.1.0
- Apache James 2.3.2

#### 一、安装 OpooPress 博客

请[参考该文档](http://www.opoopress.com/zh/docs/installation/)来安装 Java, Apache Maven 并安装和初始化 OpooPress 博客。完成后应该可以正常运行 OpooPress 的各种指令。

#### 二、安装配置 Apache James
1. 在域名管理面板中绑定域名
	- 设置域名 `opoopress.mail.opoo.org` `A` 记录为 `1.2.3.4`
	- 设置域名 `opoopress.mail.opoo.org` `MX` 记录为 `1.2.3.4`
2. 下载 [Apache James Server 2.3.2](http://james.apache.org/download.cgi#Apache_James_2.3.2_is_the_stable_version) 软件包，如 `james-binary-2.3.2.tar.gz`。
3. 解压 James 到 `/usr/local/`
```
tar zxvf james-binary-2.3.2.tar.gz
mv james-2.3.2 /usr/local/
```
4. 启动和停止 James
	- 运行 `chmod +x /usr/local/james-2.3.2/bin/*.sh` 修改 James 脚本权限
	- 运行 `/usr/local/james-2.3.2/bin/run.sh`，第一次运行会生成 `/usr/local/james-2.3.2/apps/james` 目录
	- 键入 `Ctrl + C` 停止 James
5. 修改 James 配置文件 `/usr/local/james-2.3.2/apps/james/SAR-INF/config.xml`
	- 将所有 `localhost` 替换为您的域名，如 `opoopress.mail.opoo.org`
	- 将所有 `myMailServer` 替换为你的域名，如 `opoopress.mail.opoo.org`
	- 将所有 `autodetect="true"` 替换为 `autodetect="false"`
	- 将所有 `autodetectIP="true"` 替换为 `autodetectIP="false"`
	- 配置 DNS
```xml
<dnsserver>
    <servers>
        <server>8.8.8.8</server>
        <server>8.8.4.4</server>
    </servers>
    ...
</dnsserver>
```
	- **可选**：如果需要从外部调用 SMTP 发邮件，请注释 `RemoteAddrNotInNetwork=127.0.0.1` 所在的节点，并去掉 `<smtpserver/>` 段 `<authRequired>` 和 `<verifyIdentity>` 节点的注释。OpooPress Mailet 本身是不需要修改该项配置的。
6. 添加用户。运行 `/usr/local/james-2.3.2/bin/run.sh` 启动 James，`telnet` 到 `4555` 端口进行管理。
```
JAMES Remote Administration Tool 2.3.2
Please enter your login and password
Login id:
root
Password:
root
Welcome root. HELP for a list of commands
```
运行 `adduser <username> <password>` 添加邮件用户
```
adduser site1 site1password
adduser site2 site2password
adduser site3 site3password
```
添加用户后，可在邮件客户端（如 Foxmail）中进行测试。设置用户 site1, site2, site3 的 POP3 和 SMTP 地址为你的域名（如 opoopress.mail.opoo.org），然后使用第三方邮箱（如 Gmail）分别向这几个邮箱里发送邮件，检查邮件接收情况。也可以使用这几个邮箱互发邮件（需要按第五步配置允许外部调用 SMTP）测试其发送和接收情况。


#### 三、安装配置 OpooPress Mailet
1. 安装 OpooPress Mailet 软件包。目前需要从源码打包 OpooPress Mailet 软件包。
```
git clone https://github.com/opoo/opoopress.git
cd opoopress/mailet
mvn package
mvn dependency:copy-dependencies
```
运行后，会在 `opoopress/mailet/target` 目录中生成 `opoopress-mailet-<VERSION>.jar` 的软件包，并将依赖的 jar 包复制到 `opoopress/mailet/target/dependency` 目录。

  将 `opoopress/mailet/target/opoopress-mailet-<VERSION>.jar` 和 `opoopress/mailet/target/dependency` 目录中的所有 Jar 包（junit 除外）复制到 Apache James 目录 `/usr/local/james-2.3.2/apps/james/SAR-INF/lib/` 下，如果 `lib` 不存在，则需要先创建。
```
mkdir /usr/local/james-2.3.2/apps/james/SAR-INF/lib/
cp target/opoopress-mailet-*.jar /usr/local/james-2.3.2/apps/james/SAR-INF/lib/
rm target/dependency/junit-*.jar
cp target/dependency/*.jar /usr/local/james-2.3.2/apps/james/SAR-INF/lib/
```
2. 修改 Apache James 配置 `/usr/local/james-2.3.2/apps/james/SAR-INF/config.xml`，在 `<spoolmanager><processor name="root">` 节点中插入 OpooPress Mailet 配置
```xml
	<mailet match="RecipientIsAndSenderIs=site1@opoopress.mail.opoo.org|writer@opoopress.mail.opoo.org,yourname@gmail.com" class="OpooPressMailet">
		<site>/home/sites/opoopress-site1/site</site>
		<command>mvn op:deploy</command>
	</mailet>
	<mailet match="RecipientIsAndSenderIs=site2@opoopress.mail.opoo.org|writer@opoopress.mail.opoo.org,yourname@gmail.com" class="OpooPressMailet">
		<site>/home/sites/opoopress-site2/site</site>
		<command>mvn op:deploy</command>
	</mailet>
```
每个博客（站点）都由一个 `<mailet/>` 节点来进行配置。 其中
	- **match 参数**：即 match `=` 后的字符串。邮件接收地址和邮件发送人地址中使用 `|` 分隔，多个地址之间使用 `,` 分隔。只有接收地址和发送地址都匹配时，mailet 才会调用。接收地址都必须是当前 Apache James 服务器中有效的账户。发送地址可以是任意有效的邮件地址，如果使用当前 Apache James 服务器的账号作为发送人地址，则必须开启 James 的 SMTP 认证（参考前面章节）。
	- **site**：当前 mailet 要处理的 OpooPress 博客（站点）的主目录。
	- **command**: mailet 将博客文章成功保存后，要执行的命令。
		- 通常是 `mvn deploy`，会以 **site** 的上级目录作为工作目录（因为 pom.xml 文件位于该目录）。
		- 如果一个 pom.xml 下有多个站点，例如多站点 [OpooPress.com](https://github.com/opoo/opoopress.com)，该属性可能是 `mvn deploy -Dsite=zh`，而 site 属性可能是 `/home/sites/opoopress.com/zh`。
		- 如果有较为复杂的处理，也可以写成脚本，在这里配置脚本脚本路径。例如发布博客并提交 git 的脚本 `/home/scripts/deploy_my_site.sh`
		```
		cd /home/sites/opoopress-site1
		mvn deploy
		git add site/source
		git commit -a -m "Add new post"
		git push
		```

#### 四、使用邮件发布博客

本章示例讲解的是 OpooPress Mail 的高级应用，文章开头已经讲过基本用法。

使用**纯文本**格式向指定的邮件地址（如 site1@opoopress.mail.opoo.org）发送文章内容，示例见下图
![OpooPress Blogging by Mail Snapshot](/wp-content/uploads/2013/opoopress-blogging-by-mail-snapshots.png)

**邮件标题** 

邮件的标题会被解析成文章的`标题`和 `name`。

`标题`和 `name` 两个值通过以下规则解析：
- 如果邮件标题包含分隔符 `|`，则分隔符前的是`标题`，分隔符后的是 `name`。 例如 "世界，你好|hello-world"，"世界，你好|hello world" 或者 "世界，你好|2013-08-13-hello-world.textile"
- 如果邮件标题没有分隔符，则文章 `标题` 和 `name` 都等于 邮件标题。

在确定 `name` 属性后，`name` 属性会被 [SlugHelper](https://github.com/opoo/opoopress/blob/master/core/src/main/java/org/opoo/press/SlugHelper.java) 处理成 `slug` 形式。这个 `slug` 形式的 `name` 决定了将要生成的文章源文件的文件名，也决定了最后生成的文章的 URL（除非在内容里明确指定了 URL）。

通过以下一些示例来讲解 `name`、`文章源文件名` 和 `文章 URL` 之间的关系，这里假设当前博客的 `permalink` 格式为 `/article/${'$'}{name}/`，当前日期是`2013年08月13日`：
- Name: Hello Mail
	- 文件名: 2013-08-13-hello-mail.markdown
	- 文章 URL:  /article/hello-mail/
- Name: 2013-08-13-hello-mail
	- 文件名: 2013-08-13-hello-mail.markdown
	- 文章 URL: /article/hello-mail/
- Name: 2013-08-13-hello-mail.textile
	- 文件名: 2013-08-13-hello-mail.textile
	- 文章 URL: /article/hello-mail/
- Name: hello-mail.textile
	- 文件名: 2013-08-13-hello-mail.textile
	- 文章 URL: /article/hello-mail/

**邮件内容**

邮件的内容即文章源文件的内容，其格式遵循 OpooPress 源文件格式：
- 可以包含 [YAML front-matter](http://www.opoopress.com/zh/docs/frontmatter/) 的头部，如果不包含，则 OpooPress Mailet 会自动添加头部信息。
- 如果头部不包含 `title` 变量，则使用上一步骤中解析出的标题。如果包含，则忽略从邮件标题解析出的标题。
- 如果头部不包含 `date` 变量，则使用邮件标题中解析中的时间或者当前时间。

上面图示的邮件发布后的效果见 <http://demo.opoo.org/demo/>。

**邮件回复**

OpooPress Mailet 运行过程情况会通过邮件回复给发件地址人，邮件的内容是：发生异常时的异常堆栈信息，成功执行命令时的输出，执行过程中的日志信息等，邮件的附件是该文章的源文件。示例如下：
```
File writen: /home/sites/mysite/site/source/article/2013-08-13-this-is-a-post-publish-by-email.markdown
Execute command: mvn op:deploy
========================

[INFO] Scanning for projects...
[INFO]                                                                         
[INFO] ------------------------------------------------------------------------
[INFO] Building My OpooPress.com site 1.0-SNAPSHOT
[INFO] ------------------------------------------------------------------------
[INFO] 
[INFO] --- opoopress-maven-plugin:1.0.1-SNAPSHOT:deploy (default-cli) @ my-opoopress-site ---
[INFO] The site directory is : /home/sites/mysite/site
[INFO] Skipping install, site already installed.
[INFO] Skipping sass compile, css file is up to date.
[INFO] File '/home/sites/mysite/site/source/article/2013-08-13-this-is-a-post-publish-by-email.markdown' is newer than 'Tue Aug 13 07:08:08 UTC 2013'
[INFO] Source file has been changed after time 'Tue Aug 13 07:08:08 UTC 2013', regenerate site.
[INFO] Reading sources ...
[INFO] Rendering ...
[INFO] Writing files ...
[INFO] Writing 2 posts
[INFO] Writing 12 pages
[INFO] Copying 1 assets directory
[INFO] Generate time: 492ms
[INFO] Destination [/home/sites/mysite/target/public/site]
...
```



## 注意事项

出于安全性考虑。Apache James、OpooPress Mailet 安装、配置、调试完成后，必须再次修改 Apache James 配置文件 `config.xml`。

* 禁用远程管理服务：`<remotemanager/>` 节点 `enabled` 改为 `false`。
* 禁用 NNTP 服务：`<nntpserver/>` 节点 `enabled` 改为 `false`，并将 `nntp-repository` 中的 `threadCount` 为 `0`。


如果要以服务（后台进程）的形式运行 Apache James，请使用以下命令:
```
/usr/local/james-2.3.2/bin/phoenix.sh start
```
停止
```
/usr/local/james-2.3.2/bin/phoenix.sh stop
```


----
### 推广链接
* [本文示例环境所使用的 VPS](https://www.digitalocean.com/?refcode=b105fdd333e8) - $5/mo. Digital Ocean VPS
