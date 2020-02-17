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

  * 模块的版本号是由install.sh自动写入，无需在module.prop重复手动加入

  * 模块默认调整Zram上限是2801，有需要请自行调整mcd_default.conf(个人不建议在大内存手机上使用)



##### 更新日志

> 20.2.17 （2.14）
>
> 恢复MiuiFreeformService，以防窗口模式不能调整程序大小， 感谢酷安@星夜StarryNight反馈
> 
> 降低Magisk要求版本到19

> 20.2.15 （2.13）
>
> 精简列表增加若干....就不一一列举了
>
> 增加安装脚本Zram是否启用的输出提示

> 20.2.14  (2.12-Magisk20.3+)
>
> 精简列表增加：ons 搜狗拼音输入法 耗电检测 电量与性能
>
> Zram配置下调至2801
>
> (ps：不会影响进入耗电统计，旧版MIUI会受影响)
> 使用搜狗小米版的会输入法消失

> 20.2.12 （2.11-Magisk20.3+）
>
> 增加/system/product下部分app精简
>
> 精简列表调整



> 20.2.8 (2.1.2-Magisk20.3+)
>
> 精简列表新增QColor 服务与反馈
>
> 支持Wifi Log自动删除 （小米MIX2s）



>20.1.26 （2.1.1-Magisk20.3+）
>
>正式适配20.3+
>
>重新调整配置文件，Zram调节和预读调节重新加入
>
>基于@柚稚的孩纸的模板适配，非常感谢
>
>配置参数见下文
>
>（冻结功能未上线)



>20.1.25 （2.1-Magisk20.3+）
>准备重写
>
>目前已经适配Magisk20.3+，暂时下线所有除精简外的功能
>
>这个版本只支持精简和Zram调整，Zram调整默认开启
>
>感谢@柚稚的孩纸 的帮助



> 11.29 (2.0.1-Magisk19以下)
>
> 1.增加自选模式，采用shell冻结方式，使用service.sh开机自动执行冻结
>
> 2.修复调用文件管理不显示内置存储
>
> 3.调整脚本的写入顺序
>
> 4.精简列表调整
>
> 5.默认关闭Zram调整

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
> /system/app/TouchAssistant
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
> /system/app/CatchLog
>
> /system/app/CertInstaller
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
> /system/app/MiuiBugReport
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
> /system/app/WMService
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
> /system/app/ModemLog
>
> /system/app/seccamsample
>
> /system/app/MiWallpaper
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
> /system/priv-app/MiuiFreeformService
>
> /system/priv-app/dpmserviceapp
>
> /system/priv-app/EmergencyInfo
>
> /system/priv-app/MiService
>
> /system/priv-app/UserDictionaryProvider
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
>
> /system/app/SogouInput
>
> /system/app/PowerKeeper
>
> /system/app/PowerChecker

