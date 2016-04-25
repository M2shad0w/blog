title: go2mongo
date: 2016-04-25 10:43:34
tags: go
categories: 
	- mongo
	- go
---

### go操作mongo的好驱动

画像一类的数据存放在NOSQL中，一个文档就可以了解这个生物的特性，现在尝试用go读写mongo。发现go下一个好的mongo驱动**mgo**。

<!--more-->

在github 的 `go awesome` 项目下，搜索`mongo`，看到如下说明

`MongoDB driver for the Go language that implements a rich and well tested selection of features under a very simple API following standard Go idioms`

### 安装mgo驱动

按照mgo的介绍页[http://labix.org/mgo](http://labix.org/mgo)

`go get gopkg.in/mgo.v2`

### 快速实现例子

```go
package main

import (
        "fmt"
	"log"
        "gopkg.in/mgo.v2"
        "gopkg.in/mgo.v2/bson"
)

type Person struct {
        Name string
        Phone string
}

func main() {
        session, err := mgo.Dial("server1.example.com,server2.example.com")
        if err != nil {
                panic(err)
        }
        defer session.Close()

        // Optional. Switch the session to a monotonic behavior.
        session.SetMode(mgo.Monotonic, true)

        c := session.DB("test").C("people")
        err = c.Insert(&Person{"Ale", "+55 53 8116 9639"},
	               &Person{"Cla", "+55 53 8402 8510"})
        if err != nil {
                log.Fatal(err)
        }

        result := Person{}
        err = c.Find(bson.M{"name": "Ale"}).One(&result)
        if err != nil {
                log.Fatal(err)
        }

        fmt.Println("Phone:", result.Phone)
}
```
### 效果

![](http://ww3.sinaimg.cn/large/63fe561egw1f38rh2u41zj20ea05074u.jpg)

好了，去写接口了...