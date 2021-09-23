# MIUI精简计划
# Reduce MIUI Project

##### 这是一个Magisk模块，适用于国内版MIUI  
##### This is a Magisk Moudle For Chinese version MIUI

######  特点：在不影响正常功能情况下尽可能精简系统进程
###### Features: Streamline system processes as much as possible without affecting normal functions

[下载地址Download(Releases)](https://github.com/l2642235863/ReduceMIUI/releases)

[作者酷安主页(@雄氏老方)](http://www.coolapk.com/u/665894)

##### 主要功能 Function：

- 精简系统进程
- Remove a part of system app

- 移除部分MIUI系统日志
- Remove a part of miui logs

- 自动冻结MSA Analytics

- 自动以Everything模式优化桌面

- 屏蔽Analytics发送数据的部分域名

  ###### 以下是模块的参数调整和注意事项
  ###### These are variables for the module and precautions

  ##### 注意事项
  
  * 模块的主要调整在install.sh,修改install.sh的各种参数即可，module.prop由install.sh自动生成




##### 参数设置

> module_id
>
> 模块的id，可自定义
>
> module_name
>
> 模块的名称，在Magisk内显示的名称
>
> module_author
>
> 模块的作者
>
> module_minMagisk
>
> 模块所需要的最小Magisk版本
>
> module_description
>
> 模块在Magisk页面的描述
>
> version
>
> 模块版本号，相当于module.prop的version变量
>
> update_date
>
> 模块精简列表更新日期，会自动加入模块描述



> * 在以下参数中true为开启，false为关闭
>
> min_sdk
>
> Android版本判断要求最小SDK
>
> Enable_determination
>
> Android判断配置
>
> is_clean_logs
>
> 启用移除MIUI日志