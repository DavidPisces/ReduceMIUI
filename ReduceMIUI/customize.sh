#!/bin/bash
SKIPUNZIP=0
ui_print "- Magisk 版本: $MAGISK_VER_CODE"
if [ "$MAGISK_VER_CODE" -lt 24000 ]; then
  ui_print "*********************************************"
  ui_print "! 请安装 Magisk 24.0+"
  abort "*********************************************"
fi
rm -rf /data/system/package_cache
# ReduceMIUI自定义配置文件目录
Package_Name_Reduction="$(cat ${MODPATH}/包名精简.prop | grep -v '#')"
dex2oat_list="$(cat ${MODPATH}/dex2oat.prop | grep -v '#')"
echo "$(pm list packages -f -a)" >$MODPATH/packages.log
sed -i -e 's/\ /\\\n/g' -e 's/\\//g' -e 's/package://g' $MODPATH/packages.log
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
SDK="$(getprop ro.system.build.version.sdk)"
touch_replace() {
  mkdir -p $1
  touch $1/.replace
  chown root:root $1/.replace
  chmod 0644 $1/.replace
}
reduce_test_services() {
  if [ "$is_reduce_test_services" == "true" ]; then
    if [ "$SDK" -le 30 ]; then
      ui_print "- 正在停止ipacm-diag"
      stop ipacm-diag
      echo "stop ipacm-diag" >>$MODPATH/service.sh
    fi
    if [ "$SDK" -ge 31 ]; then
      ui_print "- 正在停止ipacm-diag"
      stop vendor.ipacm-diag
      echo "stop vendor.ipacm-diag" >>$MODPATH/service.sh
    fi
  fi
  if [ "$is_clean_logs" == "true" ]; then
    if [ "$SDK" -le 30 ]; then
      ui_print "- 正在停止tcpdump"
      stop tcpdump
      echo "stop tcpdump" >>$MODPATH/service.sh
      ui_print "- 正在停止cnss_diag"
      stop cnss_diag
      echo "stop cnss_diag" >>$MODPATH/service.sh
    elif [ "$SDK" -ge 31 ]; then
      ui_print "- 正在停止tcpdump"
      stop vendor.tcpdump
      echo "stop vendor.tcpdump" >>$MODPATH/service.sh
      ui_print "- 正在停止cnss_diag"
      stop vendor.cnss_diag
      echo "stop vendor.cnss_diag" >>$MODPATH/service.sh
      ui_print "- 正在停止logd"
      stop logd
      echo "stop logd" >>$MODPATH/service.sh
    fi
    ui_print "- 正在清除MIUI WiFi log"
    rm -rf /data/vendor/wlan_logs/*
    ui_print "- 正在清除MIUI 充电 log"
    rm -rf /data/vendor/charge_logger/*
  fi
}
uninstall_useless_app() {
  ui_print "- 正在禁用智能服务"
  if [ "$(pm list package | grep 'com.miui.systemAdSolution')" != "" ]; then
    pm disable com.miui.systemAdSolution
    ui_print "- 成功禁用智能服务"
  else
    ui_print "- 智能服务不存在或已被精简"
  fi
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
  ui_print "- 为保障流畅，执行dex2oat ($dex2oat_mode)优化，需要一点时间..."
  for app_list in ${dex2oat_list}; do
    var=$app_list
    record="$(eval cat $MODPATH/packages.log | grep "$var"$)"
    apk_path="${record%=*}"
    apk_dir="${apk_path%/*}"
    apk_name="${apk_path##*/}"
    apk_name="${apk_name%.*}"
    apk_source="$(echo $apk_dir | cut -d"/" -f2)"
    if [[ "$(unzip -l $apk_path | grep lib/)" == "" ]] || [[ "$(unzip -l $apk_path | grep lib/arm64)" != "" ]]; then
      apk_abi=arm64
    else
      apk_abi=arm
    fi
    if [[ "$apk_source" == "data" ]]; then
      if [ "$(unzip -l $apk_path | grep classes.dex)" != "" ]; then
        rm -rf "$apk_dir"/oat/$apk_abi/*
        dex2oat --dex-file="$apk_path" --compiler-filter=$dex2oat_mode --instruction-set=$apk_abi --oat-file="$apk_dir"/oat/$apk_abi/base.odex
        ui_print "- ${app_list}: 成功"
      fi
    else
      if [ "$(unzip -l $apk_path | grep classes.dex)" != "" ]; then
        mkdir -p $MODPATH$apk_dir/oat/$apk_abi
        dex2oat --dex-file="$apk_path" --compiler-filter=$dex2oat_mode --instruction-set=$apk_abi --oat-file=$MODPATH$apk_dir/oat/$apk_abi/$apk_name.odex
        ui_print "- ${app_list}: 成功"
      fi
    fi
  done
  ui_print "- 优化完成"
}
package_replace() {
  for app_list in ${Package_Name_Reduction}; do
    var=$app_list
    record="$(eval cat $MODPATH/packages.log | grep "$var"$)"
    apk_path="${record%=*}"
    apk_dir="${apk_path%/*}"
    apk_source="$(echo $apk_dir | cut -d"/" -f2)"
    if [[ "$apk_source" == "data" ]]; then
      ui_print "- ${app_list}为手动安装的应用或已被精简"
    else
      ui_print "- 正在精简${app_list}"
      touch_replace $MODPATH$apk_dir
    fi
  done
}
hosts_file() {
  # hosts文件判断
  if [[ $is_use_hosts == true ]]; then
    find_hosts="$(find /data/adb/modules*/*/system/etc -name 'hosts')"
    if [ "$(echo "$find_hosts" | grep -v "Reducemiui")" != "" ]; then
      echo "$find_hosts" | grep "Reducemiui" | xargs rm -rf
      find_hosts="$(find /data/adb/modules*/*/system/etc -name 'hosts')"
      have_an_effect_hosts="$(echo $find_hosts | awk '{print $NF}')"
      if [ "$(cat "${have_an_effect_hosts}" | grep '# Start Reducemiui hosts')" == "" ]; then
        cat "${MODPATH}/hosts.txt" >>${have_an_effect_hosts}
      fi
    else
      mkdir -p ${MODPATH}/system/etc/
      find_hosts="$(find /data/adb/modules*/Reducemiui/system/etc -name 'hosts')"
      if [ ! -f "${find_hosts}" ]; then
        cp -r /system/etc/hosts ${MODPATH}/system/etc/
        cat ${MODPATH}/hosts.txt >>${MODPATH}/system/etc/hosts
      else
        cp -r ${find_hosts} ${MODPATH}/system/etc/
      fi
    fi
  else
    ui_print "- hosts文件未启用"
  fi
}
remove_files() {
  for partition in vendor odm product system_ext; do
    [ -d $MODPATH/$partition ] && mv $MODPATH/$partition $MODPATH/system
  done
  rm -rf $MODPATH/hosts.txt
  rm -rf $MODPATH/.replace
}
reduce_test_services
uninstall_useless_app
dex2oat_app
package_replace
hosts_file
remove_files
