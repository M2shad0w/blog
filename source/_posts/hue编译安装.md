layout: post
title: hue编译安装
date: 2016-06-03 18:02:46
tags: hue
categories: 
	- bigdata
	- tools
---

### 安装依赖

yum 安装依赖

```
yum install gmp-devel
yum install libffi-devel
yum install krb5-devel cyrus-sasl-gssapi cyrus-sasl-deve libxml2-devel libxslt-devel mysql mysql-devel openldap-devel python-devel python-simplejson sqlite-devel
```
<!--more-->

```
yum list <xxx> # yum list gmp-devel 查看具体包名
```

### 参考
[http://my.oschina.net/wangjiankui/blog/465827](http://my.oschina.net/wangjiankui/blog/465827)
[http://cloudera.github.io/hue/docs-3.8.0/manual.html](http://cloudera.github.io/hue/docs-3.8.0/manual.html)