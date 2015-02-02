#!/sbin/sh

BB=/tmp/busybox

if [ ! -f /system/xbin/busybox ]; then
   $BB cp /tmp/busybox /system/xbin/busybox; 
   $BB chmod 755 /system/xbin/busybox;
   /system/xbin/busybox --install -s /system/xbin
fi

if [ ! -d /system/etc/init.d ]; then
   if [ -f /system/etc/init.d ]; then
      $BB mv /system/etc/init.d /system/etc/init.d.bak;
   fi
   $BB mkdir /system/etc/init.d;
   $BB chown -R root.root /system/etc/init.d;
   $BB chmod -R 755 /system/etc/init.d;
fi

if [ -e /system/bin/thermal-engine-hh_bck ] ; then
	$BB mv /system/bin/thermal-engine-hh_bck /system/bin/thermal-engine-hh
fi

if [ -e /system/bin/mpdecision_bck ] ; then
	$BB mv /system/bin/mpdecision_bck /system/bin/mpdecision
fi

return $?
