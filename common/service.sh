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
stop vendor.ipacm-diag
stop cnss_diag
stop logd
rm -rf /data/vendor/charge_logger/
rm -rf /data/vendor/wlan_logs/

# 禁用磁盘 I/O 统计
# 通过 ls 检查已安装的块设备, 如果存在 sda 则是 UFS 存储
# 如果不存在 sda 则是传统的 eMMC 设备 (包括 rpmb)
if [ "$(ls /sys/block | grep sda)" = "sda" ]; then
  echo "0" > /sys/block/sda/queue/iostats
  echo "0" > /sys/block/sdb/queue/iostats
  echo "0" > /sys/block/sdc/queue/iostats
  echo "0" > /sys/block/sdd/queue/iostats
  echo "0" > /sys/block/sde/queue/iostats
  echo "0" > /sys/block/sdf/queue/iostats
else
  echo "0" > /sys/block/mmcblk0/queue/iostats
  echo "0" > /sys/block/mmcblk0rpmb/queue/iostats
fi

# 设置块设备节点参数 - 主
# 通过 ls 检查已安装的块设备, 如果存在 sda 则是 UFS 存储
# 如果不存在 sda 则是传统的 eMMC 设备 (包括 rpmb)
if [ "$(ls /sys/block | grep sda)" = "sda" ]; then
  echo "128" > /sys/block/sda/queue/read_ahead_kb
  echo "64" > /sys/block/sda/queue/nr_requests
  echo "128" > /sys/block/sde/queue/read_ahead_kb
  echo "64" > /sys/block/sde/queue/nr_requests
else
  echo "128" > /sys/block/mmcblk0/queue/read_ahead_kb
  echo "64" > /sys/block/mmcblk0/queue/nr_requests
  echo "128" > /sys/block/mmcblk0rpmb/queue/read_ahead_kb
  echo "64" > /sys/block/mmcblk0rpmb/queue/nr_requests
fi

# 设置 dm-crypt 设备节点参数
# 如果是加密的设备则应用 dm-crypt 的参数
# 如果是解密的设备则跳过执行写入参数
# TODO: 通过获取系统提供的值以确定实际的 dm 设备
if [ "$(ls /sys/fs/f2fs | grep dm)" = "$(getprop dev.mnt.blk.data)" ]; then
  echo "128" > /sys/block/$(getprop dev.mnt.blk.data)/queue/read_ahead_kb
fi

# 为小米 865/870 平台启用 f2fs_gc_booster 功能
# TODO: 通过获取系统提供的值以确定实际的 dm 设备
# TODO: 小米的原子存储技术 (区别对待)
# 禁用F2FS文件系统I/O统计
# 在 android/platform_system_core/blob/master/rootdir/init.rc 中
# 的历史提交 commit: 8d8edad4437 中默认启用了它
if [ "$(getprop ro.board.platform)" = "kona" ]; then
  echo "1" > /sys/fs/f2fs/$(getprop dev.mnt.blk.data)/gc_booster
  echo "0" > /sys/fs/f2fs/$(getprop dev.mnt.blk.data)/iostat_enable
fi

# ZRAM 分区参数调整
echo "128" > /sys/block/zram0/queue/read_ahead_kb

# 禁用内核调试与日志
echo "0" > /sys/module/binder/parameters/debug_mask
echo "0" > /sys/module/binder_alloc/parameters/debug_mask
echo "Y" > /sys/module/spurious/parameters/noirqdebug
echo "0" > /sys/module/msm_show_resume_irq/parameters/debug_mask
echo "0" > /sys/module/subsystem_restart/parameters/enable_ramdumps
echo "N" > /sys/kernel/debug/debug_enabled
echo "off" > /proc/sys/kernel/printk_devkmsg

# 调整虚拟空间页面集群
echo "0" > /proc/sys/vm/page-cluster

# 禁用sched_autogroup
echo "0" > /proc/sys/kernel/sched_autogroup_enabled

# 调整脏页写回策略时间
echo "3000" > /proc/sys/vm/dirty_expire_centisecs

# 禁用调度统计
echo "0" > /proc/sys/kernel/sched_schedstats

# 调整虚拟内存统计间隔 (默认为1, 也就是1秒)
echo "20" > /proc/sys/vm/stat_interval

sleep 15

# 禁用 MSA 和 Analytics
pm disable com.miui.systemAdSolution > /dev/null
pm disable com.miui.analytics > /dev/null

# 以 Everything 模式优化应用
dex2oat_list="$(cat ${MODDIR}/dex2oat.prop)"
for app_list in ${dex2oat_list}; do
  cmd package compile -m everything ${app_list} >/dev/null
done
