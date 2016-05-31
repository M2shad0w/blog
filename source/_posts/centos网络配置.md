layout: post
title: centos网络配置
date: 2016-05-31 15:45:23
tags: bigdata
categories: network
---

### centos-dvd-iso

安装了centos－dvd－iso镜像版本，默认boot up的时候竟然网卡没有驱动起来。配置的过程做一下纪录。

<!--more-->

### 配置sysconfig

在`/etc/sysconfig/network-scripts` 修改 `ifcfg-enp3s0`文件

ifcfg后缀名就是网卡的名
可以通过`ip add`获取

### 图形化配置

`nmtui edit 网卡名`

依次填写好

ip、网关、dns 等

如图
![](http://ww4.sinaimg.cn/large/63fe561egw1f4emdhg7r4j20s80pyade.jpg)

### 重启网络服务生效

`service network restart`

或者

`systemctl restart network.service`

安装一些网络工具

`yum update && yum install net-tools`

