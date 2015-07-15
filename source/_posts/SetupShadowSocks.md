title: SetupShadowSocksServer
date: 2015-07-07 19:25:32
tags: 科学上网
categories:
  - server 
  - os
---
某博士给我们搭建的科学上网，服务了广大码农。今天突然想到之前github推出的[学生计划](https://education.github.com/pack)，在[digitalocean](https://www.digitalocean.com/?refcode=73470081618f)拿到了100$的代金券，于是就琢磨着自己搭建一个ShadowSocks服务器，现将搭建过程做一下纪录。

<!--more-->
## 搭建vps
* 给vps取一个名字
* 点击Create Droplet后的配置选项，我选择的是5$/mo
* Select Region 选择纽约，具体根据实际使用的自己的网络环境选择）
* Select Image 选择centos 7X64
* 然后点击 Create Droplet 大约等个30s就帮你建好了vps
* 会发送root的密码到你的注册邮箱，初次登录修改掉密码
![注册界面](http://7xk4vd.com1.z0.glb.clouddn.com/shadowsocks1.jpg)

## shadowsocks环境
* 安装 Python-Gevent，由于gevent依赖libevent和python-devel。
		yum install libevent
		yum install python-devel
		pip install gevent
* 安装M2Crypto，M2Crypto是用于加密的第三库
		yum install openssl-devel
    	yum install swig
    	pip install M2Crypto
* 安装Shadowsocks服务端
		yum install python-setuptools && easy_install pip
		pip install shadowsocks

## 配置服务端
* vi  /etc/shadowsocks.json
		{
    	"server":"yourserver_ip_adress",
    	"server_port":8033,
    	"local_address": "127.0.0.1",
    	"local_port":1080,
    	"password":"password",
    	"timeout":300,
    	"method":"aes-256-cfb",
    	"fast_open": false,
    	"workers": 1
		}
* 启动服务
		ssserver -c /etc/shadowsocks.json
		
## 路由器刷op装ss