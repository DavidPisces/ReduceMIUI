AUTOMOUNT=true
PROPFILE=false
POSTFSDATA=ture
LATESTARTSERVICE=true
# 模块版本号
version="2.0.1 Extreme Beta"
# 模块精简列表更新日期
update_date="11.30"
# Zram调整配置(默认关闭)
enable_zram="0"
# 预读调整(默认启用)
enable_prefetch="1"
# 自选模式(使用shell冻结)
enable_mode2="1"
print_modname() {
  ui_print "*******************************"
  ui_print "          MIUI精简计划   "
  ui_print "        Made by 雄氏老方"
  ui_print "            Extreme "
  ui_print "*******************************"
}
costom_delete(){
# 写入service.sh，使用循环执行，以防抽风
 echo -e "\nwhile true; do" >> $INSTALLER/common/service.sh
# 自选模式
if [ $enable_mode2 = "1" ]; then
	ui_print "- 请按音量键选择是否冻结[浏览器] -"
    ui_print "   [音量+]：冻结"
    ui_print "   [音量-]：放弃"
	# 浏览器
    if $FUNCTION; then
	    echo -e "\npm disable com.android.browser" >>$INSTALLER/common/service.sh
	    num=1
	    ui_print "   [浏览器]冻结成功。"
    else
	    ui_print "   [浏览器]未冻结。"
    fi
	#内容中心
	ui_print "- 请按音量键选择是否冻结[内容中心] -"
    ui_print "   [音量+]：冻结"
    ui_print "   [音量-]：放弃"
    if $FUNCTION; then
	    echo -e "\npm disable com.miui.newhome" >>$INSTALLER/common/service.sh
	    num=1
	    ui_print "   [内容中心]冻结成功。"
    else
	    ui_print "   [内容中心]未冻结。"
    fi
	#小米音乐
	ui_print "- 请按音量键选择是否冻结[小米音乐] -"
    ui_print "   [音量+]：冻结"
    ui_print "   [音量-]：放弃"
	if $FUNCTION; then
	    echo -e "\npm disable com.miui.player" >>$INSTALLER/common/service.sh
	    num=1
	    ui_print "   [小米音乐]冻结成功。"
    else
	    ui_print "   [小米音乐]未冻结。"
    fi
	#小米视频
	ui_print "- 请按音量键选择是否冻结[浏小米视频] -"
    ui_print "   [音量+]：冻结"
    ui_print "   [音量-]：放弃"
	if $FUNCTION; then
	    echo -e "\npm disable com.miui.video" >>$INSTALLER/common/service.sh
	    num=1
	    ui_print "   [小米视频]冻结成功。"
    else
	    ui_print "   [小米视频]未冻结。"
    fi
else
 ui_print "- 没有使用自选冻结模式，跳过此部分"
fi
}
# 自定义配置
costom_setttings(){
# 预读大小调整(128kb)
  if [ $enable_prefetch = "1" ] ; then
	 echo -e "sleep 7 \nchmod 775 /sys/block/mmcblk0/queue/read_ahead_kb \nchmod 775 /sys/block/mmcblk0/queue/iostats \necho '128' > /sys/block/mmcblk0/queue/read_ahead_kb \necho '0' > /sys/block/mmcblk0/queue/iostats \necho '0' > /sys/block/sda/queue/iostats \necho '128' > /sys/block/sda/queue/read_ahead_kb" >> $INSTALLER/common/service.sh
  else
     ui_print ""
  fi
# 写入更新日期
  echo -n "$update_date" >>$INSTALLER/module.prop

# Zram调整配置
  if [ $enable_zram = "0" ] ; then
    rm -f $INSTALLER/system/etc/mcd_default.conf
  else
    echo -n "(已启用Zram调整)" >> $INSTALLER/module.prop
  fi
# 写入版本号和配置
  echo -e "\nversion=$version" >>$INSTALLER/module.prop
  echo -e "\ndone" >> $INSTALLER/common/service.sh
}
REPLACE="
/system/app/systemAdSolution
/system/app/MSA-CN-NO_INSTALL_PACKAGE
/system/app/mab
/system/app/MSA
/system/app/AnalyticsCore
/system/app/CarrierDefaultApp
/system/app/talkback
/system/app/TouchAssistant
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
/system/app/PrintSpooler
/system/app/PrintRecommendationService
/system/app/SeempService
/system/app/com.miui.qr
/system/app/Traceur
/system/app/GPSLogSave
/system/app/SystemHelper
/system/app/Stk
/system/app/SYSOPT
/system/app/WMService
/system/app/xdivert
/system/app/CertInstaller
/system/app/MiuiDaemon
/system/app/Qmmi
/system/app/QdcmFF
/system/app/Xman
/system/app/Yman
/system/app/ModemLog
/system/app/seccamsample
/system/app/MiWallpaper
/system/app/MiPlayClient
/system/app/greenguard
/system/priv-app/MiRcs
/system/priv-app/MiGameCenterSDKService
/system/app/TranslationService
/system/priv-app/MiuiFreeformService
/system/priv-app/dpmserviceapp
/system/priv-app/EmergencyInfo
/system/data-app
/system/vendor/data-app
"
set_permissions() {
  set_perm_recursive  $MODPATH  0  0  0755  0644
}