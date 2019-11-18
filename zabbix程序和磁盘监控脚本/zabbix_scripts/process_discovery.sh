#!/bin/bash

File="/etc/zabbix/zabbix_scripts/search_proess_name.list"
IFS=$'\n'

discovery () {
    Proess_Name_Port=($(cat $File|grep -v "^#"))
    printf '{\n'
    printf '\t"data":[\n'
    num=${#Proess_Name_Port[@]}
    for site in ${Proess_Name_Port[@]}
    do
        num=$(( $num - 1 ))
        name=$(echo $site|awk '{print $1}')
        port=$(echo $site|awk '{print $2}')
        if [ $num -ne 0 ] ; then
            printf "\t\t{\"{#PROCESS_NAME}\":\""%s"\",\"{#PORCESS_PORT}\":\""${port}"\"},\n" ${name}
        else
            printf "\t\t{\"{#PROCESS_NAME}\":\""%s"\",\"{#PORCESS_PORT}\":\""${port}"\"}\n" ${name}
            printf '\t]\n'
            printf '}\n'
        fi
    done
}


discovery

