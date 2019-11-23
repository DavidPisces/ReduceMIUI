AUTOMOUNT=true
PROPFILE=false
POSTFSDATA=ture
LATESTARTSERVICE=true
# 模块版本号
version="1.9.13 Extreme Beta"
# 模块精简列表更新日期
update_date="11.23"
# Zram调整配置(默认启用)
enable_zram="1"
# 预读调整(默认启用)
enable_prefetch="1"
print_modname() {
  ui_print "*******************************"
  ui_print "          MIUI精简计划   "
  ui_print "        Made by 雄氏老方"
  ui_print "            Extreme "
  ui_print "*******************************"
}
# 自定义配置
costom_setttings(){
# 预读大小调整(128kb)
  if [ $enable_prefetch = "1" ] ; then
	 echo -e "sleep 9 \nchmod 775 /sys/block/mmcblk0/queue/read_ahead_kb \nchmod 775 /sys/block/mmcblk0/queue/iostats \nwhile true; do \necho '128' > /sys/block/mmcblk0/queue/read_ahead_kb \necho '0' > /sys/block/mmcblk0/queue/iostats \necho '0' > /sys/block/sda/queue/iostats \necho '128' > /sys/block/sda/queue/read_ahead_kb \ndone" >> $INSTALLER/common/service.sh
  else
     ui_print ""
  fi
# 写入更新日期
  echo -n "11.23" >>$INSTALLER/module.prop

# Zram调整配置
  if [ $enable_zram = "0" ] ; then
    rm -f $INSTALLER/system/etc/mcd_default.conf
  else
    echo -n "(已启用Zram调整)" >> $INSTALLER/module.prop
  fi
# 写入版本号
  echo -e "\nversion=$version" >>$INSTALLER/module.prop
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
/syatem/app/PrintRecommendationService
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
/system/priv-app/ExternalStorageProvider
"
set_permissions() {
  set_perm_recursive  $MODPATH  0  0  0755  0644
}