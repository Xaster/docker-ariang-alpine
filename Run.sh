#!/bin/sh
if [ ! -f /aria2/conf/aria2.conf ]; then
  cp /aria2/aria2.conf.default /aria2/conf/aria2.conf
fi
if [ ! -f /aria2/conf/Complete.sh ]; then
  cp /aria2/Complete.sh.default /aria2/conf/Complete.sh
fi
if [ $SECRET ]; then
  grep -q "rpc-secret" /aria2/conf/aria2.conf
  if [ $? -eq 0 ];then
    sed -i '/rpc-secret/d' /aria2/conf/aria2.conf
  fi
  echo "rpc-secret=${SECRET}" >> /aria2/conf/aria2.conf    
fi
if [ $TIMEZONE ]; then
  rm -rf /etc/localtime
  echo "${TIMEZONE}" > /etc/TZ
  cp /usr/share/zoneinfo/${TIMEZONE} /etc/localtime
fi
chmod +x /aria2/conf/Complete.sh
touch /aria2/conf/aria2.session
darkhttpd /ariang --port 9092 &
aria2c --conf-path=/aria2/conf/aria2.conf
