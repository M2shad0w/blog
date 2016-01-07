title: spark SQL操作之关系型数据库
date: 2015-12-28 19:35:13
tags: spark
categories: 
	- bigdata
---


###  **0x00 DataFrame**

> Spark SQL是Spark的一个组件，用于结构化数据的计算。Spark SQL提供了一个称为DataFrames的编程抽象，DataFrames可以充当分布式SQL查询引擎。
<!--more-->

###  **0x01 如何连mysql**
查看官方文档看到:   
> Spark SQL also includes a data source that can read data from other databases using JDBC.To get started you will need to include the JDBC driver for you particular database on the spark classpath. 

可以通过jdbc来连关系型数据库，但是需要在spark 的classpath中添加jdbc的驱动路径。
比如postgresql: 

```shell
SPARK_CLASSPATH=postgresql-9.3-1102-jdbc41.jar bin/spark-shell
```

我们在mysql官网找到jdbc驱动[mysql jdbc驱动快速连接](https://dev.mysql.com/downloads/connector/j/)下载到本地, 然后在**spark-env.sh**中添加驱动路径，比如:

```shell
SPARK_CLASSPATH=/Users/m2shad0w/Downloads/mysql-connector-java-5.1.38/mysql-connector-java-5.1.38-bin.jar
```
### **0x02 编程实例**

* 代码
```scala
import java.util._
import org.apache.spark.{SparkContext,SparkConf}
import org.apache.spark.sql.{DataFrame, SQLContext}
object Spark2mysql {
  def main (args: Array[String]) {
    val conf = new SparkConf().setAppName("Spark2mysql")
    val sc = new SparkContext(conf)
    val url = "jdbc:mysql://localhost:3306/test"
    val prop = new Properties()
    prop.setProperty("user", "root")
    prop.setProperty("password", "")
    val sqlContext: SQLContext = new SQLContext(sc)
    val m1: DataFrame = sqlContext.read.jdbc(url, "gender_count", prop)
    val m2: DataFrame = sqlContext.read.jdbc(url, "person", prop)
    m1.printSchema()
    m2.printSchema()
  }
 }
```

* 返回
```shell
root
 |-- gender: string (nullable = true)
 |-- count: long (nullable = false)
 |-- count_start_time: timestamp (nullable = false)
root
 |-- person_id: integer (nullable = false)
 |-- first_name: string (nullable = true)
 |-- last_name: string (nullable = true)
 |-- gender: string (nullable = true)
 |-- age: integer (nullable = true)
```

### **0x03 写到数据库**

查看官方网站, DataFrame 提供了 write.jdbc和write.insertInto的接口

```scala
def write: DataFrameWriter
Interface for saving the content of the DataFrame out into external storage.
Annotations
@Experimental()
Since
1.4.0
```

```scala
def jdbc(url: String, table: String, connectionProperties: Properties): Unit
Saves the content of the DataFrame to a external database table via JDBC. In the case the table already exists in the external database, behavior of this function depends on the save mode, specified by the mode function (default to throwing an exception).
Don't create too many partitions in parallel on a large cluster; otherwise Spark might crash your external database systems.
url
JDBC database url of the form jdbc:subprotocol:subname
table
Name of the table in the external database.
connectionProperties
JDBC database connection arguments, a list of arbitrary string tag/value. Normally at least a "user" and "password" property should be included.
```
### **04 总结**

但是感觉接口还是古板了一点。
在spark issue上看到未来 spark jdbc 会支持行插入
[Spark JDBC requires support for column-name-free INSERT syntax](https://issues.apache.org/jira/browse/SPARK-12010)
