layout: post
title: 在服务器上使用shadowsocks客户端
date: 2016-06-06 10:14:53
tags: shadowsocks
categories:
  - hue
---

### ss客户端在centos上

因为在cenots上手动编译hue，需要下载大量的jar包，这段时间开源中国的maven库又维护，无奈只能在centos上也ss代理上网了。

<!--more-->
### 安装

```bash
$ yum install python-pip    
$ pip install shadowsocks
```
### 配置
```json
{
    "server":"x.x.x.x",             #ss服务器IP
    "server_port":xxx,             #ss服务器端口
    "local_address": "127.0.0.1",   #本地ip
    "local_port":1080,              #本地端口
    "password":"password",          #连接ss密码
    "timeout":300,                  #等待超时
    "method":"aes-256-cfb",             #加密方式(与服务器一致)
    "fast_open": false,             # true 或 false。如果你的服务器 Linux 内核在3.7+，可以开启 fast_open 以降低延迟。开启方法： echo 3 > /proc/sys/net/ipv4/tcp_fastopen 开启之后，将 fast_open 的配置设置为 true 即可
    "workers": 1                    # 工作线程数
}
```
### 启动&测试


```
$ nohup sslocal -c /etc/shadowsocks.json /dev/null 2>&1 &
// 然后加入开机自启动
$ echo " nohup sslocal -c /etc/shadowsocks.json /dev/null 2>&1 &" /etc/rc.local
```
```
$ ps aux |grep sslocal |grep -v "grep"
root     12936  0.0  0.0 201376  7764 pts/1    S    6月04   0:01 /usr/bin/python /usr/bin/sslocal -c /etc/shadowsocks.json /dev/null
```

测试
```
$ curl --socks5 127.0.0.1:1080 http://httpbin.org/ip
```
### 参考
[linux全局代理](http://www.jianshu.com/p/f688cdfa6947)
[http://overtrue.me/articles/2016/03/shadowsocks-on-server.html](http://overtrue.me/articles/2016/03/shadowsocks-on-server.html)
[https://github.com/shadowsocks/shadowsocks/tree/master](https://github.com/shadowsocks/shadowsocks/tree/master)