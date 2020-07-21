#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
#=================================================
#	System Required: CentOS 6+/Debian 6+/Ubuntu 14.04+
#	Description: ShadowsocksR server Docker Manage Shell
#	Version: 1.0.0
#   Author: fly97
#=================================================
SH_VER="1.0"
REPOSITORY="fly97/shadowsocksr"
NAME="shadowsocksr"
CONFIG_DIR="/etc/shadowsocksr/"
CONFIG_JSON="/etc/shadowsocksr/config.json"
JQ_BIN="/etc/shadowsocksr/jq"

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[信息]${Font_color_suffix}"
Error="${Red_font_prefix}[错误]${Font_color_suffix}"
Tip="${Green_font_prefix}[注意]${Font_color_suffix}"
Separator_1="——————————————————————————————"


write_config(){
[[ ! -e $CONFIG_DIR ]] && mkdir $CONFIG_DIR
[[ ! -e $CONFIG_JSON ]] && touch $CONFIG_JSON 
cat > ${CONFIG_JSON}<<-EOF
{
    "server": "0.0.0.0",
    "server_ipv6": "::",
    "server_port": ${ssr_port},
    "local_address": "127.0.0.1",
    "local_port": 1080,

    "password": "${ssr_password}",
    "method": "${ssr_method}",
    "protocol": "${ssr_protocol}",
    "protocol_param": "",
    "obfs": "${ssr_obfs}",
    "obfs_param": "",
	
    "additional_ports" : {},
    "timeout": 60,
    "udp_timeout": 60,
    "dns_ipv6": false,
    "connect_verbose_info": 0,
    "redirect": "",
    "fast_open": false
}
EOF
}
make_config(){
	while true
	do
	echo -e "请输入要设置的ShadowsocksR账号 端口"
	read -e -p "(默认: 443):" ssr_port
	[[ -z "$ssr_port" ]] && ssr_port="443"
	echo $((${ssr_port}+0)) &>/dev/null
	if [[ $? == 0 ]]; then
		if [[ ${ssr_port} -ge 1 ]] && [[ ${ssr_port} -le 65535 ]]; then
			echo && echo ${Separator_1} && echo -e "	端口 : ${Green_font_prefix}${ssr_port}${Font_color_suffix}" && echo ${Separator_1} && echo
			break
		else
			echo -e "${Error} 请输入正确的数字(1-65535)"
		fi
	else
		echo -e "${Error} 请输入正确的数字(1-65535)"
	fi
	done	
#------------------------------------------------------------------------------------
	echo "请输入要设置的ShadowsocksR账号 密码"
	read -e -p "(默认: fly97):" ssr_password
	[[ -z "${ssr_password}" ]] && ssr_password="fly97"
	echo && echo ${Separator_1} && echo -e "	密码 : ${Green_font_prefix}${ssr_password}${Font_color_suffix}" && echo ${Separator_1} && echo
#------------------------------------------------------------------------------------
	echo -e "请选择要设置的ShadowsocksR账号 加密方式
	
 ${Green_font_prefix} 1.${Font_color_suffix} none
 ${Tip} 如果使用 auth_chain_a 协议，请加密方式选择 none，混淆随意(建议 plain)
 
 ${Green_font_prefix} 2.${Font_color_suffix} rc4
 ${Green_font_prefix} 3.${Font_color_suffix} rc4-md5
 ${Green_font_prefix} 4.${Font_color_suffix} rc4-md5-6
 
 ${Green_font_prefix} 5.${Font_color_suffix} aes-128-ctr
 ${Green_font_prefix} 6.${Font_color_suffix} aes-192-ctr
 ${Green_font_prefix} 7.${Font_color_suffix} aes-256-ctr
 
 ${Green_font_prefix} 8.${Font_color_suffix} aes-128-cfb
 ${Green_font_prefix} 9.${Font_color_suffix} aes-192-cfb
 ${Green_font_prefix}10.${Font_color_suffix} aes-256-cfb
 
 ${Green_font_prefix}11.${Font_color_suffix} aes-128-cfb8
 ${Green_font_prefix}12.${Font_color_suffix} aes-192-cfb8
 ${Green_font_prefix}13.${Font_color_suffix} aes-256-cfb8
 
 ${Green_font_prefix}14.${Font_color_suffix} salsa20
 ${Green_font_prefix}15.${Font_color_suffix} chacha20
 ${Green_font_prefix}16.${Font_color_suffix} chacha20-ietf
 ${Tip} salsa20/chacha20-*系列加密方式，需要额外安装依赖 libsodium ，否则会无法启动ShadowsocksR !" && echo
	read -e -p "(默认: chacha20):" ssr_method
	[[ -z "${ssr_method}" ]] && ssr_method="15"
	if [[ ${ssr_method} == "1" ]]; then
		ssr_method="none"
	elif [[ ${ssr_method} == "2" ]]; then
		ssr_method="rc4"
	elif [[ ${ssr_method} == "3" ]]; then
		ssr_method="rc4-md5"
	elif [[ ${ssr_method} == "4" ]]; then
		ssr_method="rc4-md5-6"
	elif [[ ${ssr_method} == "5" ]]; then
		ssr_method="aes-128-ctr"
	elif [[ ${ssr_method} == "6" ]]; then
		ssr_method="aes-192-ctr"
	elif [[ ${ssr_method} == "7" ]]; then
		ssr_method="aes-256-ctr"
	elif [[ ${ssr_method} == "8" ]]; then
		ssr_method="aes-128-cfb"
	elif [[ ${ssr_method} == "9" ]]; then
		ssr_method="aes-192-cfb"
	elif [[ ${ssr_method} == "10" ]]; then
		ssr_method="aes-256-cfb"
	elif [[ ${ssr_method} == "11" ]]; then
		ssr_method="aes-128-cfb8"
	elif [[ ${ssr_method} == "12" ]]; then
		ssr_method="aes-192-cfb8"
	elif [[ ${ssr_method} == "13" ]]; then
		ssr_method="aes-256-cfb8"
	elif [[ ${ssr_method} == "14" ]]; then
		ssr_method="salsa20"
	elif [[ ${ssr_method} == "15" ]]; then
		ssr_method="chacha20"
	elif [[ ${ssr_method} == "16" ]]; then
		ssr_method="chacha20-ietf"
	else
		ssr_method="aes-128-ctr"
	fi
	echo && echo ${Separator_1} && echo -e "	加密 : ${Green_font_prefix}${ssr_method}${Font_color_suffix}" && echo ${Separator_1} && echo
#-----------------------------------------------------------------------------------------
	echo -e "请选择要设置的ShadowsocksR账号 混淆插件
 ${Green_font_prefix}1.${Font_color_suffix} plain
 ${Green_font_prefix}2.${Font_color_suffix} http_simple
 ${Green_font_prefix}3.${Font_color_suffix} http_post
 ${Green_font_prefix}4.${Font_color_suffix} random_head
 ${Green_font_prefix}5.${Font_color_suffix} tls1.2_ticket_auth
 ${Tip} 如果使用 ShadowsocksR 加速游戏，请选择 混淆兼容原版或 plain 混淆，然后客户端选择 plain，否则会增加延迟 !
 另外, 如果你选择了 tls1.2_ticket_auth，那么客户端可以选择 tls1.2_ticket_fastauth，这样即能伪装又不会增加延迟 !
 如果你是在日本、美国等热门地区搭建，那么选择 plain 混淆可能被墙几率更低 !" && echo
	read -e -p "(默认: tls1.2_ticket_auth):" ssr_obfs
	[[ -z "${ssr_obfs}" ]] && ssr_obfs="5"
	if [[ ${ssr_obfs} == "1" ]]; then
		ssr_obfs="plain"
	elif [[ ${ssr_obfs} == "2" ]]; then
		ssr_obfs="http_simple"
	elif [[ ${ssr_obfs} == "3" ]]; then
		ssr_obfs="http_post"
	elif [[ ${ssr_obfs} == "4" ]]; then
		ssr_obfs="random_head"
	elif [[ ${ssr_obfs} == "5" ]]; then
		ssr_obfs="tls1.2_ticket_auth"
	else
		ssr_obfs="plain"
	fi
	echo && echo ${Separator_1} && echo -e "	混淆 : ${Green_font_prefix}${ssr_obfs}${Font_color_suffix}" && echo ${Separator_1} && echo
#----------------------------------------------------------------------------------------------------
	echo -e "请选择要设置的ShadowsocksR账号 协议插件	
 ${Green_font_prefix}1.${Font_color_suffix} origin
 ${Green_font_prefix}2.${Font_color_suffix} auth_sha1_v4
 ${Green_font_prefix}3.${Font_color_suffix} auth_aes128_md5
 ${Green_font_prefix}4.${Font_color_suffix} auth_aes128_sha1
 ${Green_font_prefix}5.${Font_color_suffix} auth_chain_a
 ${Green_font_prefix}6.${Font_color_suffix} auth_chain_b
 ${Tip} 如果使用 auth_chain_a 协议，请加密方式选择 none，混淆随意(建议 plain)" && echo
	read -e -p "(默认: origin):" ssr_protocol
	[[ -z "${ssr_protocol}" ]] && ssr_protocol="1"
	if [[ ${ssr_protocol} == "1" ]]; then
		ssr_protocol="origin"
	elif [[ ${ssr_protocol} == "2" ]]; then
		ssr_protocol="auth_sha1_v4"
	elif [[ ${ssr_protocol} == "3" ]]; then
		ssr_protocol="auth_aes128_md5"
	elif [[ ${ssr_protocol} == "4" ]]; then
		ssr_protocol="auth_aes128_sha1"
	elif [[ ${ssr_protocol} == "5" ]]; then
		ssr_protocol="auth_chain_a"
	elif [[ ${ssr_protocol} == "6" ]]; then
		ssr_protocol="auth_chain_b"
	else
		ssr_protocol="auth_sha1_v4"
	fi
	echo && echo ${Separator_1} && echo -e "	协议 : ${Green_font_prefix}${ssr_protocol}${Font_color_suffix}" && echo ${Separator_1} && echo
#---------------------------------------------------------------------------------------------------------------------
	write_config
}
install_docker(){
	
	[[ ! -z $(docker ps -a | grep $REPOSITORY | awk '{print $3}') ]] && echo -e "${Info}已经安装$NAME.请检查!" && exit 1
	echo -e "${Info}正在安装$NAME..."
	docker pull $REPOSITORY
	[[ -z $(docker images| grep $REPOSITORY | awk '{print $3}') ]] && echo -e "$Error取回镜像出现问题!" && exit 1
	make_config
	echo -e "${Info}正在启动$NAME..."	
	docker run --name $REPOSITORY -d -p $ssr_port:$ssr_port -v $CONFIG_DIR:$CONFIG_DIR --dns 8.8.8.8 $REPOSITORY
	[[ -z $(docker ps| grep $REPOSITORY | awk '{print $1}') ]] &&  echo -e "${Info}$NAME启动成功..."
	sleep 1 && clear
	install_jq
	show_user_info
	
			
}

uninstall_docker(){
	[[ ! -z $(docker ps -a | grep $REPOSITORY | awk '{print $3}') ]] && echo -e "${Info}$NAME没有安装.请检查!" && exit 1
	echo -e "${Info}正在卸载$NAME..."
	docker rm $REPOSITORY
	[[ -z $(docker images| grep $REPOSITORY | awk '{print $3}') ]] && echo -e "$Info删除完毕!" 
}

start_docker(){
	
	[[ ! -z $(docker ps| grep $REPOSITORY | awk '{print $1}') ]] && echo -e "${Info}正在启动$NAME..." && docker start $REPOSITORY
	[[ -z $(docker ps| grep $REPOSITORY | awk '{print $1}') ]] &&  echo -e "${Info}$NAME启动成功..."
}

stop_docker(){

	 [[ -z $(docker ps| grep $REPOSITORY | awk '{print $1}') ]] && echo -e "${Info}正在关闭$NAME..." && docker stop $REPOSITORY
        [[ ! -z $(docker ps| grep $REPOSITORY | awk '{print $1}') ]] &&  echo -e "${Info}$NAME关闭成功..."
}

restart_docker(){
	echo -e "${Info}正在重启$NAME..." && docker restart $REPOSITORY
	[[ -z $(docker ps| grep $REPOSITORY | awk '{print $1}') ]] &&  echo -e "${Info}$NAME启动成功..."
}

install_jq(){
	#安装jq解析器
	cd /etc/shadowsocksr
	wget -qO $JQ_BIN "https://cdn.jsdelivr.net/gh/wf09/jq/jq-linux64"
	chmod +x jq
}

get_user_info(){
	[[ ! -e $JQ_BIN ]] && echo -e "${Error}jq解析器不存在!" && exit 1
	port=`${JQ_BIN} '.server_port' ${CONFIG_JSON}`
	password=`${JQ_BIN} '.password' ${CONFIG_JSON} | sed 's/^.//;s/.$//'`
	method=`${JQ_BIN} '.method' ${CONFIG_JSON} | sed 's/^.//;s/.$//'`
	protocol=`${JQ_BIN} '.protocol' ${CONFIG_JSON} | sed 's/^.//;s/.$//'`
	obfs=`${JQ_BIN} '.obfs' ${CONFIG_JSON} | sed 's/^.//;s/.$//'`
	protocol_param=`${JQ_BIN} '.protocol_param' ${CONFIG_JSON} | sed 's/^.//;s/.$//'`
	speed_limit_per_con=`${JQ_BIN} '.speed_limit_per_con' ${CONFIG_JSON}`
	speed_limit_per_user=`${JQ_BIN} '.speed_limit_per_user' ${CONFIG_JSON}`
	connect_verbose_info=`${JQ_BIN} '.connect_verbose_info' ${CONFIG_JSON}`
}
show_user_info(){
	get_user_info
	ip=$(curl -s api.ip.sb/ip)
	echo -e " ShadowsocksR账号 配置信息：" && echo && echo $Separator_1
	echo -e " I  P\t    : ${Green_font_prefix}${ip}${Font_color_suffix}"
	echo -e " 端口\t    : ${Green_font_prefix}${port}${Font_color_suffix}"
	echo -e " 密码\t    : ${Green_font_prefix}${password}${Font_color_suffix}"
	echo -e " 加密\t    : ${Green_font_prefix}${method}${Font_color_suffix}"
	echo -e " 协议\t    : ${Red_font_prefix}${protocol}${Font_color_suffix}"
	echo -e " 混淆\t    : ${Red_font_prefix}${obfs}${Font_color_suffix}"
}
show_docker_logs(){
	docker logs $REPOSITORY
}
mannal_make_config(){
	[[ -z $(vim --version) ]] && apt-get update && apt-get install vim
	vim $CONFIG_JSON
}

#--------------------------------------------主函数入口--------------------------------------------------	

main(){
echo -e "  ShadowsocksR 一键管理脚本 Powered By fly97 ${Red_font_prefix}[v${SH_VER}]${Font_color_suffix}
${Green_font_prefix}1.${Font_color_suffix} 安装 $NAME-docker
${Green_font_prefix}2.${Font_color_suffix} 卸载 $NAME-docker
————————————
${Green_font_prefix}3.${Font_color_suffix} 启动 $NAME-docker
${Green_font_prefix}4.${Font_color_suffix} 停止 $NAME-docker
${Green_font_prefix}5.${Font_color_suffix} 重启 $NAME-docker
${Green_font_prefix}6.${Font_color_suffix} 查看 $NAME-docker日志
————————————
${Green_font_prefix}7.${Font_color_suffix} 查看 账号信息
${Green_font_prefix}8.${Font_color_suffix} 设置 用户配置
${Green_font_prefix}9.${Font_color_suffix} 手动 修改配置
${Green_font_prefix}10.${Font_color_suffix} 安装jq解析器
"
echo && read -e -p "请输入数字：" num
case "$num" in
	1)
	install_docker 
	;;
	2)
	uninstall_docker
	;;
	3)
	start_docker
	;;
	4)
	stop_docker
	;;
	5)
	restart_docker
	;;
	6)
	show_docker_logs
	;;
	7)
	show_user_info
	;;
	8)
	make_config
	;;
	9)
	mannal_make_config
	;;
	10)
	install_jq
	;;
	*)
	echo -e "${Error} 请输入正确的数字 [1-12]"
	;;
esac
}
main
