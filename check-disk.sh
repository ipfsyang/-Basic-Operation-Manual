#!/bin/bash
#############
#
#check_disk.sh
#
#check::local-disk list
#
#############
function check_hdd {
	rm -rf hdd.txt
	HDD_FILE=$HOME/hdd.txt
	disk_list=($(lsblk -l|grep disk|grep sd|grep -v 447|awk '{print $1}'))
	echo -e "Local-HDD[\033[36m${#disk_list[@]}\033[0m]:"
	for ((i=0;i<${#disk_list[@]};i++));do
		echo -e "/dev/${disk_list[i]}" >>$HDD_FILE
	done
	echo -e "\033[34m$(cat $HDD_FILE)\033[0m"
}
function check_nvme {
	rm -rf nvme.txt
	NVME_FILE=$HOME/nvme.txt
	disk_list=($(lsblk -l|grep disk|grep nvme|awk '{print $1}'))
	echo -e "Local-NVME[\033[36m${#disk_list[@]}\033[0m]"
	for ((i=0;i<${#disk_list[@]};i++));do
		echo -e "/dev/${disk_list[i]}" >>$NVME_FILE
	done
	echo -e "\033[34m$(cat $NVME_FILE)\033[0m"
}
case $1 in
	hdd)
		check_hdd
		exit 0;;
	nvme)
		check_nvme
		exit 0;;
	*)
		echo -e "\033[36mcheck_disk.sh\033[0m [COMMAND]\nUsage:"
		echo -e " hdd   :  check local HDD disk list info..."
		echo -e " nvme :  check local-nvme disk list info..."
		exit 0;;
esac
