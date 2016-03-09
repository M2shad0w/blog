title: hdfs文件坏块
date: 2016-02-19 11:09:56
tags: hadoop
categories: bigdata

---
### 重启hadoop带来的问题
之前flume一直在往hadoop写数据，hadoop重启过程，flume送进来的文件被中断，但是hadoop依然认为这个文件是打开着的。解决方案是删除这个文件。

<!--more-->
### 错误

spark 从hdfs上 load数据的时候出现错误

```bash
cause:java.io.IOException: Cannot obtain block length for LocatedBlock
```
用 `hdfs fsck /` 查看显示 `hadoop显示现在没有任何丢失的块`

找出文件
`hadoop fsck / -openforwrite |egrep -v '^\.+$' |egrep "MISSING|OPENFORWRITE" |grep -o "/[^ ]*" |sed -e "s/:$//|sort |uniq"`

![](http://ww4.sinaimg.cn/mw690/63fe561egw1f14hdula3mj20qk066q48.jpg)

删除文件

`hadoop fs -rm -skipTrash $file`

### 参考文章

[http://ju.outofmemory.cn/entry/204699](http://ju.outofmemory.cn/entry/204699)

[http://stackoverflow.com/questions/19205057/how-to-fix-corrupt-hadoop-hdfs/19216037#19216037](http://stackoverflow.com/questions/19205057/how-to-fix-corrupt-hadoop-hdfs/19216037#19216037)