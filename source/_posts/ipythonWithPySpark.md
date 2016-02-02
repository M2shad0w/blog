title: 把ipython设置成PySpark解析器
date: 2016-01-22 14:17:00
tags: spark
categories: 
	- bigdata
	- ipython
---

### **pyspark**
pyspark 是spark的 python接口实现的入口, 但是pyspark默认调用的是python的解析器, 在shell中调试时, 连基本的代码提示都没有, 很影响效率。
ipython with pyspark 就能解决这个问题。

<!--more-->

### 软件依赖

* IPython `pip show ipython`

	```bash
	---
	Metadata-Version: 2.0
	Name: ipython
	Version: 4.0.1
	Summary: IPython: Productive Interactive Computing
	Home-page: http://ipython.org
	Author: The IPython Development Team
	Author-email: ipython-dev@scipy.org
	License: BSD
	Location: /Library/Python/2.7/site-packages
	Requires: traitlets, pickleshare, simplegeneric, decorator, gnureadline, appnope, pexpect
	Entry-points:
	  [console_scripts]
	  iptest = IPython.testing.iptestcontroller:main
	  iptest2 = IPython.testing.iptestcontroller:main
	  ipython = IPython:start_ipython
	  ipython2 = IPython:start_ipython
	  [pygments.lexers]
	  ipython = IPython.lib.lexers:IPythonLexer
	  ipython3 = IPython.lib.lexers:IPython3Lexer
	  ipythonconsole = IPython.lib.lexers:IPythonConsoleLexer
	```
* pyspark

### 配置ipython

1. First create an IPython profile for use with PySpark

	```bash
	ipython profile create pyspark
	```

2. This should have created the profile directory `~/.ipython/profile_pyspark/.` Edit the file `~/.ipython/profile_pyspark/ipython_notebook_config.py` to have:

	```bash
	c = get_config()
	 
	c.NotebookApp.ip = '*'
	c.NotebookApp.open_browser = False
	c.NotebookApp.port = 8880 
	```
3. Finally, create the file `~/.ipython/profile_pyspark/startup/00-pyspark-setup.py` with the following contents:

	```python
	import os
	import sys
	 
	spark_home = os.environ.get('SPARK_HOME', None)
	if not spark_home:
	    raise ValueError('SPARK_HOME environment variable is not set')
	sys.path.insert(0, os.path.join(spark_home, 'python'))
	sys.path.insert(0, os.path.join(spark_home, 'python/lib/py4j-0.9-src.zip'))
	execfile(os.path.join(spark_home, 'python/pyspark/shell.py'))
	```

### Starting IPython Notebook with PySpark

保证**`$SPARK_HOME`**环境变量设置好

```bash
ipython --profile=pyspark
```
如果你要使用notebook, 这里有一个方法

* Install apache-spark ($ brew install apache-spark)
* install findspark ( pip install -e . after cloning [https://github.com/minrk/](https://github.com/minrk/)findspark, and cd findspark)
* install java
* fire a notebook (`jupyter notebook`)

<script src="https://gist.github.com/M2shad0w/b844676ac996394b9bbd.js"></script>

[pyspark on notebook](https://github.com/jupyter/notebook/issues/309#issuecomment-134540424)
[参考文章](http://blog.cloudera.com/blog/2014/08/how-to-use-ipython-notebook-with-apache-spark/)