#!/system/bin/sh
MODDIR=${0%/*}
sleep 15
stop tcpdump
stop cnss_diag
rm -rf /data/vendor/charge_logger/
rm -rf /data/vendor/wlan_logs/
