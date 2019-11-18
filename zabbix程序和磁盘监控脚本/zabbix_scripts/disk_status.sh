#!/bin/bash

#UserParameter=custom.vfs.dev.read.ops[*],cat /proc/diskstats | grep $1 | head -1 | awk '{print $$4}'                    //磁盘读的次数
#UserParameter=custom.vfs.dev.read.ms[*],cat /proc/diskstats | grep $1 | head -1 | awk '{print $$7}'                     //磁盘读的毫秒数
#UserParameter=custom.vfs.dev.write.ops[*],cat /proc/diskstats | grep $1 | head -1 | awk '{print $$8}'                   //磁盘写的次数
#UserParameter=custom.vfs.dev.write.ms[*],cat /proc/diskstats | grep $1 | head -1 | awk '{print $$11}'                  //磁盘写的毫秒数
#UserParameter=custom.vfs.dev.io.active[*],cat /proc/diskstats | grep $1 | head -1 | awk '{print $$12}'            
#UserParameter=custom.vfs.dev.io.ms[*],cat /proc/diskstats | grep $1 | head -1 | awk '{print $$13}'                       //花费在IO操作上的毫秒数
#UserParameter=custom.vfs.dev.read.sectors[*],cat /proc/diskstats | grep $1 | head -1 | awk '{print $$6}'             //读扇区的次数（一个扇区的等于512B）
#UserParameter=custom.vfs.dev.write.sectors[*],cat /proc/diskstats | grep $1 | head -1 | awk '{print $$10}'          //写扇区的次数（一个扇区的等于512B）

Device=$1
DISK=$2

case $DISK in 

    rops)
        cat /proc/diskstats | grep $1 | head -1 | awk '{print $4}'
        ;;

    readms)
        cat /proc/diskstats | grep $1 | head -1 | awk '{print $7}'
        ;;

    wops)
        cat /proc/diskstats | grep $1 | head -1 | awk '{print $8}' 
        ;;

    writems)
        cat /proc/diskstats | grep $1 | head -1 | awk '{print $11}' 
        ;;

    ioactive)
        cat /proc/diskstats | grep $1 | head -1 | awk '{print $12}'
        ;;

    ioms)
        cat /proc/diskstats | grep $1 | head -1 | awk '{print $13}' 
        ;;

    readsectors)
        cat /proc/diskstats | grep $1 | head -1 | awk '{print $6}' 
        ;;

    writesectors)
        cat /proc/diskstats | grep $1 | head -1 | awk '{print $10}'
        ;;    
    DiskAvaliable)
        df -k | head -2 | grep "\b$Device\b" | awk '{print $4}'
        ;;

    *)
        echo -e "\e[033mUsage: sh $0 [rrqm|wrqm|rps|wps|rKBps|wKBps|avgqu-sz|avgrq-sz|await|svctm|util]\e[0m"
esac
