title: sqoop导数据
date: 2016-01-09 13:57:26
tags: hadoop
categories: 
	- bigdata

---

### **sqoop 简介**
sqoop 是 apache 基金会提供的用于 RDBMS 和 HDFS 互导数据的工具, 以下是我从 mysql 导数据到 hdfs 过程的一个纪录。

<!--more-->

### **安装sqoop**
* mac 下安装

	```bash
	brew install sqoop
	```

* Linux 下安装

	```bash
	tar vxzf sqoop-x-y-z.tar.gz
	#然后设置 SQOOP_HOME
	export SQOOP_HOME=/opt/sqoop
	export PATH=$PATH:$SQOOP_HOME/bin
	```
### **使用sqoop**
* 查看sqoop用法

	```bash
$ sqoop help
16/01/09 14:09:16 INFO sqoop.Sqoop: Running Sqoop version: 1.4.6
usage: sqoop COMMAND [ARGS]
#
Available commands:
  codegen            Generate code to interact with database records
  create-hive-table  Import a table definition into Hive
  eval               Evaluate a SQL statement and display the results
  export             Export an HDFS directory to a database table
  help               List available commands
  import             Import a table from a database to HDFS
  import-all-tables  Import tables from a database to HDFS
  import-mainframe   Import datasets from a mainframe server to HDFS
  job                Work with saved jobs
  list-databases     List available databases on a server
  list-tables        List available tables in a database
  merge              Merge results of incremental imports
  metastore          Run a standalone Sqoop metastore
  version            Display version information
#
See 'sqoop help COMMAND' for information on a specific command.
```

	通过命令 **sqoop help** 回显, 得知每一步的命令下可以接什么参数都可以加上 \--help

	```bash
$ sqoop import --help
$ sqoop help import
```

	也可以使用别名
	
	```bash
$ sqoop-import
```

* 到入数据到 hdfs

	```bash
sqoop import \
--connect jdbc:mysql://10.200.122.47/test \ #连接数据库
--table users \ #表名
--username root \ #表用户名
-P \ #控制台输入密码
--fields-terminated-by "\01" \ #字段分隔符
--target-dir /user/hadoop/mysql/test/users #指定hdfs路径
```

### 总结
sqoop导数据其实是自动帮你写了java代码, 提交给hadoop做MR任务。确保集群每个节点都能连接访问数据库。

参考文献：
[Sqoop导入关系数据库到Hive](http://segmentfault.com/a/1190000002532293)
[Sqoop中文手册](http://www.cloudera.com/content/cloudera/zh-CN/documentation/core/v5-3-x/topics/cdh_ig_sqoop_package_install.html)