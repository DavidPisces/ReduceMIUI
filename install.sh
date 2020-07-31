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
version="3.0-PreviewDemo"
# 模块精简列表更新日期
update_date="20.7.31"
# Zram调整配置(默认关闭)
enable_zram=false
# SDK判断
sdk=`grep_prop ro.build.version.sdk`
min_sdk=29
Enable_determination=false
# 精简列表
REPLACE="
/system/app/AnalyticsCore
/system/app/AutoRegistration
/system/app/BackupAndRestore
/system/app/BasicDreams
/system/app/BookmarkProvider
/system/app/CarrierDefaultApp
/system/app/com.miui.qr
/system/app/FidoAuthen
/system/app/FidoClient
/system/app/GooglePrintRecommendationService
/system/app/greenguard
/system/app/KSICibaEngine
/system/app/mab
/system/app/MiuiDaemon
/system/app/MiuiVpnSdkManager
/system/app/MSA
/system/app/QColor
/system/app/Stk
/system/app/TranslationService
/system/app/YouDaoEngine
/system/priv-app/MiGameCenterSDKService
/system/priv-app/MiRcs
/system/priv-app/MiService
/system/priv-app/MusicFX
/system/priv-app/ONS
/system/priv-app/PackageInstaller
/system/priv-app/UserDictionaryProvider
/system/product/app/datastatusnotification
/system/product/app/PhotoTable
/system/product/app/QdcmFF
/system/product/app/TrichromeLibrary
/system/product/app/xdivert
/system/product/priv-app/dpmserviceapp
/system/product/priv-app/EmergencyInfo
/system/data-app
/system/vendor/data-app
"
sdk_determination() {
  if [ $sdk -ge $min_sdk ] ; then
    ui_print "- 当前SDK为：$sdk"
  else
    abort "- 当前SDK为：$sdk，不符合要求最低SDK：$min_sdk"
	ui_print "- ! 安装终止"
  fi
}
custom_setttings(){
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
optional_uninstall(){
  ui_print "- 有些系统app更新过后会在data区驻留，所以如果出现卸载失败以实际情况为主"
  # 百度输入法小米版
  ui_print "*******************************"
  ui_print "- 请按音量键选择是否卸载[百度输入法小米版] -"
  ui_print "   [音量+]：卸载"
  ui_print "   [音量-]：保留"
  if $FUNCTION; then
     pm uninstall com.baidu.input_mi
     if [ $? = 0 ] ; then
	    ui_print "- 已成功卸载"
	 else
	    ui_print "- 卸载失败"
	 fi
  else
     ui_print "- 已保留"
  fi
  # 搜狗输入法小米版
  ui_print "*******************************"
  ui_print "- 请按音量键选择是否卸载[搜狗输入法小米版] -"
  ui_print "   [音量+]：卸载"
  ui_print "   [音量-]：保留"
  if $FUNCTION; then
     pm uninstall com.sohu.inputmethod.sogou.xiaomi
     if [ $? = 0 ] ; then
	    ui_print "- 已成功卸载"
	 else
	    ui_print "- 卸载失败"
	 fi
  else
     ui_print "- 已保留"
  fi
  # 讯飞输入法小米版
  ui_print "*******************************"
  ui_print "- 请按音量键选择是否卸载[讯飞输入法小米版] -"
  ui_print "   [音量+]：卸载"
  ui_print "   [音量-]：保留"
  if $FUNCTION; then
     pm uninstall com.iflytek.inputmethod.miui
     if [ $? = 0 ] ; then
	    ui_print "- 已成功卸载"
	 else
	    ui_print "- 卸载失败"
	 fi
  else
     ui_print "- 已保留"
  fi
  # 电子邮件
  ui_print "*******************************"
  ui_print "- 请按音量键选择是否卸载[电子邮件] -"
  ui_print "   [音量+]：卸载"
  ui_print "   [音量-]：保留"
  if $FUNCTION; then
     pm uninstall com.android.email
     if [ $? = 0 ] ; then
	    ui_print "- 已成功卸载"
	 else
	    ui_print "- 卸载失败"
	 fi
  else
     ui_print "- 已保留"
  fi
  # 小米换机
  ui_print "*******************************"
  ui_print "- 请按音量键选择是否卸载[小米换机] -"
  ui_print "   [音量+]：卸载"
  ui_print "   [音量-]：保留"
  if $FUNCTION; then
     pm uninstall com.miui.huanji
     if [ $? = 0 ] ; then
	    ui_print "- 已成功卸载"
	 else
	    ui_print "- 卸载失败"
	 fi
  else
     ui_print "- 已保留"
  fi
  # 小米金融
  ui_print "*******************************"
  ui_print "- 请按音量键选择是否卸载[小米金融] -"
  ui_print "   [音量+]：卸载"
  ui_print "   [音量-]：保留"
  if $FUNCTION; then
     pm uninstall com.xiaomi.jr
     if [ $? = 0 ] ; then
	    ui_print "- 已成功卸载"
	 else
	    ui_print "- 卸载失败"
	 fi
  else
     ui_print "- 已保留"
  fi
  # 小米有品
  ui_print "*******************************"
  ui_print "- 请按音量键选择是否卸载[小米有品] -"
  ui_print "   [音量+]：卸载"
  ui_print "   [音量-]：保留"
  if $FUNCTION; then
     pm uninstall com.xiaomi.youpin
     if [ $? = 0 ] ; then
	    ui_print "- 已成功卸载"
	 else
	    ui_print "- 卸载失败"
	 fi
  else
     ui_print "- 已保留"
  fi
  # 游戏中心
  ui_print "*******************************"
  ui_print "- 请按音量键选择是否卸载[游戏中心] -"
  ui_print "   [音量+]：卸载"
  ui_print "   [音量-]：保留"
  if $FUNCTION; then
     pm uninstall com.xiaomi.gamecenter
     if [ $? = 0 ] ; then
	    ui_print "- 已成功卸载"
	 else
	    ui_print "- 卸载失败"
	 fi
  else
     ui_print "- 已保留"
  fi
  #小米画报
  ui_print "*******************************"
  ui_print "- 请按音量键选择是否卸载[小米画报] -"
  ui_print "   [音量+]：卸载"
  ui_print "   [音量-]：保留"
  if $FUNCTION; then
     pm uninstall com.mfashiongallery.emag
     if [ $? = 0 ] ; then
	    ui_print "- 已成功卸载"
	 else
	    ui_print "- 卸载失败"
	 fi
  else
     ui_print "- 已保留"
  fi
  # 小米直播助手
  ui_print "*******************************"
  ui_print "- 请按音量键选择是否卸载[小米直播助手] -"
  ui_print "   [音量+]：卸载"
  ui_print "   [音量-]：保留"
  if $FUNCTION; then
     pm uninstall com.mi.liveassistant
     if [ $? = 0 ] ; then
	    ui_print "- 已成功卸载"
	 else
	    ui_print "- 卸载失败"
	 fi
  else
     ui_print "- 已保留"
  fi
  # 百度地图
  ui_print "*******************************"
  ui_print "- 请按音量键选择是否卸载[百度地图] -"
  ui_print "   [音量+]：卸载"
  ui_print "   [音量-]：保留"
  if $FUNCTION; then
     pm uninstall com.baidu.BaiduMap
     if [ $? = 0 ] ; then
	    ui_print "- 已成功卸载"
	 else
	    ui_print "- 卸载失败"
	 fi
  else
     ui_print "- 已保留"
  fi
  # 阅读
  ui_print "*******************************"
  ui_print "- 请按音量键选择是否卸载[阅读] -"
  ui_print "   [音量+]：卸载"
  ui_print "   [音量-]：保留"
  if $FUNCTION; then
     pm uninstall com.duokan.reader
     if [ $? = 0 ] ; then
	    ui_print "- 已成功卸载"
	 else
	    ui_print "- 卸载失败"
	 fi
  else
     ui_print "- 已保留"
  fi
  #  美团
  ui_print "*******************************"
  ui_print "- 请按音量键选择是否卸载[美团] -"
  ui_print "   [音量+]：卸载"
  ui_print "   [音量-]：保留"
  if $FUNCTION; then
     pm uninstall com.sankuai.meituan
     if [ $? = 0 ] ; then
	    ui_print "- 已成功卸载"
	 else
	    ui_print "- 卸载失败"
	 fi
  else
     ui_print "- 已保留"
  fi
  # 腾讯视频
  ui_print "*******************************"
  ui_print "- 请按音量键选择是否卸载[腾讯视频] -"
  ui_print "   [音量+]：卸载"
  ui_print "   [音量-]：保留"
  if $FUNCTION; then
     pm uninstall com.tencent.qqlive
     if [ $? = 0 ] ; then
	    ui_print "- 已成功卸载"
	 else
	    ui_print "- 卸载失败"
	 fi
  else
     ui_print "- 已保留"
  fi
  # 万能遥控
  ui_print "*******************************"
  ui_print "- 请按音量键选择是否卸载[万能遥控] -"
  ui_print "   [音量+]：卸载"
  ui_print "   [音量-]：保留"
  if $FUNCTION; then
     pm uninstall com.duokan.phone.remotecontroller
     if [ $? = 0 ] ; then
	    ui_print "- 已成功卸载"
	 else
	    ui_print "- 卸载失败"
	 fi
  else
     ui_print "- 已保留"
  fi
  # CatchLog
  ui_print "*******************************"
  ui_print "- 请按音量键选择是否卸载[CatchLog] -"
  ui_print "   说明：记录手机崩溃日志"
  ui_print "   [音量+]：卸载"
  ui_print "   [音量-]：保留"
  if $FUNCTION; then
     pm uninstall com.bsp.catchlog
     if [ $? = 0 ] ; then
	    ui_print "- 已成功卸载"
	 else
	    ui_print "- 卸载失败"
	 fi
  else
     ui_print "- 已保留"
  fi
  # 证书安装程序
  ui_print "*******************************"
  ui_print "- 请按音量键选择是否卸载[证书安装程序] -"
  ui_print "   说明：安装相关证书，比如抓包软件的证书等"
  ui_print "   [音量+]：卸载"
  ui_print "   [音量-]：保留"
  if $FUNCTION; then
     pm uninstall com.android.certinstaller
     if [ $? = 0 ] ; then
	    ui_print "- 已成功卸载"
	 else
	    ui_print "- 卸载失败"
	 fi
  else
     ui_print "- 已保留"
  fi
  # CIT
  ui_print "*******************************"
  ui_print "- 请按音量键选择是否卸载[CIT] -"
  ui_print "   说明：连续点击内核版本出现检测工具"
  ui_print "   [音量+]：卸载"
  ui_print "   [音量-]：保留"
  if $FUNCTION; then
     pm uninstall com.miui.cit
     if [ $? = 0 ] ; then
	    ui_print "- 已成功卸载"
	 else
	    ui_print "- 卸载失败"
	 fi
  else
     ui_print "- 已保留"
  fi
  # ARCore
  ui_print "*******************************"
  ui_print "- 请按音量键选择是否卸载[ARCore] -"
  ui_print "   说明：用于AR相机类app"
  ui_print "   [音量+]：卸载"
  ui_print "   [音量-]：保留"
  if $FUNCTION; then
     pm uninstall com.google.ar.core
     if [ $? = 0 ] ; then
	    ui_print "- 已成功卸载"
	 else
	    ui_print "- 卸载失败"
	 fi
  else
     ui_print "- 已保留"
  fi
  # 悬浮球
  ui_print "*******************************"
  ui_print "- 请按音量键选择是否卸载[悬浮球] -"
  ui_print "   说明：系统内的悬浮球"
  ui_print "   [音量+]：卸载"
  ui_print "   [音量-]：保留"
  if $FUNCTION; then
     pm uninstall com.miui.touchassistant
     if [ $? = 0 ] ; then
	    ui_print "- 已成功卸载"
	 else
	    ui_print "- 卸载失败"
	 fi
  else
     ui_print "- 已保留"
  fi
}

on_install(){
  ui_print "- 提取模块文件"
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
}
on_install
ui_print "*******************************"
ui_print "  "
ui_print "  Reduce MIUI Project"
ui_print "  "
ui_print "*******************************"
custom_setttings
#banlist
auto_uninstall_AD_apps
# 可选安装
optional_uninstall