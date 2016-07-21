layout: post
title: tornado.web日志logger配置
date: 2016-07-21 17:27:20
tags: data
categories:
  - web
---

### web logger

提供的用户画像api需要被业务调用，并发量就会比较高了。web容器必须将日志配好，已供性能调优。

<!--more-->

[Tornado ](http://old.sebug.net/paper/books/tornado/#_10) 是一个非阻塞式的web服务器。每秒可以处理数以千计的连接，在我的实际应用中主要是用来做数据api的(编程语言是python，比较轻快)。[简介](http://www.tornadoweb.org/en/stable/web.html)

### logger配置与每日分割

[参考文章](http://guoze.me/2015/01/31/tornado-log-perday/)

```bash
# logging.yaml

version: 1
disable_existing_loggers: false
formatters:
  simple:
    format: '%(asctime)s - %(name)s - %(levelname)s - %(message)s'

loggers:
  all:
    handlers: [all]
    propagate: false
  tornado:
    handlers: [all]
    propagate: false

handlers:
  console:
    class: logging.StreamHandler
    level: INFO
    formatter: simple
    stream: ext://sys.stdout
  all:
    class: logging.handlers.TimedRotatingFileHandler
    level: INFO
    formatter: simple
    when: midnight
    filename: ./logs/server.log

root:
  level: INFO
  handlers: [console, all]
  propagate: true
```
将配置文件放在web根目录下，在web server中引入 `import logging, yaml, logging.config`

如果缺少什么，就按错误日志，安装相应的依赖包