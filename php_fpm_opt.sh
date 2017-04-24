#! /bin/sh

PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

uid=`id -u`

if [ $uid -ne 2001 -a $uid -ne 0 ];then
    echo "sorry,only user00 or root can user this script"
    exit 1
fi

WorkDir=/usr/local/services/php5

CMD=$WorkDir/sbin/php-fpm

PID_FILE=`egrep "php-fpm.pid$" $WorkDir/etc/php-fpm.conf | awk -F'=' '{print $2}'`

NAME=php-fpm
DESC=php-fpm

test -x $CMD || exit 0

case "$1" in
  start)
		ulimit -SHn 65535
        echo -n "Starting $DESC: "
        sudo $CMD
        echo "$NAME."
        ;;
  stop)
        echo -n "Stopping $DESC: "
        sudo /bin/kill -SIGQUIT `cat $PID_FILE`
        echo "$NAME."
        ;;
  force-stop)
  		echo -n "Force-Stopping $DESC: "
        sudo /bin/kill -SIGINT `cat $PID_FILE`
        echo "$NAME."
        ;;
  restart)
        echo -n "Restarting $DESC: "
        sudo /bin/kill -SIGQUIT `cat $PID_FILE`
		ulimit -SHn 65535
        sudo $CMD
        echo "$NAME."
        ;;
  reload)
        echo -n "Reloading $DESC configuration: "
        sudo /bin/kill -SIGUSR2 `cat $PID_FILE`
        echo "$NAME."
        ;;
  *)
        echo "Usage: $NAME {start|stop|force-stop|restart|reload}" >&2
        exit 1
        ;;
esac

exit 0
