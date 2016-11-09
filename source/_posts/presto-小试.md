layout: post
title: presto_小试
date: 2016-11-09 11:50:55
tags: bigdata
categories: 
		- sql
		- dataMining
---

### 安装环境

* 操作系统：`centos 7 x86_64 x86_64 x86_64 GNU/Linux` 3台
* hadoop 集群：`Hadoop 2.7.1.2.4.2.0-258`
* jdk：`java version "1.8.0_60"`

<!--more-->

### 安装步骤

参考 [http://prestodb.io/docs/current/installation.html](http://prestodb.io/docs/current/installation.html)

下载最新 [presto-server-0.156.tar.gz](https://repo1.maven.org/maven2/com/facebook/presto/presto-server/0.156/presto-server-0.156.tar.gz) 安装包。

目录结构

```
presto-server-0.155
├── bin
├── etc
├── lib
├── NOTICE
├── plugin
├── presto
└── README.txt
```
### 配置 presto

目录 `etc` 中 `config.properties` 是 presto 的基本配置文件，有两种角色，协调器（coordinator）， workers

3台机器，在一台机器上同时配置协调器和 workers， 另两台只配置 workers

coordinator
```
coordinator=true
node-scheduler.include-coordinator=true
http-server.http.port=28080
query.max-memory=6GB
query.max-memory-per-node=2GB
discovery-server.enabled=true
discovery.uri=http://hostname:28080
```
workers
```
coordinator=true
node-scheduler.include-coordinator=true
http-server.http.port=28080
query.max-memory=6GB
query.max-memory-per-node=2GB
discovery-server.enabled=true
discovery.uri=http://hostname:28080
```

配置 `etc/node.properties`

```
node.environment=production
node.id=ffffffff-ffff-ffff-ffff-ffffffffffff
node.data-dir=/var/presto/data
```
主意其中 `node-id` 的值， 每台应该是不一样的
可以用一下命令生成

```
➜  ~ uuidgen
4a51e7b6-cc3b-4aeb-993c-33cbc2682fcf
```

jvm 配置 `etc/jvm.config` (直接推荐的配置)

```
-server
-Xmx16G
-XX:+UseG1GC
-XX:G1HeapRegionSize=32M
-XX:+UseGCOverheadLimit
-XX:+ExplicitGCInvokesConcurrent
-XX:+HeapDumpOnOutOfMemoryError
-XX:OnOutOfMemoryError=kill -9 %p
```
设置 `connector`

因为主要是 `hive` 的查询，所以只配置了 `hive`，实际上 presto 支持多种

```
connector.name=hive-hadoop2
hive.config.resources=/etc/hadoop/conf/core-site.xml,/etc/hadoop/conf/hdfs-site.xml
hive.metastore.uri=thrift://host:9083
```
### 运行 presto

在三台机器上依次运行 `bin/launcher run`, 酷炫的界面出现了。可以实时的展示查询的情况。

![](http://ww2.sinaimg.cn/large/63fe561egw1f9ltx98rywj21kw0swdnq.jpg)

### 测试 Presto CLI

下载 [presto-cli-0.156-executable.jar](https://repo1.maven.org/maven2/com/facebook/presto/presto-cli/0.156/presto-cli-0.156-executable.jar),
重命名为 `presto`, 加上可执行的权限 `chmod +x`, 执行。



1. 登陆 presto cli
	`./presto --server hostname:28080 --catalog hive --schema default`
2. 显示有那些现有的 `schema`
	`show schema;`
3. 切换到对应的 `schema`
	`use track_event_data;`
4. 查询(字符串单引号)
	```
	select c.eventable_type, count(*) as top
	from track_event_2016_07_21 as c
	where c.eventable_type = 'Example'
	group by c.eventable_type
	order by top
	desc;
	```
5. 速度(多次查询有 cache)
	```
	 eventable_type |  top
	----------------+-------
	 Example        | 26287
	(1 row)

	Query 20161104_084407_00087_c4yiu, FINISHED, 1 node
	Splits: 27 total, 27 done (100.00%)
	0:03 [4.51M rows, 790MB] [1.61M rows/s, 281MB/s]
	```

6. 退出

	```
	exit
	```
感人的速度

### 哪些团队在使用 presto

airbnb, jd, meituan, facebook, hunliji etc

### 总结

下一步在 presto 上套一个 `web ui`, 这样就可以给运营运行一些即时查询了。
