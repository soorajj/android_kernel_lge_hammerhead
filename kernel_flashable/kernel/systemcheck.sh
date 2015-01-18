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

BMPDEC=`grep "item.0.3" /tmp/aroma/mods.prop | cut -d '=' -f2`
if [ "$BMPDEC" = 1 ]; then
	mv /system/bin/mpdecision /system/bin/mpdecision_bck
fi

BMPDEC=`grep "item.0.3" /tmp/aroma/mods.prop | cut -d '=' -f2`
if [ "$BMPDEC" = 1 ]; then
	mv /system/bin/thermal-engine-hh /system/bin/thermal-engine-hh_bck
fi

