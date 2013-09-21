---
layout: post
title: '博客系统由 WordPress 更换成 OpooPress'
date: '2013-06-28 20:55'
comments: true
categories: ['others']
tags: ['opoopress']
url: '/wordpress-to-opoopress/'
keywords: 'OpooPress, WordPress, 博客迁移'
description: '本站博客系统由 WordPress 更换成 OpooPress——一个基于 Java 的静态博客生成器。'
---

即日起，本站博客系统由 [WordPress](http://wordpress.org/) 变更为 [OpooPress](http://press.opoo.org/)。

OpooPress 是博主自行开发的一个静态博客生成器，使用 [Java](http://www.oracle.com/technetwork/java/index.html) 语言和 [FreeMarker](http://www.freemarker.org/) 模板开发 `生成器` 部分，默认带一个支持 CSS3 响应式设计的主题。

<!--more-->

OpooPress 在开发过程中，仔细研究了 [Jekyll](http://jekyllrb.com) 和 [Octopress](http://octopress.org/)，代码参考了 Jekyll 的 Ruby 源代码，主题则主要来自于 Octopress。最初的本意只是为不熟悉 Ruby 的开发者提供一个 Java 版本的 Octopress，也与 Octopress 作者 Brandon Mathis 沟通过。但在后来的开发过程中发现这不仅仅是两个编程语言间的翻译，还涉及到 Java 体系与 Ruby 体系之间的转换，两种体系的设计架构、代码组织和可利用的包都是不同的，比如需要纯 Java 版的 `SASS/Compass` 编译器就很难。

OpooPress 的源文件格式与 Jekyll/Octopress 的相同，每个文件带有一个 [YAML front matter](http://jekyllrb.com/docs/frontmatter/) 的头部，正文内容可以使用 HTML 或者 Markdown 语法格式，可以穿插 FreeMarker 模板代码，将来的插件可能使用这种机制完成。OpooPress 的页面布局也暂时与 Octopress 相似，一个好处就是可以直接使用 Octopress 主题的样式单。



* 生成器
    * standalone 版：一个基于普通命令行的独立发行版本，只要装有 Java 即可以使用，跨平台。执行命令就像这样 `press install`，`press build` 和 `press deploy`。目前支持的发布协议主要是文件系统和 `SSH/SCP`，也是最常用的，满足最基本的需求。
  
    * maven plugin 版：该版本基础功能同独立发行包，但发布功能将更强大，凡是 `mvn deploy` 支持 OpooPress 都支持。例如可以发布到 `FTP`, `WebDAV` 等，具体可参考 [Apache Maven Wagon](http://maven.apache.org/wagon/)。通过 GitHub 的一个插件，还可以发布到 [GitHub Pages](http://pages.github.com/)，估计这是许多人所需要的。

* 主题
    * 模板：FreeMarker 模板文件。
    * 源文件：`页面`、`文章`以及其它包含有 FreeMarker 代码（例如${'$'}{site.url}）的文件，必须包含  [YAML front matter](http://jekyllrb.com/docs/frontmatter/) 。
    * 静态文件：图片、样式单、JavaScript 脚本等文件，这些文件可以放在源文件中，但单独存放有利于博客生成速度。
    * SASS/SCSS：样式单源文件。

   
暂时就写这么多。

OpooPress 的产品网站 [OpooPress.com](http://press.opoo.org/)，文档、帮助将会发布在那里。

一个 beta 版的 stanalone 包将在不久的将来发布，源代码也将提交到 GitHub，敬请关注。
