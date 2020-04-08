#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
download_Url=$1
redhat_version_file="/etc/redhat-release"
el=$(cat $redhat_version_file|grep CentOS|grep -Eo '([0-9]+\.)+[0-9]+'|grep -Eo '^[0-9]')
get_Yum_Repo(){
	nodes=(https://mirrors.aliyun.com/centos/ http://mirrors.163.com/centos/ https://mirrors.tuna.tsinghua.edu.cn/centos/)
	i=1
	for node in ${nodes[@]}; 
	do
		start=$(date +%s.%N)
		result=$(curl --connect-timeout 5 --head -s -o /dev/null -w %{http_code} ${node})
		if [ "$result" == "200" ];then
			end=`date +%s.%N`
			start_s=`echo $start | cut -d '.' -f 1`
			start_ns=`echo $start | cut -d '.' -f 2`
			end_s=`echo $end | cut -d '.' -f 1`
			end_ns=`echo $end | cut -d '.' -f 2`
			time_micro=$(( (10#$end_s-10#$start_s)*1000000 + (10#$end_ns/1000 - 10#$start_ns/1000) ))
			time_ms=$(($time_micro/1000))
			values[$i]=$time_ms;
			urls[$time_ms]=$node
			i=$(($i+1))
			if [ $time_ms -lt 50 ];then
				break;
			fi
		fi
	done
	j=5000
	for n in ${values[@]};
	do
		if [ $j -gt $n ];then
			j=$n
		fi
		if [ $j -lt 50 ];then
			break;
		fi
	done
	if [ $j = 5000 ];then
		yumRepo='False';
		T_HOST='False'
	else
		yumRepo=${urls[$j]}
		my_tmp=$(echo $yumRepo|grep 'aliyun')
		if [ "$my_tmp" ];then
			yumRepo="aliyun"
		elif [ $(echo $yumRepo|grep '163') ];then
			yumRepo="163"
		elif [ $(echo $yumRepo|grep 'tsinghua') ];then
			yumRepo="tsinghua"
		fi

		if [ ! -f "/etc/yum.repos.d/CentOS-Base.repo.Bak" ];then 
			mv -f /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.Bak 
		fi

		wget -O /etc/yum.repos.d/CentOS-Base.repo ${download_Url}/mirrors/repo/CentOS${el}-Base-${yumRepo}.repo
		if [ "$el" == "8" ];then
			if [ ! -f "/etc/yum.repos.d/CentOS-AppStream.repo.bak" ];then
				mv -f /etc/yum.repos.d/CentOS-AppStream.repo /etc/yum.repos.d/CentOS-AppStream.repo.bak
			fi
			wget -O /etc/yum.repos.d/CentOS-AppStream.repo ${download_Url}/mirrors/repo/CentOS${el}-AppStream-${yumRepo}.repo
		fi 
		yum makecache
	fi
}
get_Yum_Repo

