title: battery-discharge
date: 2015-07-03 13:32:49
tags: python
---
#某一块电池放电曲线测试纪录

### OverView
***要求 电池曲线最后拟合函数百分比大致连续 精度2%***

###准备
> E = U'I'T (E为能量)

测试的时候保证放电电流恒定，保证测量的时间间隔恒定，然后读取电压的 AD采样。写好测试代码，将数据存储在mcu中。
###读取数据
电池标称50mAH,测试的时候以5mAH的电流放电，每个一分钟纪录一个样本点，最后得到600个数据点。
###图例
![放电曲线](http://7xk4vd.com1.z0.glb.clouddn.com/disCharge_line_signal.png)
###python代码
######读取文本


	import numpy as np
 	def line(p, a): ＃拟合函数
      y = np.array(p)
      x = np.array(a)
      z = np.polyfit(x, y, 1) # x,y是两个列表 1是拟合阶数
      p = np.poly1d(z)
      print(p) # 拟合公式
	if __name__ == '__main__':
	  # 读取文本处理之后的两个列表数据
	  line(lista,listb)
 
[python 完整代码](https://github.com/M2shad0w/py_tool/blob/master/battery.py)