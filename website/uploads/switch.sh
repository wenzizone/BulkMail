#!/bin/bash
VIP=10.100.16.241
workdir="/etc/keepalived"
cd $workdir
if [ ! -f switch.pid ];then
	echo 'undef' >switch.pid
fi
backup(){
	cd $workdir
	backup="$(cat switch.pid)"
	/sbin/ip ad sh eth0|grep "$VIP/32" 2>&1 >/dev/null && /sbin/ip ad del $VIP/32 dev eth0:0 2>&1 >/dev/null
	if [ $backup != "backup" ];then
		ln -sf keepalived.conf.switch-backup keepalived.conf
		/sbin/ipvsadm -C
		echo "backup" >switch.pid
		/etc/init.d/keepalived reload
		echo "switch to backup $(date +"%Y-%m-%d %H:%M:%S")" >>switch.log
	else
		exit 0
	fi
}
master(){
	cd $workdir
	master="$(cat switch.pid)"
	if [ $master != "master" ];then
		ln -sf keepalived.conf.switch-master keepalived.conf
		echo "master" >switch.pid
		/etc/init.d/keepalived reload
		echo "switch to master $(date +"%Y-%m-%d %H:%M:%S")" >>switch.log
	else
		exit 0
	fi
}
case $1 in
	backup)
		$1
	;;
	master)
	$1
	;;
	*)
	echo "Usage:$0 master|backup"
	exit 1
	;;
esac
