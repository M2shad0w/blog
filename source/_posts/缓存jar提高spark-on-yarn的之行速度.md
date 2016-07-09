layout: post
title: 缓存jar提高spark-on-yarn的之行速度
date: 2016-07-09 15:44:23
tags: bigdata
categories:
  - spark
---

### spark-on-yarn

将job提交到 `yarn` 上，整个job的执行时间明显多了很多，想着优化一下。

从下面这张图可以看到，有一个上传`spark jar`的过程，这个包很大170多M，必然会浪费时间。

所以通过缓存jar来提高`spark on yarn`的执行速度。

<!--more-->


![上传jar记录](http://ww1.sinaimg.cn/large/63fe561egw1f5nptf0dsbj21kw037419.jpg)

### 缓存过程

* 在hdfs上创建公共jar包的一个路径

	```bash
	hadoop fs -mkdir /spark-lib
	hadoop fs -chmod 755 /spark-lib # 修改目录权限
	```
* 将jar包put到新建的路径中去

	```bash
	hadoop fs -put $yourpath
	```
* 在spark-default.conf中设置spark.yarn.jar指定到 hdfs中spark-assembly包的绝对路径

	```bash
	spark.yarn.jar $yourpath
	```
### 参考文章

[http://blog.csdn.net/xueba207/article/details/50440625](http://blog.csdn.net/xueba207/article/details/50440625)