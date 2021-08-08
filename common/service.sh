#!/system/bin/sh
MODDIR=${0%/*}
sleep 15
stop tcpdump
stop cnss_diag
rm -rf /data/vendor/charge_logger/
rm -rf /data/vendor/wlan_logs/
# 禁用sda主数据分区读写统计
echo "0" > /sys/block/sda/queue/iostats
# 禁用sde次要数据分区读写统计
echo "0" > /sys/block/sde/queue/iostats
# 禁用binder活页夹日志输出
echo "0" > /sys/module/binder/parameters/debug_mask
# 禁用binder活页夹分配器日志输出
echo "0" > /sys/module/binder_alloc/parameters/debug_mask
# 更改磁盘预读为128k sda主分区
echo "128" > /sys/block/sda/queue/read_ahead_kb
# 更改磁盘预读为128k sde次要分区
echo "128" > /sys/block/sde/queue/read_ahead_kb
# 更改磁盘NR分配块 sda主分区
echo "36" > /sys/block/sda/queue/nr_requests
# 更改磁盘NR分配块 sde次要分区
echo "36" > /sys/block/sde/queue/nr_requests
# 更改虚拟内存page集群数量
echo "0" > /proc/sys/vm/page-cluster
# 更改虚拟内存更新间隔, 减少性能抖动
echo "20" > /proc/sys/vm/stat_interval
