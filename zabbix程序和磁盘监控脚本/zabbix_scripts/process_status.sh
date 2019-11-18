#!/bin/bash


process_name=$1
process_port=$2

if  [ ! -n "$1" ];then
    echo "process_name is Null"
    process_mem=0
    process_cpu=0
    process_tcp=0

elif [ ! -n "$2" ];then

    echo "process_port is Null" 
    process_mem=0
    process_cpu=0
    process_tcp=0
	
else
    process_mem=$(ps aux|grep "${process_name}" |grep -v "grep"|grep -v "$0"|awk '{sum+=$6}; END{print sum}')
    process_cpu=$(ps aux|grep "${process_name}"|grep -v "grep"|grep -v "$0"|awk '{sum+=$3}; END{print sum}')
    process_tcp=$(ss -anp | grep "\<$process_port\>" |wc -l)

fi


if [ ! -n "$process_mem" ];then
    process_mem=-1
    process_cpu=-1
    process_tcp=-1
fi


if [[ $# == 3 ]];then
case $3 in
mem)
echo $process_mem
;;

cpu)
echo $process_cpu
;;

tcp)
echo $process_tcp
;;

port_active)
live=$(ss -tanlp | grep "\<$process_port\>" | wc -l)
echo $live

;;

process_active)
live=$(ps aux|grep "${process_name}" |grep -v "grep"|grep -v "$0"|wc -l)
echo $live
;;

*)
echo "$process_mem $process_cpu $process_tcp"
;;
esac

else

echo "$process_mem $process_cpu $process_tcp"

fi
