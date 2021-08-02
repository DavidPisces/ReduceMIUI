#!/system/bin/sh
MODDIR=${0%/*}
sleep 15
rm -rf /data/vendor/charge_logger/
#### ADD: Amktiao添加: MIUI 基础优化 2021-0730-235123 ###
#### ADD: Amktiao添加标记 TODO: 禁用磁盘I/O读写统计 2021-0730-235204 ####
#### ADD: Amktiao添加标记 TODO: 禁用sda主数据分区读写统计 2021-0730-235209 ####
echo "0" > /sys/block/sda/queue/iostats
#### ADD: Amktiao添加标记 TODO: 禁用sde次要数据分区读写统计 2021-0730-235213 ####
echo "0" > /sys/block/sde/queue/iostats
#### ADD: Amktiao添加标记 TODO: 禁用binder活页夹日志输出 2021-0730-235222 ####
echo "0" > /sys/module/binder/parameters/debug_mask
#### ADD: Amktiao添加标记 TODO: 禁用binder活页夹分配器日志输出 2021-0730-235231 ####
echo "0" > /sys/module/binder_alloc/parameters/debug_mask
#### ADD: Amktiao添加标记 TODO: 更改磁盘预读为128k sda主分区 2021-0730-235237 ####
echo "128" > /sys/block/sda/queue/read_ahead_kb
#### ADD: Amktiao添加标记 TODO: 更改磁盘预读为128k sde次要分区 2021-0730-235240 ####
echo "128" > /sys/block/sde/queue/read_ahead_kb
#### ADD: Amktiao添加标记 TODO: 更改磁盘NR分配块 sda主分区 2021-0730-235245 ####
echo "36" > /sys/block/sda/queue/nr_requests
#### ADD: Amktiao添加标记 TODO: 更改磁盘NR分配块 sde次要分区 2021-0730-235247 ####
echo "36" > /sys/block/sde/queue/nr_requests
#### ADD: Amktiao添加标记 TODO: 更改虚拟内存page集群数量 2021-0730-235301 ####
echo "0" > /proc/sys/vm/page-cluster
#### ADD: Amktiao添加标记 TODO: 更改虚拟内存更新间隔, 减少性能抖动 2021-0730-235312 ####
echo "20" > /proc/sys/vm/stat_interval
#### END: Amktiao添加: MIUI 基础优化 2021-0730-235123 ###
