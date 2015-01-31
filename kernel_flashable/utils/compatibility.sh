#!/sbin/sh
#
if [ -e /system/bin/thermal-engine-hh ] ; then
	busybox mv /system/bin/thermal-engine-hh /system/bin/thermal-engine-hh_bck
fi

return $?
