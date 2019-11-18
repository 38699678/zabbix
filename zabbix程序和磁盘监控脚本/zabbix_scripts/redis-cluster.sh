#!/bin/bash

REDISCLI="/usr/local/src/app/redis-5.0.5/src/redis-cli"
HOST=$1
PORT=$2

if [[ $# == 3 ]];then
case $3 in

cluster_info)
$REDISCLI -h $HOST -p $PORT -c cluster info
;;

cluster_nodes)
$REDISCLI -h $HOST -p $PORT -c cluster nodes
;;
cluster_state)
result=$($REDISCLI -h $HOST -p $PORT -c cluster info | grep -w "cluster_state" | awk -F':' '{print $2}'| grep -c ok)
echo $result
;;
cluster_slots_assigned)
result=$($REDISCLI -h $HOST -p $PORT -c cluster info | grep -w "cluster_slots_assigned" | awk -F':' '{print $2}')
echo $result
;;
cluster_slots_ok)
result=$($REDISCLI -h $HOST -p $PORT -c cluster info | grep -w "cluster_slots_ok" | awk -F':' '{print $2}')
echo $result
;;
cluster_slots_pfail)
result=$($REDISCLI -h $HOST -p $PORT -c cluster info | grep -w "cluster_slots_pfail" | awk -F':' '{print $2}')
echo $result
;;
cluster_slots_fail)
result=$($REDISCLI -h $HOST -p $PORT -c cluster info | grep -w "cluster_slots_fail" | awk -F':' '{print $2}')
echo $result
;;
cluster_known_nodes)
result=$($REDISCLI -h $HOST -p $PORT -c cluster info | grep -w "cluster_known_nodes" | awk -F':' '{print $2}')
echo $result
;;
cluster_size)
result=$($REDISCLI -h $HOST -p $PORT -c cluster info | grep -w "cluster_size" | awk -F':' '{print $2}')
echo $result
;;
cluster_current_epoch)
result=$($REDISCLI -h $HOST -p $PORT -c cluster info | grep -w "cluster_current_epoch" | awk -F':' '{print $2}')
echo $result
;;
cluster_my_epoch)
result=$($REDISCLI -h $HOST -p $PORT -c cluster info | grep -w "cluster_my_epoch" | awk -F':' '{print $2}')
echo $result
;;
cluster_stats_messages_ping_sent)
result=$($REDISCLI -h $HOST -p $PORT -c cluster info | grep -w "cluster_stats_messages_ping_sent" | awk -F':' '{print $2}')
echo $result
;;
cluster_stats_messages_pong_sent)
result=$($REDISCLI -h $HOST -p $PORT -c cluster info | grep -w "cluster_stats_messages_pong_sent" | awk -F':' '{print $2}')
echo $result
;;
cluster_stats_messages_sent)
result=$($REDISCLI -h $HOST -p $PORT -c cluster info | grep -w "cluster_stats_messages_sent" | awk -F':' '{print $2}')
echo $result
;;
cluster_stats_messages_ping_received)
result=$($REDISCLI -h $HOST -p $PORT -c cluster info | grep -w "cluster_stats_messages_ping_received" | awk -F':' '{print $2}')
echo $result
;;
cluster_stats_messages_pong_received)
result=$($REDISCLI -h $HOST -p $PORT -c cluster info | grep -w "cluster_stats_messages_pong_received" | awk -F':' '{print $2}')
echo $result
;;
cluster_stats_messages_received)
result=$($REDISCLI -h $HOST -p $PORT -c cluster info | grep -w "cluster_stats_messages_received" | awk -F':' '{print $2}')
echo $result
;;
*)
echo -e "\033[33mUsage: $0 {cluster_state|cluster_slots_assigned|cluster_slots_ok|cluster_slots_pfail|cluster_slots_fail|cluster_known_nodes|cluster_size|cluster_current_epoch|cluster_known_nodes|cluster_size|cluster_current_epoch|cluster_my_epoch|cluster_stats_messages_ping_sent|cluster_stats_messages_pong_sent|cluster_stats_messages_sent|cluster_stats_messages_ping_received|cluster_stats_messages_pong_received|cluster_stats_messages_received}\033[0m"
;;
esac
fi
