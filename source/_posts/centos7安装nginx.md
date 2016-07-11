layout: post
title: centos7安装nginx
date: 2016-07-11 15:21:19
tags: centos
categories: nginx
---

### centos7安装nginx

* 在yum的仓库中添加nginx的源

	`cd /etc/yum.repos.d/`
	`vi nginx.repo`

	```
	[nginx]
	name=nginx repo
	baseurl=http://nginx.org/packages/centos/7/$basearch/
	gpgcheck=1
	enabled=1
	```
<!--more-->

* 添加签名

	```
	http://nginx.org/keys/nginx_signing.key
	```

* 安装

	```
	yum install nginx -y
	```
* 启动

	```
	systemctl start nginx
	```
* 使能开机启动

	```
	systemctl enable nginx.service
	```

### 参考文章
[美团－在CentOS 7上搭建LNMP环境](https://mos.meituan.com/library/18/how-to-install-lnmp-on-centos7/)