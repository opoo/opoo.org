---
layout: post
title: Oracle Coherence 缓存总是返回新的对象实例
date: '2014-03-17 12:50'
comments: true
published: true
description: 
excerpt: 
categories: [tech.java]
tags: [Oracle Coherence]
url: '/oracle-coherence-cache-always-retrieve-new-object/'
snapshot: /wp-content/uploads/2014/oracle-coherence.png
---

近日在解决一个业务问题的时候，突然发现使用 Oracle Coherence 时，调用 `NamedCache` 的 `get()` 方法总是返回新的对象实例。
<!--more-->

示例

```java
package org.opoo.cache.coherence;

import java.io.Serializable;
import com.tangosol.net.CacheFactory;
import com.tangosol.net.NamedCache;

public class NamedCacheSample {
	public static void main(String[] args) {
		NamedCache cache = CacheFactory.getCache("sample");
		
		Object data = new SampleData();
		cache.put("1000", data);

		System.out.println(data);
		System.out.println(cache.get("1000"));
		System.out.println(cache.get("1000"));
		System.out.println(cache.get("1000"));
	}
	
	public static class SampleData implements Serializable{
		private static final long serialVersionUID = 3353238636748170244L;
	}
}
```

运行结果
```text
2014-03-17 12:40:12.998/0.234 Oracle Coherence 3.6.1.0 <Info> (thread=main, member=n/a): Loaded operational configuration from "jar:file:/D:/m2.repo/oracle-coherence/coherence/3.6.1.0-b19636/coherence-3.6.1.0-b19636.jar!/tangosol-coherence.xml"
2014-03-17 12:40:13.014/0.250 Oracle Coherence 3.6.1.0 <Info> (thread=main, member=n/a): Loaded operational overrides from "jar:file:/D:/m2.repo/oracle-coherence/coherence/3.6.1.0-b19636/coherence-3.6.1.0-b19636.jar!/tangosol-coherence-override-dev.xml"

Oracle Coherence Version 3.6.1.0 Build 19636
 Grid Edition: Development mode
Copyright (c) 2000, 2010, Oracle and/or its affiliates. All rights reserved.

org.opoo.cache.coherence.NamedCacheSample$SampleData@1eec35
org.opoo.cache.coherence.NamedCacheSample$SampleData@77ef83
org.opoo.cache.coherence.NamedCacheSample$SampleData@1cb52ae
org.opoo.cache.coherence.NamedCacheSample$SampleData@26d607

```

可见，缓存的对象和每次获取的对象实例都是不同的。

## 原因
对象在 Coherence 中进行缓存时，会调用对象序列化（serialize）。在从缓存中读出时会调用反序列化（deserialize），每次调用反序列化都会创建一个新的对象实例。

所以，如果要反序列化单态类的对象实例，就需要实现 `readResolve` 方法来对返回实例进行替换。


## 错误的用法

基于 Coherence 上面所述的特点，下面的代码展示了一种错误的用法。

```java
package org.opoo.cache.coherence;

import java.io.Serializable;
import com.tangosol.net.CacheFactory;
import com.tangosol.net.NamedCache;

public class NamedCacheSample2 {
	public static class SampleData implements Serializable{
		private static final long serialVersionUID = 3353238636748170244L;
		public int status;
		public String toString(){return super.toString() + "[status=" + status + "]";}
	}
	
	public static String KEY = "1000";
	public static String CACHE_NAME = "sample";
	public static void main(String[] args){
		NamedCache cache = CacheFactory.getCache(CACHE_NAME);
		SampleData data = new SampleData();
		cache.put(KEY, data);

		m1(cache);
	}
	
	public static void m1(NamedCache cache){
		SampleData data1 = (SampleData) cache.get(KEY);
		m2(cache);
		
		if(data1.status > 0){
			System.out.println("执行业务逻辑");
		}else{
			String string = String.format("业务逻辑未执行\n%s\n%s", data1, cache.get(KEY));
			System.out.println(string);
		}
	}
	
	public static void m2(NamedCache cache){
		SampleData data2 = (SampleData) cache.get(KEY);
		data2.status = 10;
		//持久化对象
		//saveToDatabase(data2);
		cache.put(KEY, data2);
	}
}
```
运行结果
```text
业务代码未执行
org.opoo.cache.coherence.NamedCacheSample2$SampleData@15575e0[status=0]
org.opoo.cache.coherence.NamedCacheSample2$SampleData@1addb59[status=10]
```

