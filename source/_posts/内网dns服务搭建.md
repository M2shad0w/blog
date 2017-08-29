layout: post
title: 内网dns服务搭建
date: 2017-08-28 16:44:17
tags: sys
categories:
  - dns
  - yum
---

## 0x01

在内网部署了很多服务，且在不同的机器端口上，不同的服务又要给其他同事访问。ip访问就十分的麻烦，所以就在内网搭建了一下内网 dns 服务。以下是小记。

<!--more-->

## 0x02

在 centos 7 机器上运行如下命令

```
yum install bind-chroot -y # 安装 bind 服务
systemctl enable named-chroot # 设置开机启动
```

修改 bind 默认配置
path `/etc/named.conf`

```
listen-on port 53 { any; }表示监听任何ip对53端口的请求
allow-query { any; }表示接收任何来源查询dns记录
```

## 0x03

在配置尾部添加需要解析的一级域名, 具体解析规则在/var/named/a.com.zone里

```
zone "a.com" IN {
    type master;
    file "a.com.zone";
};
```

增加一个反解析

```
zone "0.168.192.in-addr.arpa" IN {
    type master;
    file "192.168.0.zone";
};
```

/var/named/a.com.zone文件内容，请注意named用户有读的权限

```
root@master  /var/named  cat hunliji.cn.zone
$TTL 1D
@	IN SOA	@ hunliji.cn. (
					0	; serial
					1D	; refresh
					1H	; retry
					1W	; expire
					3H )	; minimum
		NS			@
		AAAA	    ::1
		A           127.0.0.1
s		A	    	172.16.10.18
master	A	    	172.16.10.16
slave01 A 	    	172.16.10.17
@       MX    10    mx.hunliji.cn.

```

/var/named/192.168.0.zone文件内容，请注意named用户需要有读的权限

```
$TTL 1D
@       IN SOA  hunliji.cn. hunliji.cn. (
                                        0       ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H )    ; minimum
        NS      @
        AAAA    ::1
18		PTR     s.hunliji.cn.
16      PTR		www.hunliji.cn.
16      PTR     docs.hunliji.cn.
16      PTR     master.hunliji.cn.
```

启动bind

```
systemctl start named-chroot
```

查看 dns

```
➜  ~ nslookup master.hunliji.cn
Server:		172.16.10.16
Address:	172.16.10.16#53

Name:	master.hunliji.cn
Address: 172.16.10.16
```
