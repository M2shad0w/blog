title: how_to_use_spark_00
date: 2015-12-21 10:04:35
tags: spark
categories: bigdata
 
---

# 基本安装
## 简介
Apache Spark 是一个快速、通用的计算机集群系统。它提供高度优化 Java, Scala, Python and R 的高级接口来支持一般的执行流程，同时支持丰富的高层及的工具集合，包括 [Spark SQL](#)来处理关系型数据，[MLlib](#)来处理机器学习，[GraphX](#)来处理图运算，[Spark Streaming](#)
<!-- more -->
## 系统要求
> Spark runs on Java 7+, Python 2.6+ and R 3.1+. For the Scala API, Spark 1.5.2 uses Scala 2.10. You will need to use a compatible Scala version (2.10.x).

### mac上安装
**mac 上用brew命令行安装spark**

```sh
brew install apache-spark
```

**查看spark版本**

```sh
brew info apache-spark
apache-spark: stable 1.5.2, HEAD
Engine for large-scale data processing
https://spark.apache.org/
/usr/local/Cellar/apache-spark/1.5.2 (686 files, 305M) *
  Built from source
From: https://github.com/Homebrew/homebrew/blob/master/Library/Formula/apache-spark.rb
```

**安装java**

```sh
brew cask install java
```

**查看java版本**

```sh
brew cask info java or java -version
```
```sh
java -version
java version "1.8.0_66"
Java(TM) SE Runtime Environment (build 1.8.0_66-b17)
Java HotSpot(TM) 64-Bit Server VM (build 25.66-b17, mixed mode)
```

**安装scala**

```sh
 brew install scala
```

**查看scala版本**

```sh
brew info scala
```

**info**
回显信息中比较重要的是用idea开发的scala的时候，scala路径设置成
> To use with IntelliJ, set the Scala home to:
> /usr/local/opt/scala/idea

spark 1.5.2 使用（scala2.10.x）编译的。

**经实践,scala版本设置需要2.10.5, 以免带来奇怪的问题**

## Running the Examples and Shell

这样安装的spark自带一些例子， Scala, Java, Python and R 的例子在 examples/src/main目录，可以在安装的spark根目录使用命令 bin/run-example <class> [params] 跑一些例子，例如计算Pi

```sh
./bin/run-example SparkPi 100
```

可以直接在控制台中敲入spark-shell，开始spark之旅了。