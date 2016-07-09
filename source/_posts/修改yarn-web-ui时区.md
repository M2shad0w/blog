layout: post
title: 修改yarn-web-ui时区
date: 2016-07-09 14:05:20 
tags: bigdata
categories:
  - yarn
---

### yarn-web-ui时区显示不对

在运行spark on yarn 程序中，job偶尔会失败，加上job量又比较多，web－ui的时区不矫正，简直对给定位问题带来了困难。

下面就是我实践校正时区的一个过程。

<!--more-->

查看一下hadoop的版本

```bash
hadoop version
Hadoop 2.6.3
Subversion https://git-wip-us.apache.org/repos/asf/hadoop.git -r cc865b490b9a6260e9611a5b8633cab885b3d247
Compiled by jenkins on 2015-12-18T01:19Z
Compiled with protoc 2.5.0
From source with checksum 722f77f825e326e13a86ff62b34ada
This command was run using /opt/hadoop/share/hadoop/common/hadoop-common-2.6.3.jar
```
得知安装的版本是2.6.3, 编译的用的是protoc 2.5.0

从[https://issues.apache.org/jira/browse/YARN-1998](https://issues.apache.org/jira/browse/YARN-1998)得知这是一个bug(14年已经修复了，但是2.6.3版本还是出现了)。

### 解决方案

[https://issues.apache.org/jira/secure/attachment/12642581/YARN-1998.patch](https://issues.apache.org/jira/secure/attachment/12642581/YARN-1998.patch)

```js
Index: hadoop-yarn-project/hadoop-yarn/hadoop-yarn-common/src/main/resources/webapps/static/yarn.dt.plugins.js
===================================================================
--- hadoop-yarn-project/hadoop-yarn/hadoop-yarn-common/src/main/resources/webapps/static/yarn.dt.plugins.js	(revision 1591171)
+++ hadoop-yarn-project/hadoop-yarn/hadoop-yarn-common/src/main/resources/webapps/static/yarn.dt.plugins.js	(working copy)
@@ -78,7 +78,7 @@
     if(data === '0'|| data === '-1') {
       return "N/A";
     }
-    return new Date(parseInt(data)).toUTCString();
+    return new Date(parseInt(data)).toLocaleString();
   }
   // 'sort', 'type' and undefined all just use the number
   // If date is 0, then for purposes of sorting it should be consider max_int
```

### 找hadoop2.6.3分支，修改yarn.dt.plugins.js

首先需要安装对应的protobuf，[protobuf-2.5.0.tar.gz](https://github.com/google/protobuf/releases?after=v3.0.0-alpha-4), 下载地址[click](https://github.com/google/protobuf/releases/download/v2.5.0/protobuf-2.5.0.tar.gz)

`tar -xzvf ./protobuf-2.5.0.tar.gz`
`cd protobuf-2.5.0`
`make`
`make check`
`make install`

一气呵成安装好，并确认版本

`protoc --version`

从hadoop github仓库下载最新源码， 切换到2.6.3分支，进入`hadoop-yarn-common`目录，
找到`yarn.dt.plugins.js`中的`renderHadoopDate`函数，返回值修改成

```return new Date(parseInt(data)).toLocaleString()```

mvn编译打包

`mvn clean package -DskipTests`

### 参考文章

[http://my.oschina.net/allman90/blog/486768](http://my.oschina.net/allman90/blog/486768)