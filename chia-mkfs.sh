#!/bin/bash
############
#use for chia_storagenode...
#chia_mkfs.sh::disks::36//mkfs.xfs
############
success="\033[32mSuccess\033[0m"
failed="\033[31mFailed\033[0m,Please check...."
error="\033[31mError\033[0m,Please check..."
disk_list=($(lsblk -l|grep 12.8T|grep disk|awk '{print $1}'))
if [[ ${#disk_list[@]} -ne 36 ]];then
	echo -e "local_disks[\033[35;5m$${#disk_list[@]}\033[0m] $error"
fi
for ((i=0;i<${#disk_list[@]};i++));do
	sudo mkfs.xfs -f /dev/${disk_list[i]} && \
	echo -e "\033[36mLocal_disk\033[0m[\033[35m${disk_list[i]}\033[0m] mkfs.xfs $success" || \
	echo -e "\033[36mLocal_disk\033[0m[\033[35m${disk_list[i]}\033[0m] mkfs.xfs $faiiled"
done
##################
#hostname-set::chia-storagenode
#chiaS-local_ip
##################
#chia-storage-node::hostname-set
sudo hostnamectl set-hostname chiaS-$(ip route|grep 'kernel'|grep '0/24'|awk -F'src' '{print $NF}'|awk '{print $1}'|awk '{gsub(/\./,"-"); nest} {print $0}') && hostname
