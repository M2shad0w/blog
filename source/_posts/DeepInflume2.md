title: DeepInConfigflume
date: 2016-02-18 16:04:28
tags: flume
categories: bigdata
---

### flume深入配置

想只开一个端口, 通过配置, 将日志灵活地写在hdfs。通过时间、事件类型等隔离。

<!--more-->

### 读flume文档
> Alias	Description
> %{host}	Substitute value of event header named “host”. Arbitrary header names are supported.

![](http://ww1.sinaimg.cn/mw690/63fe561egw1f13k8osfxoj219y058gmq.jpg)

因此，需要在post数据headers 中加上 `host` 字段.

快速修改一下flume的配置文件，测试一下

配置文件对应修改字段：

```bash
agent1.sinks.hdfs-sink1.hdfs.path = hdfs://master:9000/user/hadoop/%{host}/%y-%m-%d/
agent1.sinks.hdfs-sink1.hdfs.filePrefix = event_%y-%m-%d_%H_%M_%S
```
测试:

```bash
curl -X POST -d '[{"headers":{"host" : "chat"},"body" : "hello random flume "}]' http://{your ip}:{your port}
```
成功:

![](http://ww4.sinaimg.cn/mw690/63fe561egw1f13kkyzbd3j20yq02s75h.jpg)
