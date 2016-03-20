layout: post
title: utf8mb4OnRds
date: 2016-03-16 18:23:09
tags: mysql 
categories:
  - bigdata
---

### 数据存入rds

记一次RDS上的坑，spark分析完的数据最后要存在RDS 上，遇到字段中有些表情😊，mysql 报错无法存储。

<!--more-->

### err

```shell
java.sql.SQLException: Incorrect string value: '\xF0\x9F\x8E\x89\xF0\x9F...' for column
```

### 设置字符集为 utf8mb4

`mysql> show variables like '%char%';`


![](http://ww3.sinaimg.cn/mw690/63fe561egw1f23k82w2tbj20k40f641x.jpg)


![](http://ww2.sinaimg.cn/mw690/63fe561egw1f23k8k1m52j213002at97.jpg)

** 客户端上设置字符集为utf8mb4 重连不生效 需要在rds 控制台设置 **

### 参考

[http://stackoverflow.com/questions/10957238/incorrect-string-value-when-trying-to-insert-utf-8-into-mysql-via-jdbc](http://stackoverflow.com/questions/10957238/incorrect-string-value-when-trying-to-insert-utf-8-into-mysql-via-jdbc)

[https://help.aliyun.com/knowledge_detail/5990076.html](https://help.aliyun.com/knowledge_detail/5990076.html)