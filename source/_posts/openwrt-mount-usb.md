title: openwrt_mount_usb
date: 2016-04-24 22:16:53
tags: openwrt
categories: hardware
---

### 老路由刷上openwrt

周末在家， 窗外下着淅淅沥沥的雨，没错，这就是江南的梅雨季节。所以闲来无事，决定倒腾一下路由器。

<!--more-->

这是一台老路由器，大亚db120，之前刷过dreambox的op，但是想要装一些新的ipk的时候不能装上，想想还是刷到最新的固件好了。

在openwrt官网上找到db120芯片的固件（cpu是博通的brcm63xx），刷上[snapshots](https://openwrt.mirrors.ustc.edu.cn/snapshots/trunk/brcm63xx/generic/)的**openwrt-brcm63xx-generic-RG100A-squashfs-cfe.bin**

sysupdate   *bin

等待片刻，升级成功

### 修改opkg源为ustc源

> vi /etc/opkg.conf # 添加如下路径

```bash
src/gz barrier_breaker_base https://openwrt.mirrors.ustc.edu.cn/snapshots/trunk/brcm63xx/generic/packages/base
src/gz barrier_breaker_luci https://openwrt.mirrors.ustc.edu.cn/snapshots/trunk/brcm63xx/generic/packages/luci
src/gz barrier_breaker_management https://openwrt.mirrors.ustc.edu.cn/snapshots/trunk/brcm63xx/generic/packages/management
src/gz barrier_breaker_packages https://openwrt.mirrors.ustc.edu.cn/snapshots/trunk/brcm63xx/generic/packages/packages
src/gz barrier_breaker_routing https://openwrt.mirrors.ustc.edu.cn/snapshots/trunk/brcm63xx/generic/packages/routing
src/gz barrier_breaker_telephony https://openwrt.mirrors.ustc.edu.cn/snapshots/trunk/brcm63xx/generic/packages/telephony
src/gz barrier_breaker_kernel https://openwrt.mirrors.ustc.edu.cn/snapshots/trunk/brcm63xx/generic/packages/kernel
src/gz barrier_breaker_targets https://openwrt.mirrors.ustc.edu.cn/snapshots/trunk/brcm63xx/generic/packages/targets
```

### 挂载u盘做外部存储

手头有16GB的金士顿优盘，挂载上去做外部存储，将opkg install 的软件包都安装在u盘中。

```bash
安装usb支持：
>opkg install kmod-fs-ext4
>opkg install kmod-usb-storage
>opkg install block-mount
```
