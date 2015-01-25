#!/sbin/sh

SOOPLUS_LOGFILE="/sdcard/sooplus.log"
[ ! -d /tmp/ramdisk ] && mkdir /tmp/ramdisk
cd /tmp/ramdisk/
mv -f /tmp/ramdisk.tar.gz ./

tar -zxf ramdisk.tar.gz && rm -f ramdisk.tar.gz

sed -i '/\/sys\/block\/mmcblk0\/queue\/scheduler/d' init.hammerhead.rc
SCHED=`grep selected.1 /tmp/aroma/disk.prop | cut -d '=' -f2`
if [ $SCHED = 1 ]; then
	sed -i '/on property:init.svc.bootanim=stopped/a \    write /sys/block/mmcblk0/queue/scheduler cfq\' init.hammerhead.rc
	echo "Ioshed CFQ enabled" >> $SOOPLUS_LOGFILE;
elif [ $SCHED = 2 ]; then
	sed -i '/on property:init.svc.bootanim=stopped/a \    write /sys/block/mmcblk0/queue/scheduler row\' init.hammerhead.rc
	echo "Ioshed ROW enabled" >> $SOOPLUS_LOGFILE;
elif [ $SCHED = 3 ]; then
	sed -i '/on property:init.svc.bootanim=stopped/a \    write /sys/block/mmcblk0/queue/scheduler deadline\' init.hammerhead.rc
	echo "Ioshed DEADLINE enabled" >> $SOOPLUS_LOGFILE;
elif [ $SCHED = 4 ]; then
	sed -i '/on property:init.svc.bootanim=stopped/a \    write /sys/block/mmcblk0/queue/scheduler noop\' init.hammerhead.rc
	echo "Ioshed NOOP enabled" >> $SOOPLUS_LOGFILE;
elif [ $SCHED = 5 ]; then
	sed -i '/on property:init.svc.bootanim=stopped/a \    write /sys/block/mmcblk0/queue/scheduler fiops\' init.hammerhead.rc
	echo "Ioshed FIOPS enabled" >> $SOOPLUS_LOGFILE;
elif [ $SCHED = 6 ]; then
	sed -i '/on property:init.svc.bootanim=stopped/a \    write /sys/block/mmcblk0/queue/scheduler sio\' init.hammerhead.rc
	echo "Ioshed SIO enabled" >> $SOOPLUS_LOGFILE;
elif [ $SCHED = 7 ]; then
	sed -i '/on property:init.svc.bootanim=stopped/a \    write /sys/block/mmcblk0/queue/scheduler bfq\' init.hammerhead.rc
	echo "Ioshed BFQ enabled" >> $SOOPLUS_LOGFILE;
fi

chown -R root:root *

/tmp/mkbootfs ./ | /tmp/lz4 -l -9 -q -f stdin /tmp/sooplus.ramdisk

cd /tmp/ && rm -rf /tmp/ramdisk

/tmp/mkbootimg --kernel /tmp/zImage --ramdisk /tmp/sooplus.ramdisk --cmdline 'console=ttyHSL0,115200,n8 androidboot.hardware=hammerhead user_debug=31 msm_watchdog_v2.enable=1' --base 0x00000000 --pagesize 2048 --ramdisk_offset 0x02900000 --tags_offset 0x02700000 --output /tmp/boot.img
