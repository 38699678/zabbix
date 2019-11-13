# zabbix
docker-compose运行zabbix-server

可以先将镜像拉取下来
docker pull zabbix/zabbix-server-mysql:centos-4.0.4
docker pull zabbix/zabbix-web-nginx-mysql:centos-4.0.4
docker pull mariadb:10.2.22
运行
docker-compose up -d
 
安装agent客户端
wget https://repo.zabbix.com/zabbix/4.4/rhel/7/x86_64/zabbix-agent-4.4.1-1.el7.x86_64.rpm
yum localinstall -y zabbix-agent-4.4.1-1.el7.x86_64.rpm
systemctl enable zabbix-agent
修改/etc/zabbix/zabbix_agentd.conf里的serverIP地址（docker-server机器上的agent配置文件=还要填写容器IP，其他机器填写宿主机IP即可）
docker inspect zabbix-server | grep '"IPAddress":'  #找到zabbix-server的容器IP
Server=192.168.37.9,192.168.160.3  #宿主机IP和容器IP都写上
 
systemctl start zabbix-agent
