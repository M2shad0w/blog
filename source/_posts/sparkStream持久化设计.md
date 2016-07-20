layout: post
title: sparkStream持久化设计
date: 2016-07-20 19:27:21
tags: spark
categories: 
	- bigdata
---

### 数据批处理

现在有一种业务，数据需要在较短的时间内处理一下， spark Stream 是一个不错的选择。

<!--more-->

数据流基本按照官网给的图走的。

![spark stream 数据流图](http://ww2.sinaimg.cn/large/63fe561egw1f60lw5yta2j20wk0c6q50.jpg)

从`flume`收集日志，`sink`到`kafka`, `kafka`的消息被 `spark stream` 批处理消费掉。

### 批处理的数据被存到外部系统

在业务中， 外部系统是mysql， 怎么高效的存储呢？

[在spark的官网中提供了思路](https://spark.apache.org/docs/latest/streaming-programming-guide.html#design-patterns-for-using-foreachrdd)

用 `dstream.foreachRDD` 的算子， 你有可能这样写

```scala
dstream.foreachRDD(rdd => {
  val connection = createNewConnection()  // executed at the driver
  rdd.foreach(record => {
      connection.send(record) // executed at the worker
  })
})
```

但是这样写会报序列化的错误，提高系统的吞吐量，更好的办法是利用 `rdd.foreachPartition` 的方法。
为RDD的每个partition创建一个连接对象

类似如下这种方法

```scala
dstream.foreachRDD(rdd => {
      rdd.foreachPartition(partitionOfRecords => {
          val connection = createNewConnection()
          partitionOfRecords.foreach(record => connection.send(record))
          connection.close()
      })
  })
```
还有更好的方案是创建一个静态的，懒加载的连接对象，节省进一步的开销

```
dstream.foreachRDD(rdd => {
      rdd.foreachPartition(partitionOfRecords => {
          // ConnectionPool is a static, lazily initialized pool of connections
          val connection = ConnectionPool.getConnection()
          partitionOfRecords.foreach(record => connection.send(record))
          ConnectionPool.returnConnection(connection)  // return to the pool for future reuse
      })
  })
```

### 附送python实例

```python
import MySQLdb
from DBUtils.PooledDB import PooledDB

class ConnectionPool(object):
    def __init__(self):
        TRACK_HOST = $TRACK_HOST
        TRACK_USER = $TRACK_USER
        TRACK_PASSWD = $TRACK_PASSWD
        TRACK_DB = $TRACK_DB
        self.pool = PooledDB(MySQLdb, 2, host=TRACK_HOST, user=TRACK_USER, passwd=TRACK_PASSWD, db=TRACK_DB, port=3306)

    def getConnection(self):
        return self.pool.connection()

    def returnConnection(self, connection):
        return connection.close()
def main():
	balabala
	...
	counts.foreachRDD(lambda rdd: rdd.foreachPartition(send_partition))
def send_partition(data):
   	try:
	    c = ConnectionPool()
	    conn = c.getConnection()
	    cur = conn.cursor()
	    for record in data:
	    	balabala
	    	...
	    c.returnConnection(conn)
	except Exception, e:
        print (e)
if __name__ == "__main__":
    main()

```

### 参考

[https://aiyanbo.gitbooks.io/spark-programming-guide-zh-cn/content/spark-streaming/basic-concepts/output-operations-on-DStreams.html](https://aiyanbo.gitbooks.io/spark-programming-guide-zh-cn/content/spark-streaming/basic-concepts/output-operations-on-DStreams.html)
[https://spark.apache.org/docs/latest/streaming-programming-guide.html#design-patterns-for-using-foreachrdd](https://spark.apache.org/docs/latest/streaming-programming-guide.html#design-patterns-for-using-foreachrdd)
