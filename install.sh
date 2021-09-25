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
# 可编辑文件 命名为*.sh是为了编辑/查看时一目了然
Compatible_with_older_versions="$(cat ${TMPDIR}/common/兼容精简.sh)"
Package_Name_Reduction="$(cat ${TMPDIR}/common/包名精简.sh)"

run_one() {
  ui_print " "
  ui_print "----------[ Run: 兼容精简 ]"
  echo "- $(date '+%Y/%m/%d %T'): [兼容精简]" >> ${MODPATH}/log.md
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
            echo "[${num}] REPLACE: ${i}/.replace" >> ${MODPATH}/log.md
            ;;
        esac
      done
    fi
  done
  echo "- [done]" >> ${MODPATH}/log.md
  ui_print "----------[ done ]"
  ui_print " "
}

run_two() {
  ui_print " "
  ui_print "----------[ Run: 包名精简 ]"
    echo "- $(date '+%Y/%m/%d %T'): [包名精简]" >> ${MODPATH}/log.md
    appinfo -d " " -o ands,pn -pn ${Package_Name_Reduction} 2>/dev/null | while read line; do
    app_1="$(echo ${line} | awk '{print $1}')"
    app_2="$(echo ${line} | awk '{print $2}')"
    app_path="$(pm path ${app_2} | grep -v '/data/app/' | sed 's/package://g')"
    File_Dir="${MODPATH}${app_path%/*}"
    [ -z "${app_path}" ] && echo "[!] >> ${app_1} << 为data应用: 或是经过应用商店更新"
    if [ ! -d "$File_Dir" ]; then
      num="$(($num+1))"
      echo "- ${num}.REPLACE: ${app_1} (${app_2})"
      set_mktouch_authority "${File_Dir}"
      echo "名称:(${app_1})" >> ${MODPATH}/log.md
      echo "包名:(${app_2})" >> ${MODPATH}/log.md
      echo "原始路径: ${app_path}" >> ${MODPATH}/log.md
      echo "模块路径: $(echo ${File_Dir} | sed 's/modules_update/modules/g')" >> ${MODPATH}/log.md
      echo "" >> ${MODPATH}/log.md
    fi
  done
  [ -d "${MODPATH}/product" ] && mv ${MODPATH}/product ${MODPATH}/system/
  [ -d "${MODPATH}/system_ext" ] && mv ${MODPATH}/system_ext ${MODPATH}/system/
  echo "- [done]" >> ${MODPATH}/log.md
  ui_print "----------[ done ]"
  ui_print " "
}

retain_the_original_path() {
  if [ "$(find /data/adb/modules*/Reducemiui -name '.replace')" != "" ]; then
    ui_print " "
    ui_print "----------[ Run: 原有路径保留 ]"
    ui_print "- [&]: 已安装过模块 重新刷模块会保留原有精简路径"
    Already_exists="$(find /data/adb/modules*/Reducemiui -name '.replace' | awk -F '/.replace' '{print $1}' | awk -F '/system/' '{print $2}')"
    log_md="$(find /data/adb/modules*/Reducemiui -name 'log.md')"
    cp -r ${log_md} ${MODPATH}
    echo "- $(date '+%Y/%m/%d %T'): [原有路径保留]" >> ${MODPATH}/log.md
    for original_path in ${Already_exists}
    do
      num="$(($num+1))"
      ui_print "- ${num}.REPLACE: /system/${original_path}"
      echo "[${num}] update: /system/${original_path}/.replace" >> ${MODPATH}/log.md
      set_mktouch_authority "${MODPATH}/system/${original_path}"
    done
    echo "- [done]" >> ${MODPATH}/log.md
    ui_print "----------[ done ]"
    ui_print " "
  fi
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

inspect_file() {
  tools_path="${TMPDIR}/common/tools"
  [ ! -e "${tools_path}/appinfo" ] && abort "- 缺少必备文件: appinfo"
  [ ! -e "${tools_path}/appinfo.dex" ] && abort "- 缺少必备文件: appinfo.dex"
}

change_env() {
  bin_path="/data/adb/Reducemiui_bin"
  [ ! -d "${bin_path}" ] && mkdir -p ${bin_path}
  rm -rf ${bin_path}/* >/dev/null
  cp -r ${tools_path}/appinfo* ${bin_path}
  chmod 0777 ${bin_path}/*
  export PATH="${bin_path}:${PATH}"
}

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
  echo -e "\nversion=$version" >> $TMPDIR/module.prop
}

clean_wifi_logs() {
  if [ $is_clean_logs = true ]; then
    ui_print "- 正在停止tcpdump"
    stop tcpdump
    ui_print "- 正在停止cnss_diag"
    stop cnss_diag
    ui_print "- 正在停止logd"
    stop logd
    ui_print "- 正在清除MIUI WiFi log"
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
  dex2ota_list="
  com.miui.home
  com.android.settings
  com.miui.notification
  com.android.systemui
  com.miui.miwallpaper
  com.xiaomi.misettings
  com.miui.personalassistant"
  ui_print "- 为保障流畅，执行dex2ota(Everything)优化，需要一点时间..."
  for app_list in ${dex2ota_list}
  do
    cmd package compile -m everything ${app_list} >/dev/null && echo "- ${app_list}: Success"
  done
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
retain_the_original_path
run_one
run_two
