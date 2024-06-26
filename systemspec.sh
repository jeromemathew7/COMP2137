#!/bin/bash

USER=$(whoami)
DATE=$(date '+%Y-%m-%d %H:%M:%S')
HOSTNAME=$(hostname)
source /etc/os-release
OS="$NAME $VERSION"
UPTIME=$(uptime -p)
CPU=$(lshw -class processor | grep 'product' | awk -F ': ' '{print $2}')
CPUSPEED=$(lshw -class processor | grep 'capacity' | awk -F ': ' '{print $2}')
RAM=$(free -h | grep 'Mem:' | awk '{print $2}')
DISKS=$(lsblk -d -o model,size | grep -v 'MODEL' | awk '{print $1 " (" $2 ")"}' | paste -sd ", ")
VIDEO=$(lshw -class display | grep 'product' | awk -F ': ' '{print $2}')
FQDN=$(hostname -f)
HOST_IP=$(hostname -I | awk '{print $1}')
GATEWAY_IP=$(ip r | grep default | awk '{print $3}')
DNS_SERVER=$(cat /etc/resolv.conf | grep nameserver | awk '{print $2}')
NETWORK_INTERFACE=$(lshw -class network | grep 'product' | awk -F ': ' '{print $2}')
NETWORK_IP=$(ip a | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}')
USERS=$(who | awk '{print $1}' | sort | uniq | paste -sd ", ")
DISK_SPACE=$(df -h --output=source,avail | grep '^/dev/' | awk '{print $1 ": " $2}' | paste -sd ", ")
PROCESS_COUNT=$(ps aux | wc -l)
LOAD_AVERAGES=$(uptime | awk -F 'load average: ' '{print $2}')
MEMORY_ALLOCATION=$(free -h | grep 'Mem:' | awk '{print "Total: "$2", Used: "$3", Free: "$4}')
LISTENING_PORTS=$(ss -tuln | grep LISTEN | awk '{print $5}' | awk -F ':' '{print $NF}' | sort -n | uniq | paste -sd ", ")
UFW_RULES=$(sudo ufw status numbered)

cat << EOF

System Report generated by $USER, $DATE

System Information
------------------
Hostname: $HOSTNAME
OS: $OS
Uptime: $UPTIME

Hardware Information
--------------------
cpu: $CPU
Speed: $CPUSPEED
Ram: $RAM
Disk(s): $DISKS
Video: $VIDEO

Network Information
-------------------
FQDN: $FQDN
Host Address: $HOST_IP
Gateway IP: $GATEWAY_IP
DNS Server: $DNS_SERVER

InterfaceName: $NETWORK_INTERFACE
IP Address: $NETWORK_IP

System Status
-------------
Users Logged In: $USERS
Disk Space: $DISK_SPACE
Process Count: $PROCESS_COUNT
Load Averages: $LOAD_AVERAGES
Memory Allocation: $MEMORY_ALLOCATION
Listening Network Ports: $LISTENING_PORTS
UFW Rules: $UFW_RULES

EOF
