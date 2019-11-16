AUTOMOUNT=true
PROPFILE=false
POSTFSDATA=ture
LATESTARTSERVICE=true
version="1.9.12 Extreme Beta"
print_modname() {
  ui_print "*******************************"
  ui_print "          MIUI精简计划   "
  ui_print "        Made by 雄氏老方"
  ui_print "            Extreme "
  ui_print "*******************************"
  echo -e "\n" >>$INSTALLER/module.prop
  echo -n "version=$version" >>$INSTALLER/module.prop
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
/system/priv-app/MiuiAod
/system/priv-app/MiuiFreeformService
/system/priv-app/dpmserviceapp
/system/priv-app/EmergencyInfo
/system/priv-app/ExternalStorageProvider
"
set_permissions() {
  set_perm_recursive  $MODPATH  0  0  0755  0644
}