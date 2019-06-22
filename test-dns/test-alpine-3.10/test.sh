#!/bin/sh

[ "$1"x == ""x ] && ETH=eth0 || ETH=$1
tcpdump -i $ETH udp -c 1000 -w /home/wwwroot/default/test-nslookup.pcap &
for id in `seq 1 1000`;do 
	time nslookup baidu.com
	echo 
done

tcpdump -i $ETH udp -c 100 -w /home/wwwroot/default/test-dig.pcap &
for id in `seq 1 100`;do 
	time dig +short AAAA baidu.com
	echo 
done
