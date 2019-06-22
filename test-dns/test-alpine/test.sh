#!/bin/sh

[ "$1"x == ""x ] && ETH=eth0 || ETH=$1
tcpdump -i $ETH udp -c 1000 -w /home/wwwroot/default/test.pcap &
for id in `seq 1 1000`;do 
	time nslookup baidu.com
	echo 
done
