#!/bin/sh
# ReduceMIUI 精简计划 配置文件
# Made by @雄氏老方
# 跳过挂载
SKIPMOUNT=false
# 如果您需要加载system.prop，请将其设置为true
PROPFILE=true
# 如果您需要post-fs-data脚本（post-fs-data.sh），请将其设置为true
POSTFSDATA=false
# 如果您需要late_start服务脚本（service.sh），请将其设置为true
LATESTARTSERVICE=true
# SDK判断
sdk=$(grep_prop ro.build.version.sdk)
# 所要求最小版本
min_sdk=29
Enable_determination=false
# 禁用miui日志
is_clean_logs=true
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
/system/app/FidoAuthen
/system/app/FidoClient
/system/app/FidoCryptoService
/system/app/YouDaoEngine
/system/app/AutoTest
/system/app/AutoRegistration
/system/app/KSICibaEngine
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
/system/app/mab
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
/system/system_ext/app/PerformanceMode/
/system/system_ext/app/xdivert/
/system/system_ext/app/QdcmFF/
/system/system_ext/app/QColor/
/system/system_ext/priv-app/EmergencyInfo/
/vendor/app/GFManager/
/vendor/app/GFTest/
"
pre_install() {
  # 模块配置
  module_id=Reducemiui
  module_name="Reduce MIUI Project"
  module_author="雄氏老方"
  module_minMagisk=19000
  module_description="尽可能精简系统服务 更新日期："
  # 模块版本号
  version="2.5"
  # 模块精简列表更新日期
  update_date="21.7.29"
  ui_print "- 提取模块文件"
  touch $TMPDIR/module.prop
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
  # 写入模块信息
  echo -e "id=$module_id\nname=$module_name\nauthor=$module_author\nminMagisk=$module_minMagisk\n" >$TMPDIR/module.prop
}

custom_setttings() {
  # 版本判断启用配置
  if [ $Enable_determination = true ]; then
    if [ $sdk -ge $min_sdk ]; then
      ui_print "- 当前SDK为：$sdk"
    else
      abort "- 当前SDK为：$sdk，不符合要求最低SDK：$min_sdk"
      ui_print "- ! 安装终止"
    fi
  fi
  # 写入更新日期
  echo -n "description=$module_description$update_date" >> $TMPDIR/module.prop
  # 写入版本号
  echo -e "\nversion=$version" >>$TMPDIR/module.prop
}

clean_wifi_logs() {
  if [ $is_clean_logs = true ]; then
    ui_print "- 正在停止tcpdump"
    stop tcpdump
    echo "stop tcpdump" >/data/adb/moduce/Reducemiui/service.sh
    ui_print "- 正在停止cnss_diag"
    stop cnss_diag
    echo "stop cnss_diag" >/data/adb/moduce/Reducemiui/service.sh
    ui_print "-! 正在清除MIUI WiFi log"
    rm -rf /data/vendor/wlan_logs
    echo "rm -rf /data/vendor/wlan_logs" >/data/adb/moduce/Reducemiui/service.sh
    setprop sys.miui.ndcd off
    touch /data/adb/modules_update/Reducemiui/system.prop
    echo "sys.miui.ndcd=off" >/data/adb/modules_update/Reducemiui/system.prop
  fi
}
uninstall_useless_app() {
  ui_print "- 正在禁用智能服务"
  pm disable com.miui.systemAdSolution
  ui_print "- 正在禁用Analytics"
  pm disable com.miui.analytics
  ui_print "- 正在禁用小米商城系统组件"
  pm disable com.xiaomi.ab
}

pre_install
ui_print "  "
ui_print "  "
ui_print "  Reduce MIUI Project"
ui_print "  "
ui_print "  "
custom_setttings
clean_wifi_logs
uninstall_useless_app
