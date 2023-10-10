# rf2depth

cmd: 

- [ ] -d: 3d速度模型，用于动校正
- [ ] -m: 1d速度模型
- [ ] -r: 用于射线追踪的3d速度模型，npz格式的文件，
- [ ] cfg_file: cfg配置文件

给定3d速度模型后，会自动使用makedata3d()

不给定则使用makedata。

makedata3d 尚不完善，或者不能用于三维的追踪工作。Anyways

makedata 需要:

- [ ] stadatar — RFStation 对象，包含了台站记录等内容
- [ ] cpara.depth_axis — np.ndarray对象，包含了需要做转换的层位信息
- [ ] sphere — Bool， doubt
- [ ] phase — 对pP 或什么

makedata 返回：



makedata3d 根据是否做射线追踪，使用

* `psrf_3D_raytracing`
* `psrf_1D_raytracing`

分别返回P波与S波在各层的穿刺点（4组向量）

newtpds, raylength_s,raylength_p,tps,



**最终**以列表保存多个字典，包含：

* station
* stalat,stalon
* depthrange
* bazi,rayp
* moveout_correct: 转换后的数组。 PS_RFdepth, amp3d,
* piercelat, piercelon, stopindex

## 1D 时深转换

`psrf2depth`P波接收函数时深转换，又是一个接口，具体交给`xps_tps_map`做计算，计算结束后交给`time2depth`做补全

如果不给一个rayp的目录，则直接使用`RFStation.rayp`中的射线参数计算。

如果有，则根据深度范围、gcarc，事件深度，获取一个射线参数的集合，并转换到角度。这里给`xps...`提供了两个射线参数接口。前者为自己算的，后者为预先计算的结果。

接口如是：

1. dep_mod: DepthMode 1维速度模型
2. srayp, prayp。S波射线参数，P波射线参数。如果采用平面波假设，二者都使用相等的结果。反之则给srayp赋之前计算的数组
3. is_raylen。是否计算某个深度上的射线长度(ray length)
4. sphere：是否做展平变换
5. phase：单次波或多次波

ray_len和穿刺点都是给DepthMod的类方法算的

计算好穿刺点后，对穿刺点，tps



## 具体的时深转换

所有的时深转换最后要靠`time2depth`函数插值补全。

几个返回值：

1. EndIndex — 最后的位置，使用虚数位=1 标记，或者为