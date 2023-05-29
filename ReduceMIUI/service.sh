#!/system/bin/sh
MODDIR=${0%/*}
# 禁用磁盘 I/O 统计
if [ "$(ls /sys/block | grep sda)" = "sda" ]; then
    echo 0 >/sys/block/sda/queue/iostats
    echo 0 >/sys/block/sde/queue/iostats
fi

# 禁用内核调试与日志
echo 0 >/sys/module/binder/parameters/debug_mask
echo 0 >/sys/module/binder_alloc/parameters/debug_mask

# 调整虚拟内存页面数量
echo 0 >/proc/sys/vm/page-cluster

# 调整虚拟内存统计间隔 (默认为1, 也就是1秒)
echo 20 >/proc/sys/vm/stat_interval
