#!/bin/sh

uid=`id -u`

if [ $uid -ne 2000 -a $uid -ne 0 ];then
    echo "sorry,only user00 or root can user this script"
    exit 1
fi

BASE_DIR='/usr/local/services/nginx'

ulimit -HSn 65535               
                                                                         
sudo ${BASE_DIR}/sbin/nginx -t -c ${BASE_DIR}/conf/nginx.conf >& ${BASE_DIR}/logs/nginx.start

info=`cat ${BASE_DIR}/logs/nginx.start`

if [ `echo $info | grep -c "syntax is ok" ` -eq 1 ]; then

	if [ `ps aux|grep "nginx"|grep -c "master"` == 1 ]; then
		sudo kill -HUP `cat ${BASE_DIR}/logs/nginx.pid`
		echo "ok"
	else
		sudo killall -9 nginx
		sleep 1
		sudo ${BASE_DIR}/sbin/nginx
	fi

else

	echo "######## error: ########"
	cat ${BASE_DIR}/logs/nginx.start

fi
