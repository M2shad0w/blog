layout: post
title: rinetd端口转发工具
date: 2016-07-13 17:04:50
tags: rinetd
categories: bigdata

---

### rinetd端口转发工具

端口转发是比较实用的，内网服务器，某些机器并不想直接暴露在外边，就可以通过端口转发到跳板机上。

<!--more-->

从[工具地址](https://www.boutell.com/rinetd/) 下载

`wget $url`

解压压缩包，并且进入工作目录，修改端口范围

`sed -i 's/65536/65535/g' rinetd.c`

接着执行

`mkdir /usr/man&&make&&make install`

### 创建配置文件

`vi /etc/rinetd.conf`

输入

`$src $port $des $port`

启动

`rinetd`

### 开机启动

`echo rinetd >>/etc/rc.local`

