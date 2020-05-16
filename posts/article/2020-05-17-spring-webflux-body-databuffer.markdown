---
layout: post
title: Spring WebFlux 多次读取 DataBuffer 类型的请求内容
date: '2020-05-17 13:29'
comments: true
published: true
description: "本文记录多次读取 Spring WebFlux 的请求内容（body）的方法，通常在 Spring WebFlux 的 WebFilter 使用，操作数据类型是 DataBuffer。"
excerpt: "本文记录多次读取 Spring WebFlux 的请求内容（body）的方法，通常在 Spring WebFlux 的 WebFilter 使用，操作数据类型是 DataBuffer。"
categories: [Java]
tags: [Spring, WebFlux, DataBuffer]
url: '/2020/spring-webflux-body-databuffer/'
snapshot: '/wp-content/uploads/2014/cropped-w125-h125.png'
---

## 方法一：基于内存缓存 —— 构造新的 DataBuffer 对象
```java

    @Override
	public Mono<Void> filter(ServerWebExchange exchange, WebFilterChain chain) {
        final ServerHttpRequest request = exchange.getRequest(); 
        long contentLength = request.getHeaders().getContentLength();

        if (contentLength <= 0) {
            return chain.filter(exchange);
        }

        return DataBufferUtils.join(request.getBody()).map(dataBuffer -> {
            exchange.getAttributes().put("cachedRequestBody", dataBuffer);

            ServerHttpRequest decorator = new ServerHttpRequestDecorator(request) {
                @Override
                public Flux<DataBuffer> getBody() {
                    return Mono.<DataBuffer>fromSupplier(() -> {
                        if (exchange.getAttributeOrDefault("cachedRequestBody", null) == null) {
                            // probably == downstream closed
                            return null;
                        }

                        // reset position
                        dataBuffer.readPosition(0);

                        // deal with Netty
                        NettyDataBuffer pdb = (NettyDataBuffer) dataBuffer;
                        return pdb.factory().wrap(pdb.getNativeBuffer().retainedSlice());
                    }).flux();
                }
            };

            // TODO 消费 dataBuffer，例如计算 dataBuffer 的哈希值并验证
            // ...

            return decorator
            
        })
        .switchIfEmpty(Mono.just(request))
        .flatMap(req -> chain.filter(exchange.mutate().request(req).build()))
        .doFinally(s -> {
            DataBuffer dataBuffer = exchange.getAttributeOrDefault("cachedRequestBody", null);
            if (dataBuffer != null) {
                DataBufferUtils.release(dataBuffer);
            }
        });
    }
```

## 方法二：基于内存缓存 —— byte[]
```java

    @Override
	public Mono<Void> filter(ServerWebExchange exchange, WebFilterChain chain) {
        final ServerHttpRequest request = exchange.getRequest(); 
        long contentLength = request.getHeaders().getContentLength();

        if (contentLength <= 0) {
            return chain.filter(exchange);
        }

        final ByteArrayOutputStream outputStream = new ByteArrayOutputStream();

        return Mono.create(sink -> {
             DataBufferUtils.write(request.getBody(), outputStream).subscribe(DataBufferUtils::release, sink::error, sink::success);
        })
        .then(Mono.just(request))
        .flatMap(req -> {
            log.debug("缓存大小：{}", outputStream.size());
            final ServerHttpRequestDecorator decorator = new ServerHttpRequestDecorator(req) {
                @Override
                public Flux<DataBuffer> getBody() {
                    return DataBufferUtils.read(new ByteArrayResource(outputStream.toByteArray()), exchange.getResponse().bufferFactory(), 1024 * 8);
                }
            };

            // TODO 对缓存的 ByteArrayOutputStream 进行处理，例如计算 ByteArrayOutputStream 中 byte[] 的哈希值并验证
            // ...

            return chain.filter(exchange.mutate().request(decorator).build());
        });
    }
```

## 方法三：基于文件缓存 —— Path
```java


    @Override
	public Mono<Void> filter(ServerWebExchange exchange, WebFilterChain chain) {
        final ServerHttpRequest request = exchange.getRequest(); 
        long contentLength = request.getHeaders().getContentLength();

        if (contentLength <= 0) {
            return chain.filter(exchange);
        }

        try {
            final Path tempFile = Files.createTempFile("HttpRequest", ".bin");

            return DataBufferUtils.write(request.getBody(), tempFile)
                .then(Mono.just(request))
                .flatMap(req -> {
                    final ServerHttpRequestDecorator decorator = new ServerHttpRequestDecorator(req) {
                        @Override
                        public Flux<DataBuffer> getBody() {
                            return DataBufferUtils.read(tempFile, exchange.getResponse().bufferFactory(), 1024 * 8, StandardOpenOption.READ);
                        }
                    };
                    
                    // TODO 对缓存的 tempFile 进行处理，例如计算 tempFile 的哈希值并验证
                    // ...

                    return chain.filter(exchange.mutate().request(decorator).build());
                })
                .doFinally(s -> {
                    try {
                        Files.deleteIfExists(tempFile);
                    } catch (IOException e) {
                        throw new IllegalStateException(e);
                    }
                });

        } catch (IOException e) {
            throw new IllegalStateException(e);
        }
    }
```

## 注：

在请求 body 比较大的情况的测试中，发现调用 `DataBufferUtils#join()` 方法（方法一）会占用较大的内存，并且请求完毕时可能不会立刻释放，在下一次 GC 时可释放。调用 `DataBufferUtils#write()` 方法直接写到 `OutputStream` （方法二）或者临时文件（方法三）时，则不会占用过多内存。
