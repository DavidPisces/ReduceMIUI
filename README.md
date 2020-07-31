# MIUI精简计划
# Reduce MIUI Project

##### 这是一个Magisk模块，适用于国内版MIUI  
##### This is a Magisk Moudle For Chinese version MIUI

######  特点：在不影响正常功能情况下尽可能精简系统进程
###### Features: Streamline system processes as much as possible without affecting normal functions
#####  精简名单（必删）如下：
###### AnalyticsCore
###### AutoRegistration
###### BackupAndRestore
###### BasicDreams
###### BookmarkProvider
###### CarrierDefaultApp
###### com.miui.qr
###### FidoAuthen
###### FidoClient
###### GooglePrintRecommendationService
###### greenguard
###### KSICibaEngine
###### mab
###### MiuiDaemon
###### MiuiVpnSdkManager
###### MSA
###### QColor
###### Stk
###### TranslationService
###### YouDaoEngine
###### PackageInstaller
###### MiGameCenterSDKService
###### MiRcs
###### MiService
###### MusicFX
###### ONS
###### UserDictionaryProvider
###### datastatusnotification
###### PhotoTable
###### QdcmFF
###### TrichromeLibrary
###### xdivert
###### dpmserviceapp
###### EmergencyInfo

#####  精简名单（可选卸载）如下：
###### 百度输入法小米版
###### 电子邮件
###### 讯飞输入法小米版
###### 小米换机
###### 小米金融
###### 小米有品
###### 游戏中心
###### 小米画报
###### 小米直播助手
###### 百度地图
###### 阅读
###### 美团
###### 腾讯视频
###### 万能遥控
###### CatchLog
###### 证书安装程序
###### CIT
###### ARCore
###### 搜狗输入法小米版
###### 悬浮球

[下载地址Download(Releases)](https://github.com/l2642235863/ReduceMIUI/releases)

[作者酷安主页(@雄氏老方)](http://www.coolapk.com/u/665894)

##### 主要功能 Function：

- 精简系统进程
- Remove a part of system app

- 调整MIUI的Zram上限和使用
- Adjust MIUI zram

  ###### 以下是模块的参数调整和注意事项
  ###### These are variables for the module and precautions

  ##### 注意事项
  
  * 模块的主要调整在install.sh,修改install即可,不要对模块的module.prop做过多修改,可能导致脚本出现问题
    
    例如：

    * 随意增添空行
    * 重复增加version=xx 版本号

  * 模块的版本号是由install.sh自动写入，无需在module.prop重复手动加入

  * 模块默认调整Zram上限是2801，有需要请自行调整mcd_default.conf(个人不建议在大内存手机上使用)



##### 参数设置

> version
>
> 模块版本号，相当于module.prop的version变量



> update_date
>
> 模块精简列表更新日期，会自动加入模块描述



> * true为开启，false为关闭

> enable_zram
>
> Zram调整配置，默认关闭。

> min_sdk
>
> Android版本判断要求最小SDK
>
> Enable_determination
>
> Android判断配置