title: 电池放电曲线
date: 2015-07-03 13:32:49
tags: python
categories:
  - dataMining
---

### **0x01 OverView**
**要求 电池曲线最后拟合函数百分比大致连续 精度2%**


<!--more-->

### **0x02 准备**
$E = U \cdot I \cdot T$ (E为能量)

根据公式，测试的时候保证放电电流恒定，保证测量的时间间隔恒定，然后读取电压的 AD 采样。写好测试代码，将数据存储在mcu中。
### 读取数据
电池标称50mAH,测试的时候以5mAH的电流放电，每个一分钟纪录一个样本点，最后得到600个数据点。数据通过蓝牙设备倒入到电脑,利用python处理数据，绘制可视化放电曲线图。
### **0x03图例**

![放电曲线](http://7xk4vd.com1.z0.glb.clouddn.com/batterybl.jpg)
根据绘制的图形，可以看出电压快速下降的转折点在3.7v，能量集中在3.7v以上，我们在做实验的时候保证放电电流一定，采样时间间隔一定，所以电池的整个能量就是曲线与坐标轴所围起来的面积，每一采样点的电量百分比就是总量减去采样点到零点之间面积与总量的占比。即 percent = $\frac{total - detal}{total}$
简单处理之后的百分比与adc采样的关系图就是这样的。

![电压adc与电量百分对应曲线图](http://7xk4vd.com1.z0.glb.clouddn.com/battery2bl2.jpg)
因为mcu资源有限，拟合曲线只取了一阶拟合，根据关系图，分成十段拟合。
### python代码

```python
import numpy as np
def line(p, a): ＃拟合函数
	y = np.array(p)
	x = np.array(a)
	z = np.polyfit(x, y, 1) # x,y是两个列表 1是拟合阶数
	p = np.poly1d(z)
	print(p) # 拟合公式
```
 
拟合一阶函数如下

```shell
4.784 x + 608.8
0.8612 x + 630.3
0.4823 x + 637.9
0.3716 x + 641.3
0.4754 x + 637.1
0.6561 x + 628.1
1.086 x + 602.2
1.077 x + 603.3
1.107 x + 600.8
1.26 x + 587.2
```
将系数表示成两数相除，得到新公式，根据公式重新翻转去重绘百分比与电压采样值的关系，发现效果还不错，满足要求。

[python 完整代码](https://github.com/M2shad0w/py_tool/blob/master/battery.py)