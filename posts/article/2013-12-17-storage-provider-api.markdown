---
layout: post
title: 建立统一的存储接口
date: '2013-12-17 18:22'
comments: true
published: true
description: 本文主要介绍建立统一存储接口（API）的必要性，简析 Jive Binary Storage 的实现，以及如果实现自己的存储器。
categories: [java]
tags: [qiniudn, Jive EOS, cloud-storage]
url: '/storage-provider-api/'
---

大部分的软件或者网站都会有二进制数据（文件）需要存储，比如上传的附件，文中的图片等等。

这些数据可以存储在本地文件系统、远程文件系统（FTP、NFS等）、数据库、或者云服务（Dropbox、AWS S3、七牛云存储等）中。为了将存储
的实现和使用分离，通常我们需要建立一个统一的存储接口或者 API。这样，API 提供者专注于存储逻辑的实现，API 调用者则专注于其它业务
逻辑的实现，并在适当的位置调用存储接口即可。

<!--more-->

本文以 Jive Binary Storage Provider 为例介绍存储接口的范例。Jive 是非常有名的商业软件，jive-eos 是其中的一个包，存储接口
（StorageProvider）就定义在这个包内。

```java
import java.io.InputStream;
import java.nio.ByteBuffer;
import java.util.Map;

public interface StorageProvider{
    boolean put(String key, byte data);

    boolean put(String key, InputStream data);

    boolean containsKey(String key);

    ByteBuffer getBuffer(String key);

    InputStream getStream(String key);

    boolean delete(String key);

    Iterable<String> getKeys();

    String getNamespace();
}
```

调用该接口的示例

```java
ApplicationContext context = ...;
StorageProvider sp = context.getBean("storageProvider", StorageProvider.class);

//存文件
String filename = ...;
InputStream data = new FileInputStream(new File(filename));
KeyFactory keyFactory = context.getBean("keyFactory", KeyFactory.class);
String key = keyFactory.generateStorageKey();
boolean success = sp.put(key, data); 


//根据 key 获取文件的数据流
String key = ...;
InputStream data = sp.getStream(key);
//输出data


//从一个存储器迁移到另外一个存储器
//例如从本地文件系统迁移到七牛云存储
StorageProvider src = new FileStorageProvider(...);
StorageProvider dest = new QiniudnStorageProvider(...);
Set<String> keys = Sets.newHashSet(src.getKeys());
for(String key: keys){
    dest.put(key, src.getStream(key));
}
```

简单的本地文件存储实现（FileStorageProvider）（*注意，仅仅是示例，只列出代码且无优化*）

```java
public class FileStorageProvider implements StorageProvider{
    private final File rootDirectory;
    public FileStorageProvider(File rootDirectory){
        this.rootDirectory = rootDirectory;
        if(!rootDirectory.exists()){
            rootDirectory.mkdirs();
        }
    }

    public boolean put(String key, InputStream data){
        File file = new File(rootDirectory, key + ".bin");
        IOUtils.copy(data, new FileOutputStream(file));
        return true;
    }

    public boolean containsKey(String key){
        return new File(rootDirectory, key + ".bin").exists();
    }

    public InputStream getStream(String key){
        File file = new File(rootDirectory, key + ".bin");
        return new FileInputStream(file);
    }
}

```
实际上，Jive EOS 官方实现的 `FileStorageProvider` 要复杂的多，健壮的多。另外，Jive 还实现了
将数据存储到数据库的 `JdbcStorageProvider` 和存储到 AWS S3 服务的 `S3StorageProvider`，有兴趣
的读者可以搜索相关内容。

云存储是目前互联网相当热火的概念，在项目中使用云存储服务也已经成为了很多互联网应用的选择。上述
AWS S3 就是老牌的云存储服务。国内的云存储服务也不少，基本上都提供了自身的API（SDK），下面以七牛
云存储为例，简要说说如何实现一个存储器可以将二进制数据存储到七牛云，或者从七牛云获取二进制数据。

(默认使用私有空间，不完整版，仅示例)
```java
public class QiniudnStorageProvider implements StorageProvider{
    private final String ACCESS_KEY = "<YOUR APP ACCESS_KEY>";
    private final String SECRET_KEY = "<YOUR APP SECRET_KEY>"

    private Mac mac;
    private final String bucketName;
    private final String domain;
    public FileStorageProvider(String bucketName){
        this.bucketName = bucketName;
	this.domain = "http://" + bucketName + ".u.qiniudn.com";
        Config.ACCESS_KEY = ACCESS_KEY;
        Config.SECRET_KEY = SECRET_KEY;
        mac = new Mac(Config.ACCESS_KEY, Config.SECRET_KEY);
    }

    public boolean put(String key, InputStream data){
        File file = File.createTempFile();
        IOUtils.copy(data, new FileOutputStream(file));

        PutPolicy putPolicy = new PutPolicy(bucketName);
        String uptoken = putPolicy.token(mac);
        PutExtra extra = new PutExtra();
        PutRet ret = IoApi.putFile(uptoken, key, file, extra);
        return true;
    }
    
    public boolean containsKey(String key){
        String url = makeDownloadURL(key);
        HttpClient hc = new HttpClient();
        HttpMethod m = new HeadMethod(url);
        hc.executeMethod(m);
        return m.getStatusCode() == 200;
    }

    public InputStream getStream(String key){
        String url = makeDownloadURL(key);
        HttpClient hc = new HttpClient();
        HttpMethod m = new GetMethod(url);
        hc.executeMethod(m);
        if(m.getStatusCode() == 200){
            return m.getResponseBodyAsStream();
        }
        return null;
    }

    private String makeDownloadURL(String key){
        String baseUrl = URLUtils.makeBaseUrl(domain, key);
        GetPolicy getPolicy = new GetPolicy();
        return getPolicy.makeRequest(baseUrl, mac);
    }

}

```
基本原理就是这样的，如有需要，可根据 [Qiniu Java SDK 文档](http://docs.qiniu.com/java-sdk/v6/index.html)和 
[HttpClient 文档](http://hc.apache.org/httpclient-3.x/apidocs/index.html)自行实现。
