---
layout: post
title: 'Java 遍历文件夹的几种方式及简单性能对比'
date: '2014-05-24 14:38'
comments: true
published: true
description: '本文简单介绍使用 Java 遍历指定目录下所有文件的几种方式，并简单对比其运行速度。'
excerpt: '本文简单介绍使用 Java 遍历指定目录下所有文件的几种方式，并简单对比其运行速度。'
categories: [java]
tags: [遍历文件夹]
url: '/2014/walking-the-file-tree/'
snapshot: /wp-content/uploads/2014/cropped-w125-h125.png
---
在 Java 中，要遍历一个文件夹下的所有文件（包括子文件夹），有以下几种方式（或者叫工具）。

### File.listFiles() 方法

通过 JDK 的 `java.io.File` 类的 `listFiles()` 方法，自己写代码,通过递归遍历目录及子目录的文件：
```java
	static Collection<File> listFiles(File root){
		List<File> files = new ArrayList<File>();
		listFiles(files, root);
		return files;
	}
	
	static void listFiles(List<File> files, File dir){
		File[] listFiles = dir.listFiles();
		for(File f: listFiles){
			if(f.isFile()){
				files.add(f);
			}else if(f.isDirectory()){
				listFiles(files, f);
			}
		}
	}
```

### Plexus Utils 工具包
```java
List<File> list = org.codehaus.plexus.util.FileUtils.getFiles(dir, null, null);
```

### Google Guava 工具包
```java
	Files.fileTreeTraverser().breadthFirstTraversal(dir).filter(new Predicate<File>(){
		public boolean apply(File input) {
			return input.isFile();
		}
	});
```

### Commons IO 工具包
```java
Collection<File> files = org.apache.commons.io.FileUtils.listFiles(dir, null, true);
```

### Java 7 NIO.2
```java
	final List<File> files = new ArrayList<File>();
	SimpleFileVisitor<Path> finder = new SimpleFileVisitor<Path>(){
		@Override
		public FileVisitResult visitFile(Path file, BasicFileAttributes attrs) throws IOException {
			files.add(file.toFile());
			return super.visitFile(file, attrs);
		}
	};

	java.nio.file.Files.walkFileTree(path, finder);
```


经过运行时间对比，Java 7 NIO.2 方式遍历文件是最快的，其次是通过 `java.io.File` 的 `listFiles()` 方法。

其实这个结果也是预料中的：
1. Java 7 肯定有性能上的改进，NIO.2 的性能应该好于之前的 IO 处理类
1. listFiles 是 Java 6 及之前版本中的自带的方法，其它工具包应该都是在这个方法的基础上封装的，比该方法运行慢也是合理的


## 附录
1. 本文完整代码下载：[file-walk-test.zip](/wp-content/uploads/2014/file-walk-test.zip).
   ```
   mvn compile
   mvn exec:java
   ```
   运行结果如下：
   ![File walk test output](/wp-content/uploads/2014/file-walk-test-output.png)
1. 相关知识参考官方文档: [Walking the File Tree](http://docs.oracle.com/javase/tutorial/essential/io/walk.html)