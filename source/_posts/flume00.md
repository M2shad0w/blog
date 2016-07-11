title: flume聚合日志
date: 2016-01-06 21:10:24
tags: hadoop
categories: bigdata	

---


### **起因**
用spark分析数据时, 希望源数据能够写到HDFS上, 在前端数据采集的选择有kalfa 和flume, 了解了各自的特性, 打算使用flume 将数据聚合起来。

<!--more-->

### **Flume 简介**
> Apache Flume is a distributed, reliable, and available system for efficiently collecting, aggregating and moving large amounts of log data from many different sources to a centralized data store.

Apache Flume 是一种可靠的分布式可用系统，用于从许多不同源将大量日志数据收集、聚合和移动至集中的数据存储。

### **实践**
[聚合http-source](https://flume.apache.org/FlumeUserGuide.html#http-source), HTTP 请求通过一个 “handler” 将被转换成 flume 事件, 一个 Http 请求中的所有事件将被一次提交到 flume 的管道内. 如果 “handler” 抛出了一个异常, flume source 将会返回一个 HTTP 400 的状态码, 如果 flume source  不能添加事件到管道，将会返回一个 HTTP 503 的 状态码(暂时不可达)。

* 在flume的安装目录的配置文件夹下

	```shell
	/opt/apache-flume/conf
	```

* 添加配置文件

	```shell
	flume-conf-http.properties
	```
* 配置文件内容
	
	```bash
	# Define source, channel, sink
	agent1.sources = r1
	agent1.channels = ch1
	agent1.sinks = hdfs-sink1
	# Configure channel
	agent1.channels.ch1.type = memory
	agent1.channels.ch1.capacity = 1000000
	agent1.channels.ch1.transactionCapacity = 500000
	# Define and configure an Spool directory source
	agent1.sources.r1.channels = ch1
	agent1.sources.r1.type = http
	agent1.sources.r1.port = 5143
	agent1.sources.r1.handler = org.apache.flume.source.http.JSONHandler
	agent1.sources.r1.handler.nickname = random props
	agent1.sources.r1.ignorePattern = event(_\d{4}\-\d{2}\-\d{2}_\d{2}_\d{2})?\.log(\.COMPLETED)?
	agent1.sources.r1.batchSize = 50
	# Define and configure a hdfs sink
	agent1.sinks.hdfs-sink1.channel = ch1
	agent1.sinks.hdfs-sink1.type = hdfs
	agent1.sinks.hdfs-sink1.hdfs.path = hdfs://master:9000/user/hadoop/	flumetest/
	agent1.sinks.hdfs-sink1.hdfs.filePrefix = event_%y-%m-%d_%H_%M_%S
	agent1.sinks.hdfs-sink1.hdfs.fileSuffix = .log
	agent1.sinks.hdfs-sink1.hdfs.rollSize = 1048576
	agent1.sinks.hdfs-sink1.hdfs.rollCount = 0
	agent1.sinks.hdfs-sink1.hdfs.batchSize = 1500
	agent1.sinks.hdfs-sink1.hdfs.round = true
	agent1.sinks.hdfs-sink1.hdfs.roundUnit = minute
	agent1.sinks.hdfs-sink1.hdfs.threadsPoolSize = 25
	agent1.sinks.hdfs-sink1.hdfs.useLocalTimeStamp = true
	agent1.sinks.hdfs-sink1.hdfs.minBlockReplicas = 1
	agent1.sinks.hdfs-sink1.hdfs.fileType = DataStream
	agent1.sinks.hdfs-sink1.writeFormat = TEXT
	agent1.sinks.hdfs-sink1.rollInterval = 0	
	```

* 启动 Flume, 将数据回显在控制台
	
	```shell
	bin/flume-ng agent -c ./conf/ -f conf/flume-conf-http.properties -Dflume.root.logger=INFO,console -n agent1
	```
* python post 数据测试

	```python
    # -*- coding: utf-8 -*-
    # !/usr/bin/env python
    __author__ = 'm2shad0w'
    import time
    import requests
    import json
    i = 0
    j = 0
    # flume  server url
    url = 'http://prispark2.baidu.cn:5143'

    payload = [{"body": "spark stream test","headers": {"host": "hello"}}]
    while True:
        i += 1
        r = requests.post(url, data=json.dumps(payload))
        # print r.status_code
        if r.status_code != 200:
            j += 1
        if i > 100000:
            break
    print "send times is ", i, "fail times is ", j
	```
* 查看文件
	
	```shell
	hadoop fs -ls -R /user/hadoop/	flumetest/
	```
### **总结**
一开始在配置 **hdfs.fileType = SequenceFile** hadoop fs -cat 文件的时候, 显示乱码。应该配置成 **DataStream**