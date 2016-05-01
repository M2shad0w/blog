title: pandas2data
date: 2016-04-28 11:46:39
tags: python
categories: 
		- pandas
		- dataMining
---

### pandas处理数据
一些数据需要通过pandas聚合，很快就可以给到运营了，少写代码...
<!--more-->

需求中有将几张表中的数据聚合

这几张表都有一个公共的key，但是没法通过一个简单的sql语句完成（跨裤，不在一个地方）
这时候就可以通过pandas的DataFrame 的聚合输出

`from pandas import DataFrame`
### pandas操作文档
[官方文档](http://pandas.pydata.org/pandas-docs/stable/merging.html#brief-primer-on-merge-methods-relational-algebra)

将前面获得的从pymysql中list对象传入DataFrame

```python
df = DataFrame(result1)
df2 = DataFrame(result2)
df3 = DataFrame(result3)
```
```python
dff = pd.merge(df, df2, how='left', on="id")
dff1 = pd.merge(dff, df3, how='left', on="id")
```
聚合之后导出到xlsx

```python
dff1.to_excel('foo.xlsx', sheet_name='sheet1')
```