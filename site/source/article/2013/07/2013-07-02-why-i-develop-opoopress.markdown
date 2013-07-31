---
layout: post
title: "为什么开发 OpooPress"
date: '2013-07-02 17:23'
comments: true
published: true
keywords: "OpooPress, OpooPress vs Octopress"
description: "关于 OpooPress 的一些比较好的特性简单介绍。并与 Octopress 的生成速度进行简单对比。"
url: /why-i-develop-opoopress/
categories: ['others']
tags: ['opoopress']
---

静态网站/博客生成器（static site/blog generator）的产品已有不少，各种语言各种框架的都有，其中不乏优秀的产品，为什么还要开发一个自己的生成器呢？

简单说来，主要是基于笔者个人对**开发语言**的选择和**生成速度**的考虑。

<!--more-->

## 一、Java 还是其它

之前在使用 Octopress 的过程中，需要定制化界面时，就不得不去熟悉 Ruby 和 Liquid，虽然语法并不难，但进行大的改动时总觉得不是那么得心应手，于是产生了写一个 Java 版的静态网站/博客生成器的想法。

这不是说 Ruby 不好，事实上，Ruby 绝对是一个优秀的编程语言。事实上，同样的业务逻辑，用 Java 实现比 Ruby 要多写不少代码。

之所以选用 Java，完全是因为笔者对 Java 更为熟悉。

个人觉得，安装 Java 运行环境相对 [在 Windows 下安装配置 Octopress](/octopress/)，还是会简单很多。

还有许多其它语言版本的生成器，笔者没有一一试用，不好妄自评论，可[参考这里](https://iwantmyname.com/blog/2011/02/list-static-website-generators.html)。

## 二、生成速度（Generate Speed）

OpooPress 生成的速度很快——这绝对是其亮点之一。

以下是包含有 1000 篇文章的博客的生成过程截图：

![OpooPress Generating Snapshot](//www.opoo.org/wp-content/uploads/2013/07/opoopress-generating-snapshot.png)

也就是说生成 1000 篇文章大约在 5 秒多时间内就完成了。复制这 1000 篇文章到 Octopress，生成时间则要一分钟左右。这个差距还是比较明显的。

运行环境大致情况：ThinkPad T400, 2G RAM, Sun JDK 1.6, Ruby 1.9.2.

用于测试的 1000 篇文章是机器随机生成的，生成规则：每文 5 至 70 个段落，每段落 3 至 15 个句子，每个句子 10 到 30 个汉字。

详见以下 Java 代码：

```java
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.security.SecureRandom;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import org.apache.commons.io.IOUtils;

public class GeneratePosts {
	
	private static SecureRandom random = new SecureRandom();
	private static SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	private static SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
	private static final String EXCERPT_SEPARATOR = "<!--more--" + ">";
	
	//每句最少字数，最大字数
	private int sentenceMinWords = 10;
	private int sentenceMaxWords = 30;
	//每段最少，最大句子数
	private int paragraphMinSentences = 3;
	private int paragraphMaxSentences = 15;
	//内容最少，最大段落数
	private int contentMinParagraphs = 5;
	private int contentMaxParagraphs = 70;
	
	private int categoryNum = 10;
	
	public static void main(String[] args) throws IOException {
		File dir = new File(".");
		
		GeneratePosts generatePosts = new GeneratePosts();
		//generatePosts.generatePost(new File(dir, new Date(), 100);
		Calendar cal = Calendar.getInstance();
		for(int i = 0; i < 1000 ; i++){
			Date date = cal.getTime();
			cal.add(Calendar.DAY_OF_MONTH, -1);
			//System.out.println(date);
			generatePosts.generatePost(dir, date, 1001 + i);
		}
	}

	public String generateWord() {
		try {
			int hightPos = (176 + Math.abs(random.nextInt(39)));// 获取高位值
			int lowPos = (161 + Math.abs(random.nextInt(93)));// 获取低位值
			byte[] b = new byte[2];
			b[0] = (new Integer(hightPos).byteValue());
			b[1] = (new Integer(lowPos).byteValue());
			return new String(b, "GBK");// 转成中文
		} catch (UnsupportedEncodingException e) {
			System.err.println(e);
			return "";
		}
	}
	
	public String generateSentence(int sentenceMinWords, int sentenceMaxWords){
		StringBuffer sb = new StringBuffer();
		int len = sentenceMinWords + random.nextInt(sentenceMaxWords - sentenceMinWords);
		for(int i = 0 ; i < len ; i++){
			sb.append(generateWord());
		}
		return sb.toString();
	}
	
	public String generateParagraph(){
		StringBuffer sb = new StringBuffer();
		int len = paragraphMinSentences + random.nextInt(paragraphMaxSentences - paragraphMinSentences);
		for(int i = 0 ; i < len ; i++){
			sb.append(generateSentence(sentenceMinWords, sentenceMaxWords));
			sb.append("。");
		}
		return sb.toString();
	}
	
	public void generateContent(PrintWriter w){
		int len = contentMinParagraphs + random.nextInt(contentMaxParagraphs - contentMinParagraphs);
		for(int i = 0 ; i < len ; i++){
			w.println(generateParagraph());
			if( i == 0 ){
				w.println(EXCERPT_SEPARATOR);
			}
			w.println();
		}
	}
	
	public void generatePost(File dir, Date date, int index) throws IOException{
		String title = generateSentence(5, 12);
		String category = "Category" + random.nextInt(categoryNum);
		
		String filename = format.format(date) + "-the-" + index + ".markdown";
		File file = new File(dir, filename);
		
		FileOutputStream stream = null;
		OutputStreamWriter writer = null;
		PrintWriter pw = null;
		try {
			stream = new FileOutputStream(file);
			writer = new OutputStreamWriter(stream, "UTF-8");
			pw = new PrintWriter(writer);
			
			pw.println("---");
			pw.println("layout: post");
			pw.println("title: \"" + title + "\"");
			pw.println("date: " + dateFormat.format(date));
			pw.println("comments: true");
			pw.println("categories: [" + category + "]");
			pw.println("---");
			
			generateContent(pw);
			
			System.out.println("File generated: " + file);
		} catch (IOException e) {
			throw e;
		}finally{
			IOUtils.closeQuietly(pw);
			IOUtils.closeQuietly(writer);
			IOUtils.closeQuietly(stream);
		}
	}
}
```

PS: 文中揭示了 OpooPress 的另外一个特性，那就是 OpooPress 文章的格式和 Octopress 是一致的，如果需要迁移，直接复制过来即可。


