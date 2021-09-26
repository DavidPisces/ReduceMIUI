#!/system/bin/sh
MODDIR=${0%/*}

sdcard_rw() {
  local test_file="/sdcard/Android/.Reducemiui_test"
  touch ${test_file}
  while [ ! -f "$test_file" ]; do
    touch ${test_file}
    sleep 1
  done
  rm $test_file
}

# 判断系统是否完全启动
until [ "$(getprop sys.boot_completed)" -eq "1" ]; do
  sleep 2
done
# 判断用户sdcard空间是否可读写
sdcard_rw

# Run
stop tcpdump
stop cnss_diag
stop logd
rm -rf /data/vendor/charge_logger/
rm -rf /data/vendor/wlan_logs/
# 禁用磁盘I/O统计 (UFS)
echo "0" >/sys/block/sda/queue/iostats
echo "0" >/sys/block/sdb/queue/iostats
echo "0" >/sys/block/sdc/queue/iostats
echo "0" >/sys/block/sdd/queue/iostats
echo "0" >/sys/block/sde/queue/iostats
echo "0" >/sys/block/sdf/queue/iostats

# 禁用binder调试
echo "0" >/sys/module/binder/parameters/debug_mask
echo "0" >/sys/module/binder_alloc/parameters/debug_mask
# 禁用内核调试
echo "0" >/sys/module/msm_show_resume_irq/parameters/debug_mask
echo "N" >/sys/kernel/debug/debug_enabled

# 数据分区I/O控制器优化
echo "128" >/sys/block/sda/queue/read_ahead_kb
echo "36" >/sys/block/sda/queue/nr_requests
echo "128" >/sys/block/sde/queue/read_ahead_kb
echo "36" >/sys/block/sde/queue/nr_requests
echo "128" >/sys/block/dm-5/queue/read_ahead_kb
echo "36" >/sys/block/dm-5/queue/nr_requests

# ZRAM分区参数调整
echo "128" >/sys/block/zram0/queue/read_ahead_kb
echo "36" >/sys/block/zram0/queue/nr_requests

# 调整虚拟空间页面集群
echo "0" >/proc/sys/vm/page-cluster

# 禁用不必要的转储
echo "0" >/sys/module/subsystem_restart/parameters/enable_ramdumps

# 禁用用户空间向dmesg写入日志
echo "off" >/proc/sys/kernel/printk_devkmsg

# 禁用sched_autogroup
echo "0" >/proc/sys/kernel/sched_autogroup_enabled

# 调整脏页写回策略时间
echo "3000" >/proc/sys/vm/dirty_expire_centisecs

# 禁用f2fs I/O数据收集统计
echo "0" >/sys/fs/f2fs/dm-5/iostat_enable

# 禁用调度统计
echo "0" >/proc/sys/kernel/sched_schedstats

# 调整虚拟内存统计间隔 (默认为1, 也就是1秒)
echo "20" >/proc/sys/vm/stat_interval

sleep 15
# 禁用MSA和Analytics

pm disable com.miui.systemAdSolution >/dev/null
pm disable com.miui.analytics >/dev/null

# 以Everything模式优化系统应用
dex2oat_list="$(cat ${MODDIR}/dex2oat.prop)"
for app_list in ${dex2oat_list}; do
  cmd package compile -m everything ${app_list} >/dev/null
done
