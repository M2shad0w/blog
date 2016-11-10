layout: post
title: 自动增量的hive-PARTITION实践
date: 2016-11-10 17:51:22
tags: 
  - python
  - hive
categories:
  - 同步
  - ETL
---

### 迁移
所有的日志结构化，落地到 `HDFS` 之后，想着提供一个供运营查询的方式，上篇文章介绍了 facebook 的 [`presto`链接](http://m2shad0w.com/2016/11/09/presto-小试/index.html), 这篇就是数据源的自动化准备的一个过程。

<!--more-->

### hive 创建外表与增加 partitions

hive 可以创建外表与内表，创建内表的过程会从原来 `hdfs` 路径移动数据到 hive 的默认路径， 对于这些文件还要供 spark 等调用，期望是放在一个预先创建好的路径下，外表正符合要求。

创建外表
关键字 `external`

```
CREATE external TABLE IF NOT EXISTS track_event ( id string, created_at string)
LOCATION '/user/root/external_table';
```
这个过程 Hive 甚至不会校验外部表的目录是否存在。因此可以在创建表格的时候在加载数据。

如何将所有的日志放到一张表内，有能加速查询呢？

hive 有个 `PARTITIONED` 的设计

结构化的数据可以按时间(比如`天`间隔)成一个文件夹，

比如加载数据
```sql
LOAD DATA INPATH 'path'
INTO TABLE track_event
PARTITION (dt='2001-01-01');
```
或者命令行加载数据(这个命令可以脚本调用自动化掉)

```
hive -e "alter table track_event add partition(dt='%s');"
```

显示现有的表有多少 `PARTITIONS`
```
SHOW PARTITIONS track_event;
1	dt=16-07-08
2	dt=16-07-09
3	dt=16-07-10
...
```

查询实例
```sql
SELECT eventable_id, user_id, created_at 
FROM hive.track_event_data.track_event 
where dt>='16-10-01' // PARTITIONS 条件
```

![web ui 的 presto查询](http://ww3.sinaimg.cn/large/63fe561egw1f9n6gniox3j21kw0jl41u.jpg)

### 代码示例

<script src="https://gist.github.com/M2shad0w/f08df53177f3dabe910725d5396cfbcb.js"></script>


###  参考文章

[http://blog.csdn.net/bingduanlbd/article/details/52076219](http://blog.csdn.net/bingduanlbd/article/details/52076219)