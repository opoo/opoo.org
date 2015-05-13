---
layout: post
title: '在 CentOS 下安装 TeamForge 7.1'
date: '2014-05-31 11:30'
comments: true
published: true
description: '本文简单介绍在 CentOS 上安装 TeamForge 7.1 的过程及其应该注意的事项。'
excerpt: '本文简单介绍在 CentOS 上安装 TeamForge 7.1 的过程及其应该注意的事项。'
categories: ["software"]
tags: ["TeamForge", "CentOS"]
url: '/2014/install-teamforge-7.1-on-centos/'
snapshot: /wp-content/uploads/2014/tf-logo-100.jpg
---
TeamForge 是一款非常优秀的项目管理工具，最近升级到了7.1版本。可参考本站对[6.1版](/teamforge/)和[7.0版](/teamforge-7/)的简介。本文介绍如何在 CentOS 上安装 TeamForge 7.1 并提醒安装过程中应该注意的事项。

本文参考的官方文档是 [Install TeamForge 7.1 with all services on the same server](http://help.collab.net/topic/sysadmin-710/action/redhat_teamforge-install-dedicated.html)，亦即将 TeamForge 所有的服务都安装在一台服务器上。本文使用的服务器操作系统是 CentOS 6.5 32位。

## 安装步骤

1. 首先通过以下命令关闭 SELinux。
```shell
setenforce 0
```

2. 将以下内容写到文件 `collabnet-7.1.0.0.repo`，并将该文件复制到 `/etc/yum.repos.d/` 目录。
```
[CollabNet]
name=collabnet
baseurl=http://packages.collab.net/7.1.0.0/redhat/$releasever/$basearch
gpgkey=http://packages.collab.net/RPM-GPG-KEY-collabnet
enabled=1
gpgcheck=0
```
刷新 `yum` 库的缓存
```shell
yum clean all
```

1. 安装以下应用包。
    - TeamForge 主程序
    ```shell
    yum install teamforge
    ```
    - GIT 应用包
     ```shell
    yum install teamforge-git
    ```
    - Black Duck Code Sight 代码搜索应用包
     ```shell
    yum install teamforge-codesearch
    ```

1. 修改站点主配置文件。
```shell
vi /opt/collabnet/teamforge-installer/7.1.0.0/conf/site-options.conf
```
最简单的做法是将 `/opt/collabnet/teamforge-installer/7.1.0.0/conf/site-options-dedicated.conf` 改名为 `/opt/collabnet/teamforge-installer/7.1.0.0/conf/site-options.conf`，然后在改配置中添加（或修改）属性 `DOMAIN_localhost=<YOUR DOMAIN NAME>`，这里请输入你的服务器的域名，一般指定该属性后，后续安装就可以成功执行。更过配置请参看[原文档](http://help.collab.net/topic/sysadmin-710/action/redhat_teamforge-install-dedicated.html)。

1. 创建运行环境。
```shell
cd /opt/collabnet/teamforge-installer/7.1.0.0
./install.sh -r -I -V
```
该步骤很可能在启动数据库时出错
```text
CRITICAL /etc/init.d/postgresql-9.2 -t ctf start > /dev/null 2>&1 failed with exit code 1, 256 from os.system()
```
此时，需要修改 `/etc/sysctl.conf` 的参数 `kernel.shmmax=89934592`，修改后执行以下命令使其生效
```shell
sudo sysctl -p
```

1. 初始化站点数据。
```shell
./bootstrap-data.sh
```
该步骤可能会出错
```text
INFO Run script /opt/collabnet/teamforge/dist/hook-scripts/bootstrap-data/51-create-postgresql-database.py
CRITICAL createdb -E UNICODE -O ctfuser -U ctfuser ctfdb failed with exit code 1, 256 from os.system()
```
修改文件 `/opt/collabnet/teamforge/dist/hook-scripts/bootstrap-data/51-create-postgresql-database.py`，找到其中**两**处 `createdb` 命令，在后面都加上 `--template=template0` 即可解决这个问题。

1. 现在，可以启动 TeamForge 了。
```shell
/etc/init.d/collabnet start
```

## 其它
此时，你就拥有了一个能够免费试用30天的功能强大的 TeamForge。

如果你有充足的理由，在30天后坚持要继续使用的话：
1. 请购买正版。
1. 或者，请留意 `saturn_common.jar` 文件，有问题可与我联系。
