#!/bin/bash
echo '创建zabbix4.2yum源'
rpm -Uvh https://repo.zabbix.com/zabbix/4.2/rhel/7/x86_64/zabbix-release-4.2-1.el7.noarch.rpm &> /dev/null
echo '安装server相关组件'
yum -y install  zabbix-server-mysql  zabbix-web-mysql  zabbix-agent  zabbix-proxy-mysql &> /dev/null


echo 'yum安装mysql-5.7'
wget https://repo.mysql.com//mysql57-community-release-el7-11.noarch.rpm &> /dev/null
yum localinstall  -y mysql57-community-release-el7-11.noarch.rpm &> /dev/null
yum install -y mysql-community-server &> /dev/null


mv /etc/my.cnf /etc/my.cnf-back
cat > /etc/my.cnf << EOF
[mysqld]
server_id = 1
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
character-set-server=utf8mb4
collation-server=utf8mb4_unicode_ci
default-storage-engine=INNODB
#Optimize omit
sql_mode=NO_ENGINE_SUBSTITUTION,STRICT_TRANS_TABLES
log-bin     = binlog
log_bin_trust_function_creators=1
binlog_format = ROW
expire_logs_days = 30
sync_binlog = 0
slow-query-log=1
slow-query-log-file=/var/log/mysql/slow-queries.log
long_query_time = 3
log-queries-not-using-indexes
explicit_defaults_for_timestamp = 1
# Disabling symbolic-links is recommended to prevent assorted security risks
symbolic-links=0

log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
EOF

echo '启动MySQL'
systemctl start mysqld
systemctl enable mysqld

echo '查看生成mysql root用户临时密码'
PASSWORD=`grep 'temporary password' /var/log/mysqld.log | awk '{print $11}'`

echo '修改mysql用户密码'
mysqladmin -uroot -p${PASSWORD} password Test123@


echo '创建zabbix数据库并授权zabbix访问'
mysql -uroot -pTest123@ -e 'create database zabbix;'
mysql -uroot -pTest123@ -e "grant all privileges on zabbix.* to zabbix@'%' identified by 'Test123@';"
mysql -uroot -pTest123@ -e "grant all privileges on zabbix.* to zabbix@'localhost' identified by 'Test123@';"
mysql -uroot -pTest123@ -e 'flush privileges;'


echo '导入zabbix数据库'
zcat /usr/share/doc/zabbix-server-mysql-4.2.8/create.sql.gz |mysql -uroot -P3306 -pTest123@ --database zabbix


echo '修改php时区'
sed -i  's^; http://php.net/date.timezone^date.timezone = Asia/Shanghai^g'  /etc/php.ini

echo '修改zabbix-server配置文件，输入数据库信息,修改zabbix中文乱码问题'
wget https://github.com/pornhub91/zabbix/raw/master/zabbix%E7%A8%8B%E5%BA%8F%E5%92%8C%E7%A3%81%E7%9B%98%E7%9B%91%E6%8E%A7%E8%84%9A%E6%9C%AC/simkai.ttf -O  /usr/share/zabbix/assets/fonts/simkai.ttf &> /dev/null
chmod 777 /usr/share/zabbix/assets/fonts/simkai.ttf
sed -i "s^'graphfont');^'simkai');^g"  /usr/share/zabbix/include/defines.inc.php

mv /etc/zabbix/zabbix_server.conf  /etc/zabbix/zabbix_server.conf-back
cat > /etc/zabbix/zabbix_server.conf << EOF
LogFile=/var/log/zabbix/zabbix_server.log
LogFileSize=0
PidFile=/var/run/zabbix/zabbix_server.pid
SocketDir=/var/run/zabbix
DBHost=127.0.0.1
DBName=zabbix
DBUser=zabbix
DBPassword=Test123@
DBSocket=/var/lib/mysql/mysql.sock
DBPort=3306
StartPollers=100
SNMPTrapperFile=/var/log/snmptrap/snmptrap.log
CacheSize=1G
Timeout=4
AlertScriptsPath=/usr/lib/zabbix/alertscripts
ExternalScripts=/usr/lib/zabbix/externalscripts
LogSlowQueries=3000
StatsAllowedIP=127.0.0.1
EOF

echo '启动zabbix-server，zabbix-agent，httpd'
systemctl start zabbix-agent && systemctl enable zabbix-agent
systemctl start zabbix-server && systemctl enable zabbix-server
systemctl start httpd && systemctl enable httpd



#启动访问
#http://{IP}/zabbix

#默认密码
#Admin
#zabbix


