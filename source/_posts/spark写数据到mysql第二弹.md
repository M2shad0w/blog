title: spark写数据到mysql第二弹
date: 2016-01-25 10:08:23
tags: spark
categories:
	- mysql
---

### 需求
分析的中间数据, 很多需要持久化到关系型数据库, 以便后续的二次分析, 在官方给出insert指定字段的接口之前我先实现自己的方法吧。

<!--more-->

### 背景
* 之前有一篇文章[spark SQL操作之关系型数据库](http://m2shad0w.com/2015/12/28/spark002/)简单讲解了spark 写mysql的接口。

* 逐行指定字段写入数据库, 我们必须能拿到每一行数据。在spark SQL 操作完的对象是一个 RDD, [spark SQL scala api说明](http://spark.apache.org/docs/latest/api/scala/index.html#org.apache.spark.rdd.RDD) 上有一个api:
	```scala
	def foreachPartition(f: (Iterator[T]) ⇒ Unit):Unit
	// Applies a function f to each partition of this RDD.```

因此我们只需要实现一个参数是`Iterator`类型的函数, 就能取出每一行的数据。

### 代码实现实例
1. 闭包

	```scala
	val keyWords = sqlContext.sql("your sql ")
	// scala 闭包, 传参数
	def keyWordsr2mysql(iter: Iterator[org.apache.spark.sql.Row]): Unit = {
	      val keyTags = Array("count_start_time", "kind")
	      val tags = Array("word", "count")
	      write2mysql(iter, "keyWordCount", keyTags, tags, sStartTime, kind)
	      
	    }
	```

2. 抽象写数据库
	
	将数据库表名, 指定字段等以参数形式传入, 接口更抽象通用
	```
	def write2mysql(iter :Iterator[org.apache.spark.sql.Row], sTable: String, keytags :Array[String], tags :Array[String], args:Any*): Unit = {
	// your code
	}
	```
