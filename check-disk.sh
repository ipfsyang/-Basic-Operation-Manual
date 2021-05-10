vim check-disk.sh
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

vi bench-disk.sh
#!/bin/bash
MS=10
function ins_fio {
  echo install fio
  sudo apt install fio -y > /dev/null 2>&1
}

function bench {
  disk=$1
  echo -e "fio bench \033[35m$disk \033[32m8G write 512k $MS s\033[0m"
  sudo fio -filename=$disk -direct=1 -iodepth 32 -thread -rw=write -bs=512k -size=8G -numjobs=30 -runtime=$MS -group_reporting -name=benchtest | grep WRITE

  echo -e "fio bench \033[35m$disk \033[34m8G read 512k  $MS s\033[0m"
  sudo fio -filename=$disk -direct=1 -iodepth 32 -thread -rw=read  -bs=512k -size=8G -numjobs=30 -runtime=$MS -group_reporting -name=benchtest | grep READ
}

function main {
  ins_fio
  for di in `cat $1`; do
    bench $di
  done
}

if [ ! -n "$1" ] ;then
    echo "./bench_disk.sh  [dev_file]"
    echo "   example dev_file:"
    echo "   /dev/sda"
    echo "   /dev/sdb"
else
    main $1
fi

