#!/bin/sh

RunPath='/usr/local/services/nginx'
LogFile='/usr/local/services/nginx/logs/restart.log'

#LocalIp=`/sbin/ifconfig eth1|grep "inet 10 | awk '{print $2}'``

PsName="nginx"

ResPsNum=`expr $(grep "^worker_process" $RunPath/conf/nginx.conf | sed 's/[^0-9]//g') + 1`

CurTime=`date +"%F %H:%M:%S"`

CurPsNum=$(pgrep $PsName | wc -l)

if [ $CurPsNum -lt $ResPsNum ]
then
    echo -n "${CurTime} checking failed , starting nginx" >> $LogFile
    sudo pkill -9 nginx
    sudo ${RunPath}/sbin/nginx  && echo " OK" >> $LogFile || echo " Failed" >> $LogFile
fi

