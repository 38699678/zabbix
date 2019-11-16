#!/usr/bin/env python
# Version = zabbix 4.2
import json
from urllib import request, parse
#2f47eb2f7c6ec11dcf5c00dae6fa355c

ZABBIX_URL = 'http://172.16.8.196:80/zabbix' #需要修改zabbix登录信息
ZABBIX_USERNAME = "Admin" #账号
ZABBIX_PASSWORD = "aacDRYIMx5k3bvP8" #密码

url = "{}/api_jsonrpc.php".format(ZABBIX_URL)
header = {"Content-Type": "application/json"}
# auth user and password

data = {
    "jsonrpc": "2.0",
    "method": "user.login",
    "params": {
        "user": ZABBIX_USERNAME,
        "password": ZABBIX_PASSWORD
    },
    "id": 1,
}

# 由于API接收的是json字符串，故需要转化一下
value = json.dumps(data).encode('utf-8')

# 对请求进行包装
req = request.Request(url, headers=header, data=value)

# 验证并获取Auth ID
try:
# 打开包装过的url
    result = request.urlopen(req)
except Exception as e:
    print("Auth Failed, Please Check Your Name And Password:", e)
else:
    response = result.read()
    #print(response)
    # 上面获取的是bytes类型数据，故需要decode转化成字符串
    page = response.decode('utf-8')
    # 将此json字符串转化为python字典
    page = json.loads(page)
    #print(page)
    result.close()
    status_list=str(page.get('result'))
    print(status_list)



