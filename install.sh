# ReduceMIUI 精简计划 配置文件
# Made by @雄氏老方
# 跳过挂载
SKIPMOUNT=false
# 如果您需要加载system.prop，请将其设置为true
PROPFILE=false
# 如果您需要post-fs-data脚本（post-fs-data.sh），请将其设置为true
POSTFSDATA=true
# 如果您需要late_start服务脚本（service.sh），请将其设置为true
LATESTARTSERVICE=true
# 模块版本号
version="2.19"
# 模块精简列表更新日期
update_date="20.5.8 PM 10:42"
# Zram调整配置(默认关闭)
enable_zram=false
# SDK判断
sdk=`grep_prop ro.build.version.sdk`
min_sdk=29
Enable_determination=false
# 精简列表
REPLACE="
/system/app/systemAdSolution
/system/app/mab
/system/app/MSA
/system/app/MSA-CN-NO_INSTALL_PACKAGE
/system/app/AnalyticsCore
/system/app/CarrierDefaultApp
/system/app/talkback
/system/app/PrintSpooler
/system/app/PhotoTable
/system/app/BuiltInPrintService
/system/app/BasicDreams
/system/app/mid_test
/system/app/MiuiVpnSdkManager
/system/app/BookmarkProvider
/system/app/BuiltInPrintService
/system/app/CarrierDefaultApp
/system/app/FidoAuthen
/system/app/FidoClient
/system/app/FidoCryptoService
/system/app/YouDaoEngine
/system/app/AutoTest
/system/app/AutoRegistration
/system/app/KSICibaEngine
/system/app/MiuiDaemon
/system/app/PrintSpooler
/system/app/PrintRecommendationService
/system/app/SeempService
/system/app/com.miui.qr
/system/app/Traceur
/system/app/GPSLogSave
/system/app/SystemHelper
/system/app/Stk
/system/app/SYSOPT
/system/app/xdivert
/system/app/MiuiDaemon
/system/app/Qmmi
/system/app/QdcmFF
/system/app/Xman
/system/app/Yman
/system/app/seccamsample
/system/app/MiPlayClient
/system/app/greenguard
/system/app/QColor
/system/priv-app/MiRcs
/system/priv-app/MiGameCenterSDKService
/system/app/TranslationService
/system/priv-app/dpmserviceapp
/system/priv-app/EmergencyInfo
/system/priv-app/MiService
/system/priv-app/UserDictionaryProvider
/system/priv-app/ONS
/system/priv-app/MusicFX
/system/product/app/datastatusnotification
/system/product/app/PhotoTable
/system/product/app/QdcmFF
/system/product/app/talkback
/system/product/app/xdivert
/system/product/priv-app/dpmserviceapp
/system/product/priv-app/EmergencyInfo
/system/product/priv-app/seccamservice
/system/data-app
/system/vendor/data-app
/vendor/app/GFManager/
/vendor/app/GFTest/
"
sdk_determination() {
  if [ $sdk -ge $min_sdk ] ; then
    ui_print "- 当前SDK为：$sdk"
  else
    abort "- 当前SDK为：$sdk，不符合要求最低SDK：$min_sdk"
	ui_print "- ! 安装终止"
  fi
}
costom_setttings(){
# 版本判断启用配置
  if [ $Enable_determination = true ] ; then
    sdk_determination
  fi
# 写入更新日期
  echo -n "$update_date" >> $TMPDIR/module.prop
# Zram调整配置
  if [ $enable_zram = false ] ; then
    rm -f /data/adb/modules_update/Reducemiui/system/etc/mcd_default.conf
	ui_print "- Zram配置未启用，若使用配置文件请修改模块配置文件install.sh"
  else
    echo -n "(已启用Zram调整)" >> $TMPDIR/module.prop
	ui_print "- Zram配置已启用，若关闭配置文件请修改模块配置文件install.sh"
  fi
# 写入版本号
  echo -e "\nversion=$version" >> $TMPDIR/module.prop
}
auto_uninstall_AD_apps(){
  pm uninstall com.miui.analytics
  ui_print "! 已清除Analytics"
  echo -e "sleep 10\npm uninstall com.miui.analytics" >> $TMPDIR/common/service.sh
# 有待添加
}
on_install(){
  ui_print "- 提取模块文件"
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
}

on_install
ui_print "  "
ui_print "  "
ui_print "  Reduce MIUI Project"
ui_print "  "
ui_print "  "
costom_setttings
auto_uninstall_AD_apps
