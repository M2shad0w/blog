layout: post
title: hbase初探
date: 2017-01-09 16:28:40
tags: bigdata
categories: 
		- nosql
		- dataMining
---

### hbase

一种列式的 NoSql, 是基于 Bigtable 的开源实践

<!--more-->

**痛点**

* 实现对单个用户任意时间维度的轨迹查询
* 日志量大

rdbms 已经不适合了

### Hbase

Hbase 是一个基于列存储的非关系型数据库，适合存储非结构化的数据 [wikipedia](https://zh.wikipedia.org/wiki/Apache_HBase).

```
所用语言： Java
特点：支持数十亿行X上百万列
使用许可： Apache
协议：HTTP/REST （支持 Thrift，见编注4）
在 BigTable之后建模
采用分布式架构 Map/reduce
对实时查询进行优化
高性能 Thrift网关
通过在server端扫描及过滤实现对查询操作预判
支持 XML, Protobuf, 和binary的HTTP
Cascading, hive, and pig source and sink modules
基于 Jruby（ JIRB）的shell
对配置改变和较小的升级都会重新回滚
不会出现单点故障
堪比MySQL的随机访问性能
```

### 什么时候需要 Hbase

* 数据结构字段不确定，很难按一个概念抽取数据，业务发展过程中增加存储时需要 `rdbms` 停机维护，hbase 支持动态增加
* 记录稀疏，`rdbms` 的行有多少列是确定的，`null` 值浪费了存储，列式存储的 **hbase** `null` 不会被存储，节省空间，提高读的性能 
* 多版本数据
* 超大数据量，HBase 会自动水平切分扩展，跟Hadoop的无缝集成保障了其数据可靠性（HDFS）和海量数据分析的高性能（MapReduce），`rdbms` 可能就需要分库分表了

### Hbase 的一些重点概念

* Row key [按字典序排列](https://zh.wikipedia.org/wiki/%E5%AD%97%E5%85%B8%E5%BA%8F)

```
行主键， HBase 不支持条件查询和 Order by 等查询，
读取记录只能按 Row key（及其range）或全表扫描，因此 Row key 设计很重要
```
* Column Family（列族）

```
在表创建时声明，每个Column Family为一个存储单元
```
* Column（列）

```
HBase 的每个列都属于一个列族，以列族名为前缀，
如列 article:title 和 article:content 属于 article 列族，
author:name 和 author:nickname 属于 author 列族
```
* Timestamp

```
HBase 通过 row 和column 确定一份数据，这份数据的值可能有多个版本，
不同版本的值按照时间倒序排序，即最新的数据排在最前面，查询时默认返回最新版本。
Timestamp 默认为系统当前时间（精确到毫秒），也可以在写入数据时指定该值。
```
* Value

```
每个值通过 4 个键唯一索引，tableName+RowKey+ColumnKey+Timestamp=>value
```
* 存储类型

```
TableName 是字符串
RowKey 和 ColumnName 是二进制值（Java 类型 byte[]）
Timestamp 是一个 64 位整数（Java 类型 long）
value 是一个字节数组（Java类型 byte[]）
```

### Hbase 线上集群的搭建

* 环境变量

```
# hbase config
export HBASE_HOME=/opt/hbase
export PATH=$PATH:$HBASE_HOME/bin
```
* 配置hbase-site

### Hbase shell 基本操作

基于 Jruby（ JIRB）的shell
常见的操作有
```
create,describe,disable,drop,list,scan,
put,get,delete,deleteall,count,status
```

```bash
hbase(main):001:0> list //查看表
TABLE
ambarismoketest
prodFocus
test
user_track
4 row(s) in 0.2370 seconds

=> ["ambarismoketest", "prodFocus", "test", "user_track"]
hbase(main):003:0> create 't1', 'cf1' //创建表 t1，cf1 列族
0 row(s) in 2.3760 seconds

=> Hbase::Table - t1
hbase(main):008:0> describe 'user_track' //查看表 user_track 的描述
Table user_track is ENABLED
user_track
COLUMN FAMILIES DESCRIPTION
{NAME => 'e', BLOOMFILTER => 'ROW', VERSIONS =>
 '1', IN_MEMORY => 'false', KEEP_DELETED_CELLS
=> 'FALSE', DATA_BLOCK_ENCODING => 'NONE', TTL
=> 'FOREVER', COMPRESSION => 'NONE', MIN_VERSIO
NS => '0', BLOCKCACHE => 'true', BLOCKSIZE => '
65536', REPLICATION_SCOPE => '0'}
1 row(s) in 0.0400 seconds

hbase(main):016:0> put 't1','rowkey001', 'cf1:col1', 'value01' //增
0 row(s) in 0.0640 seconds

hbase(main):017:0> get 't1', 'rowkey001', 'cf1:col1' //查
COLUMN                  CELL
 cf1:col1               timestamp=1482803105761, value=value01
1 row(s) in 0.0550 seconds

hbase(main):018:0> scan 't1', {LIMIT=>5} //查
ROW                     COLUMN+CELL
 rowkey001              column=cf1:col1, timestamp=1482803105761, value=value01
1 row(s) in 0.0170 seconds

hbase(main):019:0> count 't1', {INTERVAL => 100, CACHE => 500} //查
1 row(s) in 0.0130 seconds

=> 1
```


### 通过 [thrift](https://zh.wikipedia.org/wiki/Thrift) 访问 hbase

						
> Thrift是一种接口描述语言和二进制通讯协议，[1]它被用来定义和创建跨语言的服务。[2]它被当作一个远程过程调用（RPC）框架来使用.

```
可以使用C#、C++（基于POSIX兼容系统[3]）、Cappuccino、[4]Cocoa、Delphi、Erlang、Go、Haskell、Java、Node.js、OCaml、Perl、PHP、Python、Ruby和Smalltalk。

```

下面介绍 `python`， `php`， `go` [其他](https://git-wip-us.apache.org/repos/asf/thrift/?p=thrift.git;a=tree;f=tutorial)通过 thrift 操作 hbase 

```
thrift --gen <language> <Thrift filename>
```

### python driver

```
root@master  /data1  tree gen-py -L 2                                                                     ✓  ⚡  2666  11:29:45
gen-py
├── hbase
│   ├── constants.py
│   ├── __init__.py
│   ├── THBaseService.py //增删改查等一系列接口
│   ├── THBaseService-remote
│   └── ttypes.py //类型定义
└── __init__.py

1 directory, 6 files
```