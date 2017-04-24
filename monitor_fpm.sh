#!/bin/sh

fpm_bin="/usr/local/services/nginx/script/php-fpm.sh"

RunPath='/usr/local/services/php5'

LogPath='/usr/local/services/nginx/logs'

PsName="php-fpm"

LogFile=$LogPath/${PsName}-restart.log

ReqProcNum=`expr $(grep "^pm.start_servers" $RunPath/etc/php-fpm.conf | sed 's/[^0-9]//g') + 1`

CurTime=`date +"%F %T"`

CurProcNum=$(pgrep -x $PsName | wc -l)

if [ $CurProcNum -lt $ReqProcNum ]
then
	echo -n "$CurTime checking failed , starting $PsName" >> $LogFile
	$fpm_bin restart  && echo " OK" >> $LogFile || echo " Failed" >>$LogFile
fi
