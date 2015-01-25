#!/sbin/sh

if [ ! -f /system/xbin/busybox ]; then
   cp /tmp/busybox /system/xbin/busybox; 
   chmod 755 /system/xbin/busybox;
   /system/xbin/busybox --install -s /system/xbin
fi

if [ ! -e /system/etc/init.d ]; then
  mkdir /system/etc/init.d
  chown -R root.root /system/etc/init.d
  chmod -R 755 /system/etc/init.d
fi;

if [ -e /system/bin/mpdecision ] ; then
	mv /system/bin/mpdecision /system/bin/mpdecision_bck
fi

if [ -e /system/bin/thermal-engine-hh ] ; then
	mv /system/bin/thermal-engine-hh /system/bin/thermal-engine-hh_bck
fi

