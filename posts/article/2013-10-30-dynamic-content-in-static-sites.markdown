---
layout: post
title: 静态网站中的动态内容
date: '2013-10-30 19:59'
comments: true
published: true
description: "静态（主要指静态 HTML）网站同样可以做得很动态。随着第三方平台越来越多越来越完善，可以集成到静态网站中的动态功能也越来越多。这里就讲讲几种常见的动态功能。"
categories: [website]
tags: [Disqus, duoshuo, Google Analytics, social-sharing]
url: '/dynamic-content-in-static-sites/'
---
静态（主要指静态 HTML）网站同样可以做得很动态。随着第三方平台越来越多越来越完善，可以集成到静态网站中的动态功能也越来越多。这里就讲讲几种常见的动态功能。
<!--more-->

静态网站的动态内容大多由脚本（JavaScript）完成，当然也可以使用 Flash 或其它控件。
需要数据存取的功能基本上要调用到第三方平台，无数据操作的功能则可以通过本地脚本实现。

## 借助第三方平台实现的动态内容
如本文开头所说的，目前的第三方平台大多开放了 API 接口，只要其 API 接口能在 JavaScript 中调用，理论上将都可以将其功能集成到静态网站或者博客中。如 OpooPress 涉及的 Twitter, Google Plus One, Disqus 评论, Pinboard, Delicious, Google 分析, GitHub 仓库组件等，还有很多第三方平台，用户可以根据
需要进行集成。

### 评论
Disqus，多说属于此类。

国外比较著名的是 Disqus，相对功能比较完善，比较成熟。但是笔者发现在 HTTPS 下有个小 BUG，反馈过去 N 天回了邮件，但到目前也没解决，比较迟钝啊。

国内也有比较多类似的产品，比如 友言、评论啦、贝米、多说 等等。据说其中 多说 还做得不错，但是否支持 HTTPS 不大清楚。

### 统计

比如 Google Analytics、百度统计，其实还有很多统计工具，功能都差不多，细节各异，按个人喜欢选择吧。

### 分享
Twitter, Google Plus One, Facebook 等社会化分享工具栏。

### 作者（网站）相关
Pinboard, Delicious, GitHub 仓库等用于显示当前作者（或者当前网站）相关的应用。


## 本地实现的动态内容

这个完全看开发能力，通过 JavaScript 完全可以使得静态网站显得很动态。

比如当前站点使用的分页工具栏，在文章列表小于 10 页时，使用了无翻页式动态加载（AJAX），点击“更多”按钮时，通过 jQuery 将下一页的内容加载并
直接串在当前文章列表后面。大于 10 页会显示另外一种工具栏，目前还没有出现（唉，文章太少）。

突然想起有人问起能实现**随机阅读**吗，笔者这里就给个肯定的回答——能！

随机阅读功能并不难实现，一个 JavaScript 足以。

大致思路是通过模板将文章列表输出到 JavaScript 文件中，再通过方法随机取列表中 N 条显示出来即可。还可以配以刷新按钮，点击时重新随机选取。
```js
	window.sitePostList = [
		{url:'/post-01/', title:'Hello World1', date:'2013-10-30'},
		{url:'/post-02/', title:'Hello World1', date:'2013-10-30'},
		//...
		{url:'/post-99/', title:'Hello World99', date:'2013-10-30'}
	];

	window.loadRandomReadingPosts = function(postList, randomPostCount, containerId){
		var containsIndex = function(indexList, index){
			for(var i = 0 ; i < indexList.length ; i++){
				if(index == indexList[i]) return true;
			}
			return false;
		};

		var indexList = new Array();
		while(indexList.length < randomPostCount){
			var s = Math.random() * postList.length;
			var i = parseInt(s);
			if(!containsIndex(indexList, i)){
				indexList.push(i);
			}
		}

		var str = "<ul>";
		for(var i = 0 ; i < indexList.length ; i++){
			var post = postList[indexList[i]];
			str += "<li><a href='" + post.url + "'>" 
				+ post.title + "</a> (" + post.date + ")</li>";
		}
		str += "</ul>";

		document.getElementById(containerId).innerHTML = str;
	}
```
在 HTML 页面中要显示随机阅读项的位置定义 `<div id="randomReadingContainer"></div>`，然后在 HTML 页面底部和刷新按钮中
调用方法 `window.loadRandomReadingPosts(window.sitePostList, 5, 'randomReadingContainer')` 即可。


**Update 2013-10-04**

目前博客增加了 [标签筛选](/filter/) 功能，可通过多个标签来定位特定类型的文章。
