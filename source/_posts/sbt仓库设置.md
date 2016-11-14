title: sbt仓库设置
date: 2016-01-15 17:56:24
tags: scala
categories: bigdata

---

### sbt 构建 scala 应用

> sbt is a build tool for Scala, Java, and more. It requires Java 1.6 or later.

正如官网所说, sbt是一个为 scala、java 而生的构建工具，在mac上安装十分的方便。

<!--more-->

```bash
brew install sbt
```


只要你构建的目录有如下的层级

```bash
src/
  main/
    resources/
       <files to include in main jar here>
    scala/
       <main Scala sources>
    java/
       <main Java sources>
  test/
    resources
       <files to include in test jar here>
    scala/
       <test Scala sources>
    java/
       <test Java sources>
```

在根目录 `touch build.sbt`, 设置 build.sbt 配置应用依赖的库。

在 console 中键入 `sbt run`, 代码就被编译运行起来了

### 默认仓库下载依赖慢

sbt 默认下载库文件很慢, 还时不时被打断

开源中国的 maven 仓库已经不可用

这里可以使用 ali 的仓库

我们可以在用户目录下创建  `touch ~/.sbt/repositories`, ~~填上开源中国的镜像~~

```bash
[repositories]
local
osc: http://maven.oschina.net/content/groups/public/
typesafe: http://repo.typesafe.com/typesafe/ivy-releases/, [organization]/[module]/(scala_[scalaVersion]/)(sbt_[sbtVersion]/)[revision]/[type]s/[artifact](-[classifier]).[ext], bootOnly
sonatype-oss-releases
maven-central
```

填上 ali 的仓库地址 

```bash
[repositories]
local
osc: http://maven.aliyun.com/nexus/content/groups/public/
typesafe: http://repo.typesafe.com/typesafe/ivy-releases/, [organization]/[module]/(scala_[scalaVersion]/)(sbt_[sbtVersion]/)[revision]/[type]s/[artifact](-[classifier]).[ext], bootOnly
sonatype-oss-releases
maven-central
sonatype-oss-snapshots
```


vi ~/.m2/settings.xml

```bash
    <mirror>
      <id>alimaven</id>
      <name>aliyun maven</name>
      <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
      <mirrorOf>central</mirrorOf>
    </mirror>
```

[参考官网说明](http://www.scala-sbt.org/0.13.2/docs/Detailed-Topics/Library-Management.html#override-all-resolvers-for-all-builds)

### 遇到的问题
一定要严格按格式来, local `  ` 后面不要有空格。