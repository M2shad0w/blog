layout: post
title: mysql导入之行sql语句
date: 2016-06-21 20:14:57
tags: mysql
categories: mysql
---

### mysql导入之行sql

一些常用的sql，写成文件形式，在mysql中导入，可以批量生成表

<!--more-->
在迁移Azkaban的时候，就有这个过程。 做一下简单的记录。

`Mysql>source 【sql脚本文件的路径全名】`

`Mysql>\. 【sql脚本文件的路径全名】`