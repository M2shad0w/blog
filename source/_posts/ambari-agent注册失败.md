layout: post
title: ambari-agent注册失败
date: 2016-06-02 14:44:16
tags: ambari
categories:
  - bigdata
---
### ambari

ambari是一个自动化的部署hadoop生态产品的好工具，这次在搭建线下测试环境的时候正好使用一下，下面将搭建过程中的坑，做一些简单的记录

<!--more-->
### 过程

搭建的过程首先参考[hortonworks.com的文章](http://docs.hortonworks.com/HDPDocuments/Ambari-2.2.2.0/bk_Installing_HDP_AMB/content/_start_the_ambari_server.html)的文章.
包括
1. [无密码登陆](http://docs.hortonworks.com/HDPDocuments/Ambari-2.2.2.0/bk_Installing_HDP_AMB/content/_set_up_password-less_ssh.html)
2. [安装ntp服务，同步时间](http://docs.hortonworks.com/HDPDocuments/Ambari-2.2.2.0/bk_Installing_HDP_AMB/content/_enable_ntp_on_the_cluster_and_on_the_browser_host.html)
3. [安装wget等基本软件]
4. [设置FQDN, DNS](http://docs.hortonworks.com/HDPDocuments/Ambari-2.2.2.0/bk_Installing_HDP_AMB/content/_edit_the_host_file.html)
5. [关闭防火墙, selinux]

### 坑

* 在`ambari-server setup` 选择数据库时候没有选择默认的`postgres`, 而选择了`mysql`，后面`ambar-server reset` 想重新设置为`postgres`时候不起作用
* centos 的系统语言设置成中文，导致 `Registration with the server failed`, 将系统语言改成英文就好了

```
Connection to laboratorio.cetax.com closed.
SSH command execution finished
host=laboratorio.cetax.com, exitcode=0
Command end time 2016-04-29 11:27:04
 
 
Registering with the server...
Registration with the server failed.
```

### 参考文章
[http://www.oschina.net/question/2684511_2159089](http://www.oschina.net/question/2684511_2159089)

[http://docs.hortonworks.com/HDPDocuments/Ambari-2.2.2.0/bk_Installing_HDP_AMB/content/_edit_the_host_file.html](http://docs.hortonworks.com/HDPDocuments/Ambari-2.2.2.0/bk_Installing_HDP_AMB/content/_edit_the_host_file.html)
