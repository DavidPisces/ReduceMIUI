# MIUI精简计划

##### 这是一个Magisk模块，适用于国内版MIUI  

######  特点：在不影响正常功能情况下尽可能精简系统进程

[下载地址(Releases)](https://github.com/l2642235863/ReduceMIUI/releases)

[作者酷安主页(@雄氏老方)](http://www.coolapk.com/u/665894)

##### 主要功能：

- 精简系统进程

- 调整MIUI的Zram上限和使用


  ###### 以下是模块的参数调整和注意事项

  ##### 注意事项

  * 模块的主要调整在install.sh,不要对模块的module.prop做过多修改，可能导致脚本出现问题

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



> enable_zram
>
> Zram调整配置，默认关闭，0为关闭，1为开启



> min_sdk
>
> Android版本判断要求最小SDK
>
> Enable_determination
>
> Android判断配置，1为开启

##### 精简列表

> /system/app/systemAdSolution
>
> /system/app/MSA-CN-NO_INSTALL_PACKAGE
>
> /system/app/mab
>
> /system/app/MSA
>
> /system/app/AnalyticsCore
>
> /system/app/CarrierDefaultApp
>
> /system/app/talkback
>
> /system/app/PrintSpooler
>
> /system/app/PhotoTable
>
> /system/app/BuiltInPrintService
>
> /system/app/BasicDreams
>
> /system/app/mid_test
>
> /system/app/MiuiVpnSdkManager
>
> /system/app/BookmarkProvider
>
> /system/app/BuiltInPrintService
>
> /system/app/CarrierDefaultApp
>
> /system/app/FidoAuthen
>
> /system/app/FidoClient
>
> /system/app/FidoCryptoService
>
> /system/app/YouDaoEngine
>
> /system/app/AutoTest
>
> /system/app/AutoRegistration
>
> /system/app/KSICibaEngine
>
> /system/app/MiuiDaemon
>
> /system/app/PrintSpooler
>
> /system/app/PrintRecommendationService
>
> /system/app/SeempService
>
> /system/app/com.miui.qr
>
> /system/app/Traceur
>
> /system/app/GPSLogSave
>
> /system/app/SystemHelper
>
> /system/app/Stk
>
> /system/app/SYSOPT
>
> /system/app/xdivert
>
> /system/app/MiuiDaemon
>
> /system/app/Qmmi
>
> /system/app/QdcmFF
>
> /system/app/Xman
>
> /system/app/Yman
>
> /system/app/seccamsample
>
> /system/app/MiPlayClient
>
> /system/app/greenguard
>
> /system/app/QColor
>
> /system/priv-app/MiRcs
>
> /system/priv-app/MiGameCenterSDKService
>
> /system/app/TranslationService
>
> /system/priv-app/dpmserviceapp
>
> /system/priv-app/EmergencyInfo
>
> /system/priv-app/MiService
>
> /system/priv-app/UserDictionaryProvider
>
> /system/priv-app/ONS
>
> /system/priv-app/MusicFX
>
> /system/app/CatcherPatch
>
> /system/product/app/datastatusnotification
>
> /system/product/app/PhotoTable
>
> /system/product/app/QdcmFF
>
> /system/product/app/talkback
>
> /system/product/app/xdivert
>
> /system/product/priv-app/dpmserviceapp
>
> /system/product/priv-app/EmergencyInfo
>
> /system/product/priv-app/seccamservice
>
> /system/data-app
>
> /system/vendor/data-app

