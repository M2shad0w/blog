title: spark中flatMap&map的区别
date: 2016-01-28 11:43:38
tags: spark
categories: scala

---

### 区别
flatMap与map是十分相似的, 但是一次使用的时候，我尽然把他们搞混了。

<!--more-->

* 相同点

	应用一个函数作用在一个RDD上的每一行, 为每一条输入返回一个对象

* 不同点

	flatMap是只是返回一个对象（相比map多了一个步骤, 将结果对象合并为一个对象）

### 实例
实例化 sc

```python
import findspark
import os
findspark.init()

import pyspark
sc = pyspark.SparkContext()
print sc
```
文件路径
`HDFS_PATH = "hdfs://localhost:9000/user/m2shad0w/flume_data/*"`

maplog

```python
faltlog = sc.textFile(HDFS_PATH).map(lambda line: line.split("\01"))
```

faltMap

```python
maplog = sc.textFile(HDFS_PATH).flatMap(lambda line: line.split("\01"))
```
显示

```python
faltlog.first()
```

`[u'id', u'2016-01-25 16:00:00', u'28800', u'0', u'User', u'1884292', u'enter_background', u'', u'2', u'1884292', u'346643', u'1', u'0', u'2016-01-25 15:43:52', u'7686852', u'']`

```python
maplog.first()
```
`u'id'`

**显示第一行，所以才只显示了id**

[CSDN参考文章](http://blog.csdn.net/samhacker/article/details/41927567)

[英文参考文章](http://www.dattamsha.com/2014/09/map-vs-flatmap-spark/)