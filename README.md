# MIUI精简计划
# Reduce MIUI Project

##### 这是一个Magisk模块，适用于国内版MIUI  

######  特点：在不影响正常功能情况下尽可能精简系统进程

[作者酷安主页(@雄氏老方)](http://www.coolapk.com/u/665894)

[English version README](https://github.com/DavidPisces/ReduceMIUI/blob/master/README_en.md)

##### 主要功能 ：

- 精简系统进程，可以根据精简配置自行调整

- 移除部分MIUI系统日志

- 自动冻结MSA Analytics，剔除Analytics

- 自动以Everything模式优化App，可以根据配置文件自行调整

- 使用hosts屏蔽Analytics发送数据的部分域名

  ###### 以下是模块的参数调整和注意事项


##### 注意事项
  
* 模块的主要调整参数在install.sh,修改install.sh的各种参数即可，module.prop由install.sh自动生成



##### 参数设置

以下参数均在install.sh

> module_id
> 模块的id，可自定义

> module_name
> 模块的名称，在Magisk内显示的名称

> module_author
> 模块的作者

> module_minMagisk
> 模块所需要的最小Magisk版本

> module_description
> 模块在Magisk页面的描述

> version
> 模块版本号，相当于module.prop的version变量

> update_date
> 模块更新日期，会自动加入模块描述



 * 在以下参数中true为开启，false为关闭

> is_clean_logs
>
> 启用移除MIUI日志

> is_use_hosts
>
> 使用hosts文件屏蔽Analytics域名，如果您有使用屏蔽广告类模块，请将其设置为false，如果您使用该功能，可能导致小米主题之类的服务无法加载预览图


##### 配置文件介绍

以下文件均在模块的common目录，如果您发现精简部分组件出现问题，可以根据这些配置文件进行调整

shell知识：#号代表注释，即当前行不会生效，如果您需要精简某一应用，删除该应用包名前的#号即可，相应的应用我们都有写注释，当然一部分系统应用也标注了作用

- 包名精简.prop

  这里包含最基本的精简列表，可以根据包名自动查找目录并精简系统应用，对于给出的列表，删掉#保存刷入生效，未给出的系统应用，您可以自行另起一行加上该应用包名，保存后刷入生效


- 兼容精简.prop

  这里包含部分旧版MIUI的应用，如果您使用旧版MIUI或者是包名精简未起作用，请在此文件内另起一行加入该系统应用的具体路径


- dex2oat.prop
  
  这里包含安装模块时默认进行dex2oat的应用包名，可以根据需求自己修改，可以加入但不限于系统app，也可以加入用户app，默认使用Everything模式进行优化，开机后也会根据此文件中包名列表进行dex2oat优化（Everything模式占用空间较大，优化时间较长，最流畅），当然一次性优化编译过多的App会带来发热，所以默认列表仅部分MIUI系统App


- hosts.txt
  
  此文件为hosts功能默认配置文件，如果您启用hosts文件功能，模块会自动查找是否存在有其他hosts模块并自动处理，以保证最大兼容性

