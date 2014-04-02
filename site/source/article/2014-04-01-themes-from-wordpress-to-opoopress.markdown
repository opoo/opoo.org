---
layout: post
title: 如何将 WordPress 主题转成 OpooPress 主题
date: '2014-04-01 16:57'
comments: true
published: true
description: 缺乏丰富的主题的确是目前 OpooPress 的一个大问题，一个优秀的主题往往是集创意、设计、编码等天赋和技能于一体，是非常不容易的。本文以示例的形式展示如何将 WordPress 博客的主题转成 OpooPress 的主题。
excerpt: 本文以示例的形式展示如何将 WordPress 博客的主题转成 OpooPress 的主题。
categories: [website]
tags: [WordPress, OpooPress]
url: '/themes-from-wordpress-to-opoopress/'
snapshot: http://s.w.org/about/images/logos/wordpress-logo-simplified-rgb.png
---

缺乏丰富的主题的确是目前 OpooPress 的一个大问题，一个优秀的主题往往是集创意、设计、编码等天赋和技能于一体，是非常不容易的。

本文以示例的形式展示如何将 WordPress 博客的主题转成 OpooPress 的主题。转换其它博客或者网站主题到 OpooPress 主题的思路和这个是一样的。这项操作俗成**扒皮**。

**注意：请尊重他人的劳动成果和版权。**

*通过本文介绍的方法，可将授权许可允许的其它语言的主题（大部分开源的WordPres主题）转换成 OpooPress 主题，如果你这样做了，请注明出处或者保留原始的版权信息。*


## 条件 {#first-of-first}
* 一项技能：查看源代码
* 一个神器：谷歌 Chrome 浏览器或者装有 FireBug 的 FireFox 浏览器

## 准备 {#preparation}

先准备好 WordPress 博客，并安装好需要转换的主题。本文以 WordPress [Twenty Twelve](http://wordpress.org/themes/twentytwelve) 1.3 主题为例，该主题基于 [GNU General Public License V2](http://www.gnu.org/licenses/gpl-2.0.html) 授权，界面比较清爽，元素看起来相对较少，可以作为一个学习的好例子。

准备一个空白的 OpooPress 博客，方法很简单：创建一个目录，下载 [pom.xml](http://www.opoopress.com/downloads/pom.xml) 到这个目录，然后在命令行下进入到该目录，执行 `op:install` 即可。可参考[文档](http://www.opoopress.com/zh/download/)。

## 准备资源文件

先删除 `config.rb` 文件和 `sass` 目录，这是默认主题的样式源文件，转换时没有 Twenty Twelve 主题的 compass 源文件，所以直接删除配置和相关目录。同时删除原来的样式文件 `assets/stylesheets/screen.css`。

删除 `assets/images` 中的内容。

打开 WordPress 博客，查看源代码，将页面中引用到的 css 和 js 资源全部复制到 OpooPress 博客的 assets 目录下去。
* /wp-content/themes/twentytwelve/style.css --> site/assets/stylesheets/
* /wp-content/themes/twentytwelve/css/ie.css --> site/assets/stylesheets/
* /wp-content/themes/twentytwelve/js/*.js --> site/assets/javascripts/


## 整理模板

这里以[默认主题模板](http://www.opoopress.com/zh/docs/theme/templates/)为基础，进行少许改造，大体结构不变。

### 布局模板文件（layout）

1. **defaultLayout**: 查看 WordPress 博客首页、示例页面、文章三类 web 页面的源代码，寻找共性，抽象出 html 页面的骨架，这个架子就是 default 布局。详见 [templates/_default.ftl][]。
	
	该模板定义宏 `defaultLayout`，`<#nested>` 是待填充的内容。

1. **postLayout**: 查看 WordPress 博客的文章页面源码，抽出用于显示文章的骨架。页面的主要组成部分是文章和边栏。文章的元素包括标题、评论链接、内容、发布时间、分类、标签、导航、评论等。边栏则另外抽出来，放在其它模板文件中。详见 [templates/_post.ftl][]。
	
	该模板定义了宏 `postLayout`，定义引用了宏 `defaultLayout`，即，将 `<@defaultLayout>` 标记之间的内容作为 `defaultLayout` 的 `<#nested>`，也可理解为该模板是 default 模板的子模板。

1. **pageLayout**: 从 WordPress 源文件中抽出普通页面的架子，主要部分是标题、内容、评论、边栏等。详见 [templates/_page.ftl][]。


### 模板片段文件
1. HTML头（[templates/head.ftl][]）: 将 HTML 文件开头到 `</head>` 之间的内容放在这个文件里，参考 OpooPress 默认主题原始的 head.ftl 文件，直接在此基础上加入  WordPress Twenty Twelve 主题所需的样式单即可。
* 页头（[templates/header.ftl][]）: 将网站一、二级标题，导航菜单等整理到这个文件。
* 页脚（[templates/footer.ftl][]）: 将网站页脚整理到这个文件。
* HTML最后（[templates/after_footer.ftl][]）: 根据网站优化原则，应将 JavaScript 脚本放到最后，所以这里引入 WordPress Twenty Twelve 用到的脚本 `navigation.js`，其它保持默认模板内容即可。

	该模板中引用的几个片段文件（位于目录 [templates/after_footer][] 中）可以保持不变。

* 边栏（目录 templates/asides）: 参考 Twenty Twelve，修改边栏 Widget 模板，包括 
	- [templates/asides/categories.ftl]
	- [templates/asides/delicious.ftl]
	- [templates/asides/github.ftl]
	- [templates/asides/googleplus.ftl]
	- [templates/asides/pinboard.ftl]
	- [templates/asides/recent_comments.ftl]
	- [templates/asides/recent_posts.ftl]
	- [templates/asides/tags.ftl]
	
	修改这些 Widget，使用 `<aside/>` 作为每个 Widget 的最外层标签，使用 `<h3 class='widget-title'>` 作为 Widget 标题。
	
	增加边栏 Widget 模板 [templates/asides/searchbox.ftl]，用于显示博客的搜索框。

	该目录的其它文件保持不变。
* templates/i18n 目录中的模板保持不变
* templates/index 目录中的模板保持不变。
* 整理 templates/post 中的模板，根据需要修改 [templates/post/comments.ftl] 和 [templates/post/related_posts.ftl]，其它保持不变。
* 整理**分类**页面的模板：新建 [templates/category.ftl] 文件，参考 Twenty Twelve 的分类页面，定义模板内容。显示每一篇文章的模板定义在 [templates/post/archive_post.ftl] 中。
* 整理**标签**页面的模板：新建 [templates/tag.ftl] 文件，参考 Twenty Twelve 的标签页面，定义模板内容。

## 整理源文件
1. 首页 - [source/index.html]: 使用 `default` 布局，参考 Twenty Twelve 首页。
1. 归档页 - [source/archives/index.html]: 参考分类和标签的模板，使用 `default` 布局。

其它源文件可不修改。

## 功能扩充

在 `post` 布局上添加分享栏和相关文章。

## 优化
1. 合并 css 和 js 文件，并修改相应的链接为合并后的文件。
2. 删除用不上的模板片段。

## 最后

本文示例整理的主题已经发布到 <a href="https://github.com/opoo/opoopress-theme-wptt" target="_blank">GitHub</a>，示例在<a href="http://demo.opoo.org/wptt/" target="_blank" rel="nofollow">这里</a>。使用步骤如下：

- 创建目录 myblog
- 下载 [pom.xml](http://www.opoopress.com/downloads/pom.xml) 到该目录
- 命令行进入该目录
- 执行 `git clone https://github.com/opoo/opoopress-theme-wptt.git site`
- 执行 `mvn op:preview`
- 打开浏览器访问 `http://localhost:8080/`


[templates/_default.ftl]: https://github.com/opoo/opoopress-theme-wptt/blob/master/templates/_default.ftl
[templates/_post.ftl]: https://github.com/opoo/opoopress-theme-wptt/blob/master/templates/_post.ftl
[templates/_page.ftl]: https://github.com/opoo/opoopress-theme-wptt/blob/master/templates/_page.ftl
[templates/head.ftl]: https://github.com/opoo/opoopress-theme-wptt/blob/master/templates/head.ftl
[templates/header.ftl]: https://github.com/opoo/opoopress-theme-wptt/blob/master/templates/header.ftl
[templates/footer.ftl]: https://github.com/opoo/opoopress-theme-wptt/blob/master/templates/footer.ftl
[templates/after_footer.ftl]: https://github.com/opoo/opoopress-theme-wptt/blob/master/templates/after_footer.ftl
[templates/after_footer]: https://github.com/opoo/opoopress-theme-wptt/tree/master/templates/after_footer
[templates/asides]: https://github.com/opoo/opoopress-theme-wptt/blob/master/templates/asides
[templates/asides/categories.ftl]: https://github.com/opoo/opoopress-theme-wptt/blob/master/templates/asides/categories.ftl
[templates/asides/delicious.ftl]: https://github.com/opoo/opoopress-theme-wptt/blob/master/templates/asides/delicious.ftl
[templates/asides/github.ftl]: https://github.com/opoo/opoopress-theme-wptt/blob/master/templates/asides/github.ftl
[templates/asides/googleplus.ftl]: https://github.com/opoo/opoopress-theme-wptt/blob/master/templates/asides/googleplus.ftl
[templates/asides/pinboard.ftl]: https://github.com/opoo/opoopress-theme-wptt/blob/master/templates/asides/pinboard.ftl
[templates/asides/recent_comments.ftl]: https://github.com/opoo/opoopress-theme-wptt/blob/master/templates/asides/recent_comments.ftl
[templates/asides/recent_posts.ftl]: https://github.com/opoo/opoopress-theme-wptt/blob/master/templates/asides/recent_posts.ftl
[templates/asides/searchbox.ftl]: https://github.com/opoo/opoopress-theme-wptt/blob/master/templates/asides/searchbox.ftl
[templates/asides/tags.ftl]: https://github.com/opoo/opoopress-theme-wptt/blob/master/templates/asides/tags.ftl
[templates/post/comments.ftl]: https://github.com/opoo/opoopress-theme-wptt/blob/master/templates/post/comments.ftl
[templates/post/related_posts.ftl]: https://github.com/opoo/opoopress-theme-wptt/blob/master/templates/post/related_posts.ftl
[templates/category.ftl]: https://github.com/opoo/opoopress-theme-wptt/blob/master/templates/category.ftl
[templates/tag.ftl]: https://github.com/opoo/opoopress-theme-wptt/blob/master/templates/tag.ftl
[templates/post/archive_post.ftl]: https://github.com/opoo/opoopress-theme-wptt/blob/master/templates/post/archive_post.ftl
[source/index.html]: https://github.com/opoo/opoopress-theme-wptt/blob/master/source/index.html
[source/archives/index.html]: https://github.com/opoo/opoopress-theme-wptt/blob/master/source/archives/index.html
