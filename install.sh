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
# 精简数量累计
num=0

#这里为兼容旧版MIUI，存在才创建.replace文件。
Compatible_with_older_versions="
/system/app/MSA-CN-NO_INSTALL_PACKAGE
/system/app/mid_test
/system/app/FidoCryptoService
/system/app/AutoTest
/system/app/SeempService
/system/app/GPSLogSave
/system/app/SYSOPT
/system/app/Qmmi
/system/app/Xman
/system/app/Yman
/system/app/seccamsample
/system/priv-app/dpmserviceapp
/system/product/priv-app/dpmserviceapp
/system/product/app/datastatusnotification
/system/product/priv-app/seccamservice
/system/vendor/app/GFManager
/system/vendor/app/GFTest
"


# 这里根据包名获取app的系统路径
# 这么做的好处是: 即使之后MIUI版本变更了/system/*路径，依然能准确获取其位置。
Package_Name_Reduction="
# [NEW] 2021/09/25新增 (来自老阿巴的说明: 不影响系统 可按需精简 已预先加入＃)
#====================================================
# 1.日志抓取
#com.bsp.catchlog
# 2.小米SIM卡激活服务 #(!)警告:精简后无法云同步短信/通话记录/密码管家
#com.xiaomi.simactivate.service
# 3.小米互联通信服务
#com.xiaomi.mi_connect_service
# 4.MIUI+
#com.xiaomi.mirror
# 5.用户反馈
#com.miui.bugreport
# 6.快应用
#com.miui.hybrid
#com.miui.quickappCenter.miAppStore
#com.miui.hybrid.accessory
# 7.Google通讯录
#com.google.android.syncadapters.contacts
# 8.Google 通讯录备份
#com.android.calllogbackup
# 9.万象息屏
#com.miui.aod
# 10.小米互传
#com.miui.mishare.connectivity
# 11.NFC
#com.android.nfc
# 12.小米智能卡
#com.miui.tsmclient
# 13.悬浮球
#com.miui.touchassistant
# 14.小米音乐
#com.miui.player
# 15.CIT
#com.miui.cit
# 16.MODEM测试工具
#com.xiaomi.mtb
# 17.传送门
#com.miui.contentextension
# 18.内容中心
#com.miui.newhome
# 19.生活黄页(精简后可能无法获取来电地址)
#com.miui.yellowpage
# 20.搜索
#com.android.quicksearchbox
# 21.维修模式
#com.miui.maintenancemode
# 22.小米安全键盘
#com.miui.securityinputmethod
# 23.小米闻声
#com.miui.accessibility
# 24.用户手册
#com.miui.userguide
# 25.智能助理
#com.miui.personalassistant
#====================================================

# 以下为默认精简列表
#====================================================
#Analytics
com.miui.analytics
#智能服务
com.miui.systemAdSolution
#小米商城系统组件
com.xiaomi.ab
#运营商默认应用
com.android.carrierdefaultapp
#打印处理服务
com.android.printspooler
#系统打印服务
com.android.bips
#基本互动屏保
com.android.dreams.basic
#MiuiVpnSdkManager(游戏加速器 vpn类)
com.miui.vpnsdkmanager
#系统跟踪
com.android.traceur
#Bookmark Provider(书签同步)
com.android.bookmarkprovider
#FIDO UAF1.0 ASM
com.fido.asm
#FIDO UAF1.0 Client
com.fido.xiaomi.uafclient
#Goodix指纹
com.goodix.fingerprint.setting
#小米有道翻译服务
com.miui.translation.youdao
#金山翻译服务
com.miui.translation.kingsoft
#盲猜是和金山翻译有关
com.miui.translationservice
#自动对准（集成电路工艺) [!]ps: 其实不建议精简
com.qualcomm.qti.autoregistration
#CQR
com.miui.qr
#USIM卡应用
com.android.stk
#MiuiDaemon
com.miui.daemon
#投屏
com.milink.service
#投屏服务
com.xiaomi.miplay_client
#安全守护服务
com.miui.greenguard
#智慧生活
com.miui.hybrid.accessory
#Mi RCS
com.xiaomi.mircs
#服务与反馈
com.miui.miservice
#用户字典
com.android.providers.userdictionary
#照片屏幕保护程序
com.android.dreams.phototable
#Android 无障碍套件
com.google.android.marvin.talkback
#急救信息
com.android.emergency
#SystemHelper
com.mobiletools.systemhelper
#X-Divert设置
com.qti.xdivert
#Print Service Recommendation Service@(不知道是啥)
com.google.android.printservice.recommendation
#/system/*/ONS ps: 盲猜模拟器之类
com.android.ons
#QDCM-FF ps: 高通色温调节相关
com.qti.snapdragon.qdcm_ff
#QColor ps: 盲猜饱和度/色彩类调节
com.qualcomm.qti.qcolor

#/system/priv-app/MusicFX
#MusicFX(音频均衡器/控制器) [!] ps: 不建议精简
#com.android.musicfx

#/system/*/MiGameCenterSDKService
#游戏服务 [!] ps: 不建议精简，因为部分游戏是小米账号登陆的，如果没有自带的游戏服务，是登陆不上游戏的，反而在精简掉之后还依然需要下载回游戏服务才能进行登陆。
#com.xiaomi.gamecenter.sdk.service

#/system/*/*/PerformanceMode
#性能模式 [!] ps: 游戏玩家还是不要精简吧😳
#com.qualcomm.qti.performancemode
#====================================================
"

# [NEW]
run_one() {
  ui_print " "
  ui_print "----------[ Run: 兼容精简 ]"
  ui_print "- 如果这里空空如也"
  ui_print "- 说明你不是远古版本的MIUI"
  for i in ${Compatible_with_older_versions}
  do
    if [ -d "${i}" ]; then
      apk_find="$(ls ${i})"
      for j in ${apk_find}
      do
        case ${j} in
          *.apk)
            num="$(($num+1))"
            set_mktouch_authority "${MODPATH}/${i}"
            ui_print "- ${num}.REPLACE: ${i}/.replace"
            ;;
        esac
      done
    fi
  done
  ui_print "----------[ done ]"
  ui_print " "
}

# [NEW]
run_two() {
  ui_print " "
  ui_print "----------[ Run: 包名精简 ]"
    appinfo -d " " -o ands,pn -pn ${Package_Name_Reduction} 2>/dev/null | while read line; do
    app_1="$(echo ${line} | awk '{print $1}')"
    app_2="$(echo ${line} | awk '{print $2}')"
    app_path="$(pm path ${app_2} | grep -v '/data/app/' | sed 's/package://g')"
    File_Dir="${MODPATH}${app_path%/*}"
    [ -z "${app_path}" ] && echo "[!] >> ${app_1} << 为data应用: 或是经过应用商店更新"
    if [ ! -d "${File_Dir}" ]; then
      num="$(($num+1))"
      echo "- ${num}.REPLACE: ${app_1} (${app_2})"
      set_mktouch_authority "${File_Dir}"
      echo "名称:(${app_1})" >> ${MODPATH}/log.md
      echo "包名:(${app_2})" >> ${MODPATH}/log.md
      echo "原始路径: ${app_path}" >> ${MODPATH}/log.md
      echo "模块路径: $(echo ${File_Dir} | sed 's/modules_update/modules/g')" >> ${MODPATH}/log.md
      echo "" >>${MODPATH}/log.md
    fi
  done
  echo "$(date '+%Y/%m/%d %T')" >> ${MODPATH}/log.md
  [ -d "${MODPATH}/product" ] && mv ${MODPATH}/product ${MODPATH}/system/
  [ -d "${MODPATH}/system_ext" ] && mv ${MODPATH}/system_ext ${MODPATH}/system/
  ui_print "----------[ done ]"
  ui_print " "
}

pre_install() {
  inspect_file
  # 模块配置
  module_id=Reducemiui
  module_name="Reduce MIUI Project"
  module_author="雄氏老方"
  module_minMagisk=19000
  module_description="精简系统服务，关闭部分系统日志 更新日期："
  # 模块版本号
  version="2.6"
  # 模块精简列表更新日期
  update_date="21.9.21"
  ui_print "- 提取模块文件"
  touch $TMPDIR/module.prop
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
  # 写入模块信息
  echo -e "id=$module_id\nname=$module_name\nauthor=$module_author\nminMagisk=$module_minMagisk\n" >$TMPDIR/module.prop
}

# [NEW]
inspect_file() {
  tools_path="${TMPDIR}/common/tools"
  [ ! -e "${tools_path}/appinfo" ] && abort "- 缺少必备文件: appinfo"
  [ ! -e "${tools_path}/appinfo.dex" ] && abort "- 缺少必备文件: appinfo.dex"
}

# [NEW]
change_env() {
  bin_path="/data/adb/Reducemiui_bin"
  [ ! -d "${bin_path}" ] && mkdir -p ${bin_path}
  rm -rf ${bin_path}/* >/dev/null
  cp -r ${tools_path}/appinfo* ${bin_path}
  chmod 0777 ${bin_path}/*
  export PATH="${bin_path}:${PATH}"
}

# [NEW]
set_mktouch_authority() {
  mkdir -p $1
  touch $1/.replace
  chown root:root $1/.replace
  chmod 0644 $1/.replace
}

costom_setttings() {
  # 版本判断启用配置
  if [ $Enable_determination = true ]; then
    if [ $sdk -ge $min_sdk ]; then
      ui_print "- 当前SDK为：$sdk"
    else
      abort "- 当前SDK为：$sdk，不符合要求最低SDK：$min_sdk"
      ui_print "- ! 安装终止"
    fi
  fi
  inspect_file
  change_env
  # 写入更新日期
  echo -n "description=$module_description$update_date" >> $TMPDIR/module.prop
  # 写入版本号
  echo -e "\nversion=$version" >>$TMPDIR/module.prop
}

clean_wifi_logs() {
  if [ $is_clean_logs = true ]; then
    ui_print "- 正在停止tcpdump"
    stop tcpdump
    ui_print "- 正在停止cnss_diag"
    stop cnss_diag
    ui_print "- 正在停止logd"
    stop logd
    ui_print "-! 正在清除MIUI WiFi log"
    rm -rf /data/vendor/wlan_logs/*
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
}

dex2oat_app(){
  ui_print "- 为保障流畅，正在优化系统桌面(Everything)，需要一点时间...."
  cmd package compile -m everything com.miui.home
  ui_print "- 优化完成"
}
pre_install
ui_print "  "
ui_print "  "
ui_print "  Reduce MIUI Project"
ui_print "  "
ui_print "  "
costom_setttings
clean_wifi_logs
uninstall_useless_app
dex2oat_app
run_one
run_two
