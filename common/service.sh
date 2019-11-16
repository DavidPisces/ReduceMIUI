#!/system/bin/sh
MODDIR=${0%/*}

#sleep
sleep 9
#set permission
chmod 775 /sys/block/mmcblk0/queue/read_ahead_kb
chmod 775 /sys/block/mmcblk0/queue/iostats
#start sao serice
while true; do
echo '128' > /sys/block/mmcblk0/queue/read_ahead_kb
echo '0' > /sys/block/mmcblk0/queue/iostats
echo '0' > /sys/block/sda/queue/iostats
echo '128' > /sys/block/sda/queue/read_ahead_kb
done