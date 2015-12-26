title: spark分析2000千万开房数据
date: 2015-12-24 15:30:18
tags: spark 
categories: 
	- bigdata
---


### 0x00 起因
学习spark udf的功能，在网络上看到有同学拿spark分析2013年某酒店泄露出来2000千万的开房数据。
<!--more-->
### 0x01 分析数据
这个数据实在是个好样本，于是就很高兴的去找数据，打算也来分析一把。找到csv格式的数据，合起来大小800多M。
现在spark－shell中load，快速分析一下。
直接上代码：
先定义两个函数：
```scala
  def toInt(s: String):Int = {
    try {
      s.toInt
    } catch {
      case e:Exception => 9999
    }
  }
```
```scala
  def birthday2constellation(birthday: String):String = {
    var rt = "未知"
    if (birthday.length == 8) {
      val md = toInt(birthday.substring(4))
      if (md >= 120 & md <= 219)
        rt = "水瓶"
      else if (md >= 220 & md <= 320)
        rt = "双鱼"
      else if (md >= 321 & md <= 420)
        rt = "白羊"
      else if (md >= 421 & md <= 521)
        rt = "金牛"
      else if (md >= 522 & md <= 621)
        rt = "双子"
      else if (md >= 622 & md <= 722)
        rt = "巨蟹"
      else if (md >= 723 & md <= 823)
        rt = "狮子"
      else if (md >= 824 & md <= 923)
        rt = "处女"
      else if (md >= 924 & md <= 1023)
        rt = "天秤"
      else if (md >= 1024 & md <= 1122)
        rt = "天蝎"
      else if (md >= 1123 & md <= 1222)
        rt = "射手"
      else if ((md >= 1223 & md <= 1231) | (md > 101 & md <= 119))
        rt = "摩蝎"
      else
        rt = "未知"
    }
    return rt
  }
  ```

```scala
scala :paste
  import org.apache.spark.sql.{DataFrame, SQLContext}
  val sqlContext: SQLContext = new SQLContext(sc)
  // 导入语句，可以隐式地将RDD转化成DataFrame
  import sqlContext.implicits._
  case class Customer(name: String, gender: String, ctfId: String, birthday: String, address: String)
  val customer = sc.textFile("/Users/m2shad0w/Desktop/hotel/*.csv").map(_.split(",")).filter(line => line.length > 7).map(p => Customer(p(0), p(5), p(4), p(6), p(7))).toDF()
  customer.registerTempTable("customer")
  sqlContext.udf.register("constellation",  (x:String) => birthday2constellation(x))
  val result: DataFrame = sqlContext.sql("SELECT constellation(birthday), count(constellation(birthday)) FROM customer group by constellation(birthday) order by count(constellation(birthday)) desc")
  result.collect().foreach(println)
```
### 0x02 返回结果
我的机子给spark配置是2G的内存，cpu是4核的，跑起来内存最高才到1G,cpu 飙到350左右，优化的已经非常不错了。不一会儿得出结果
```sh
[天秤,1897448]
[天蝎,1820476]
[处女,1666768]
[水瓶,1636082]
[射手,1615659]
[狮子,1614264]
[双鱼,1510535]
[巨蟹,1498724]
[摩蝎,1441084]
[白羊,1410461]
[金牛,1406846]
[双子,1406631]
[未知,1126396]
```
### 0x03 总结 
scala 版本需要与spark编译的版本一致，spark1.5.2是用scala 2.10.5编译的。
定义class的时候需要放到object内，main function外，否者无法隐式转换到DataFrame。
数据需要过滤掉1月1日脏数据。