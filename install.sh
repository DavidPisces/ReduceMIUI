#!/bin/sh
# ReduceMIUI 精简计划 配置文件
# Made by @雄氏老方
# Thanks to Petit-Abba Amktiao zjw2017

# 跳过挂载
SKIPMOUNT=false
# 如果您需要加载system.prop，请将其设置为true
PROPFILE=true
# 如果您需要post-fs-data脚本（post-fs-data.sh），请将其设置为true
POSTFSDATA=false
# 如果您需要late_start服务脚本（service.sh），请将其设置为true
LATESTARTSERVICE=true
# 禁用miui日志，如果您需要抓取log，请不要开启！
is_clean_logs=true
# 禁用非必要调试服务！
is_reduce_test_services=true
# 使用hosts屏蔽小米某些ad域名
# 注意：使用该功能会导致主题商店在线加载图片出现问题
is_use_hosts=false
# 默认dex2oat优化编译模式
dex2oat_mode="everything"
# 获取系统SDK
SDK=$(getprop ro.system.build.version.sdk)
# 精简数量累计
num=0
# 可编辑文件 命名为*.prop是为了编辑/查看时一目了然
# ReduceMIUI自定义配置文件目录
Compatible_with_older_versions="$(cat ${TMPDIR}/common/兼容精简.prop | grep -v '#')"
Package_Name_Reduction="$(cat ${TMPDIR}/common/包名精简.prop | grep -v '#')"
dex2oat_list="$(cat ${TMPDIR}/common/dex2oat.prop | grep -v '#')"

# 模块信息
pre_install() {
  inspect_file
  # 模块配置
  module_id=Reducemiui
  module_name="Reduce MIUI Project"
  module_author="雄氏老方 & 阿巴酱"
  module_minMagisk=23000
  module_description="精简系统服务，关闭部分系统日志 更新日期："
  # 模块版本号
  version="2.83"
  # 模块精简列表更新日期
  update_date="21.11.18"
  ui_print "- 提取模块文件"
  touch $TMPDIR/module.prop
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
  # 写入模块信息
  echo -e "id=$module_id\nname=$module_name\nauthor=$module_author\nminMagisk=$module_minMagisk\n" >$TMPDIR/module.prop
  # 保留dex2oat.prop配置文件
  cp -r ${TMPDIR}/common/dex2oat.prop ${MODPATH}/
}

# 兼容精简
run_one() {
  ui_print " "
  ui_print "----------[ Run: 兼容精简 ]"
  echo "- $(date '+%Y/%m/%d %T'): [兼容精简]" >>${MODPATH}/log.md
  ui_print "- 如果这里空空如也"
  ui_print "- 说明你不是远古版本的MIUI"
  for i in ${Compatible_with_older_versions}; do
    if [ -d "${i}" ]; then
      apk_find="$(ls ${i})"
      for j in ${apk_find}; do
        case ${j} in
        *.apk)
          num="$((${num} + 1))"
          set_mktouch_authority "${MODPATH}/${i}"
          ui_print "- ${num}.REPLACE: ${i}/.replace"
          echo "[${num}] REPLACE: ${i}/.replace" >>${MODPATH}/log.md
          ;;
        esac
      done
    fi
  done
  echo "- [done]" >>${MODPATH}/log.md
  ui_print "----------[ done ]"
  ui_print " "
}

# 包名精简
run_two() {
  ui_print " "
  ui_print "----------[ Run: 包名精简 ]"
  echo "- $(date '+%Y/%m/%d %T'): [包名精简]" >>${MODPATH}/log.md
  appinfo -d " " -o ands,pn -pn ${Package_Name_Reduction} 2>/dev/null | while read line; do
    app_1="$(echo ${line} | awk '{print $1}')"
    app_2="$(echo ${line} | awk '{print $2}')"
    app_path="$(pm path ${app_2} | grep -v '/data/app/' | sed 's/package://g')"
    File_Dir="${MODPATH}${app_path%/*}"
    [ -z "${app_path}" ] && echo "[!] >> ${app_1} << 为data应用: 或是经过应用商店更新"
    if [ ! -d "$File_Dir" ]; then
      num="$((${num} + 1))"
      echo "- ${num}.REPLACE: ${app_1} (${app_2})"
      set_mktouch_authority "${File_Dir}"
      echo "名称:(${app_1})" >>${MODPATH}/log.md
      echo "包名:(${app_2})" >>${MODPATH}/log.md
      echo "原始路径: ${app_path}" >>${MODPATH}/log.md
      echo "模块路径: $(echo ${File_Dir} | sed 's/modules_update/modules/g')" >>${MODPATH}/log.md
      echo "" >>${MODPATH}/log.md
    fi
  done
  echo "- [done]" >>${MODPATH}/log.md
  ui_print "----------[ done ]"
  ui_print " "
  # 清理安装缓存
  rm -rf ${bin_path}
}

retain_the_original_path() {
  if [ "$(find /data/adb/modules*/Reducemiui -name '.replace')" != "" ]; then
    ui_print " "
    ui_print "----------[ Run: 原有路径保留 ]"
    ui_print "- [&]: 已安装过模块 重新刷模块会保留原有精简路径"
    Already_exists="$(find /data/adb/modules*/Reducemiui -name '.replace' | awk -F '/.replace' '{print $1}' | awk -F '/system/' '{print $2}')"
    log_md="$(find /data/adb/modules*/Reducemiui -name 'log.md')"
    cp -r ${log_md} ${MODPATH}
    echo "- $(date '+%Y/%m/%d %T'): [原有路径保留]" >>${MODPATH}/log.md
    for original_path in ${Already_exists}; do
      num="$((${num} + 1))"
      ui_print "- ${num}.REPLACE: /system/${original_path}"
      echo "[${num}] update: /system/${original_path}/.replace" >>${MODPATH}/log.md
      set_mktouch_authority "${MODPATH}/system/${original_path}"
    done
    echo "- [done]" >>${MODPATH}/log.md
    ui_print "----------[ done ]"
    ui_print " "
  fi
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

custom_settings() {
  inspect_file
  change_env
  # 写入更新日期
  echo -n "description=$module_description$update_date" >>$TMPDIR/module.prop
  # 写入版本号
  echo -e "\nversion=$version" >>$TMPDIR/module.prop
}

reduce_test_services() {
  if [ "$is_reduce_test_services" == "true" ]; then
    if [ "$SDK" == 30 ]; then
      ui_print "- 正在停止ipacm-diag"
      stop ipacm-diag
    fi
    if [ "$SDK" == 31 ]; then
      ui_print "- 正在停止ipacm-diag"
      stop vendor.ipacm-diag
    fi
  fi
  if [ "$is_clean_logs" == "true" ]; then
    if [ "$SDK" == 30 ]; then
      ui_print "- 正在停止tcpdump"
      stop tcpdump
      ui_print "- 正在停止cnss_diag"
      stop cnss_diag
    fi
    if [ "$SDK" == 31 ]; then
      ui_print "- 正在停止tcpdump"
      stop vendor.tcpdump
      ui_print "- 正在停止cnss_diag"
      stop vendor.cnss_diag
    fi
    ui_print "- 正在停止logd"
    stop logd
    ui_print "- 正在清除MIUI WiFi log"
    rm -rf /data/vendor/wlan_logs/*
    ui_print "- 正在清除MIUI 充电 log"
    rm -rf /data/vendor/charge_logger/*
    setprop sys.miui.ndcd off >/dev/null
    touch /data/adb/modules_update/Reducemiui/system.prop
    echo "sys.miui.ndcd=off" >/data/adb/modules_update/Reducemiui/system.prop
  fi
}
uninstall_useless_app() {
  ui_print "- 正在禁用智能服务"
  pm disable com.miui.systemAdSolution >/dev/null && ui_print "- pm disable com.miui.systemAdSolution: Success" || ui_print "- 不存在应用: com.miui.systemAdSolution 或已被精简"
  ui_print "- 正在移除Analytics"
  if [ "$(pm list package | grep 'com.miui.analytics')" != "" ]; then
    rm -rf /data/user/0/com.xiaomi.market/app_analytics/*
    chown -R root:root /data/user/0/com.xiaomi.market/app_analytics/
    chmod -R 000 /data/user/0/com.xiaomi.market/app_analytics/
    pm uninstall --user 0 com.miui.analytics >/dev/null
    if [ -d "/data/user/999/com.xiaomi.market/app_analytics/" ]; then
      rm -rf /data/user/999/com.xiaomi.market/app_analytics/*
      chown -R root:root /data/user/999/com.xiaomi.market/app_analytics/
      chmod -R 000 /data/user/999/com.xiaomi.market/app_analytics/
      pm uninstall --user 999 com.miui.analytics >/dev/null
    fi
    ui_print "- Analytics移除成功"
  else
    ui_print "- Analytics不存在"
  fi
}

dex2oat_app() {
  ui_print "- 为保障流畅，执行dex2oat($dex2oat_mode)优化，需要一点时间..."
  for app_list in ${dex2oat_list}; do
    cmd package compile -m $dex2oat_mode ${app_list} >/dev/null && ui_print "- ${app_list}: Success"
  done
  ui_print "- 优化完成"
}

hosts_file() {
  find_hosts="$(find /data/adb/modules*/*/system/etc -name 'hosts')"
  if [ "$(echo "$find_hosts" | grep -v "Reducemiui")" != "" ]; then
    echo "$find_hosts" | grep "Reducemiui" | xargs rm -rf
    find_hosts="$(find /data/adb/modules*/*/system/etc -name 'hosts')"
    have_an_effect_hosts="$(echo $find_hosts | awk '{print $NF}')"
    if [ "$(cat "${have_an_effect_hosts}" | grep '# Start Reducemiui hosts')" == "" ]; then
      cat "${TMPDIR}/common/hosts.txt" >>${have_an_effect_hosts}
    fi
  else
    mkdir -p ${MODPATH}/system/etc/
    find_hosts="$(find /data/adb/modules*/Reducemiui/system/etc -name 'hosts')"
    if [ ! -f "${find_hosts}" ]; then
      cp -r /system/etc/hosts ${MODPATH}/system/etc/
      cat ${TMPDIR}/common/hosts.txt >>${MODPATH}/system/etc/hosts
    else
      cp -r ${find_hosts} ${MODPATH}/system/etc/
    fi
  fi
}

# 最后步骤
dodone() {
  # 防止侧漏精简无效
  find ${MODPATH}/system_ext/ ${MODPATH}/product/ | grep ".replace" | awk -F "/Reducemiui" '{print $2}' | sed 's/\/.replace//g' | while read Lateral_leakage; do
    mkdir -p ${MODPATH}/system${Lateral_leakage}
    touch ${MODPATH}/system${Lateral_leakage}/.replace
  done
  [ -d "${MODPATH}/product" ] && rm -rf ${MODPATH}/product/
  [ -d "${MODPATH}/system_ext" ] && rm -rf ${MODPATH}/system_ext/
  # hosts文件判断
  if [ $is_use_hosts == true ]; then
    hosts_file
  else
    ui_print "- hosts文件未启用"
  fi
}

pre_install
ui_print "  "
ui_print "  "
ui_print "  Reduce MIUI Project"
ui_print "  "
ui_print "  "
custom_settings
reduce_test_services
uninstall_useless_app
dex2oat_app
retain_the_original_path
run_one
run_two
dodone
