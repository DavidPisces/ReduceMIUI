# MIUI精简计划

##### 这是一个Magisk模块，适用于国内版MIUI  

#### 没有版本机型限制

######  特点：在不影响正常功能情况下尽可能精简系统进程

##### 主要功能：

- 精简系统进程

- 调整MIUI的Zram上限和使用

- 调整系统预读(128kb)

  ###### 以下是模块的参数调整和注意事项

  ##### 注意事项

  * 模块的主要调整在config.sh,不要对模块的module.prop做过多修改，可能导致脚本出现问题

    例如：

    * 随意增添空行
    * 重复增加version=xx 版本号

  * 模块的版本号是由config.sh自动写入，无需在module.prop重复手动加入

  * 模块默认调整Zram上限是3001，有需要请自行调整mcd_default.conf(个人不建议在大内存手机上使用)

    

##### 参数设置

> version
>
> 模块版本号，相当于module.prop的version变量



> update_date
>
> 模块精简列表更新日期，会自动加入模块描述



> enable_zram
>
> Zram调整配置，默认启用，0为关闭，1为开启



> enable_prefetch
>
> 预读调整为128kb，默认启用，0为关闭，1为开启
