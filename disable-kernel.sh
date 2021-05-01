＃！/ bin / bash
＃自动睡眠关闭
函数 auto_sleep_off（）{
函数 check_operate（）{
                echo -e “ $ datt操作$ local_hostanme [\ 033 [33mauto-sleep \ 033 [35moff \ 033 [0m] $ success ”
        别的
                echo -e “ $ datt  $ repeat  $ local_hostaname [\ 033 [33mauto-sleep \ 033 [35moff \ 033 [0m] $ failed ”
        status = $（ cat /etc/systemd/logind.conf | grep -v \＃| grep -E “ HandleLidSwitch = ignore ” | wc -l ）
        如果[[ $ status  -ne 0]] ；然后
                echo -e “ $ datt  $ repeat > \ 033 [33mauto-sleep \ 033 [35moff \ 033 [0m < $ exits ”
        别的
                须藤SED -i ' S / \＃HandleLidSwitch =暂停/ HandleLidSwitch =忽略/克' /etc/systemd/logind.conf && \
        科幻
}

函数 check_lotus_base（）{
        如果[[ $（ dpkg --get-selections | grep linux | grep hold | wc -l ）  -ge 4]] ; 然后
               如果[[ $（使得| wc -l ）  -ne 1]] ; 然后
                        echo -e “ $ datt  $ install  $ role_base_tools  $ failed ”
                科幻
        别的
                echo -e “ $ datt  $ install  $ role_base_tools  $ failed ”
        科幻
}
函数 install_base_tools（）{
        sudo apt-mark hold $（ uname -a | awk ' {print $ 3} '）  && \
        sudo apt-mark hold $（ dpkg --get-selections | grep linux | awk ' / modules-extra / {print $ 1} '）
        sudo dpkg --configure -a && \
        sudo apt更新&&
        auto_sleep_off
}
        如果[[ $（ dpkg --get-selections | grep linux | grep hold | wc -l ）  -ge 4]] ; 然后
                如果[[ $（使得| wc -l ）  -ne 1]] ; 然后
                        install_base_tools && check_lotus_base
                        须藤apt install cpufrequtils -y
                        sudo cpufreq-set -g性能&& \
                        须藤chown ipfsjk：ipfsjk /etc/sysfs.conf
                        conf_status = $（ sudo cat /etc/sysfs.conf | grep性能| wc -l ）
                        如果[[ $ conf_status  -eq 0]] ; 然后
                                须藤回声 '装置/系统/ CPU / CPU0 / CPU频率/ scaling_governor =性能'  | tee -a /etc/sysfs.conf && \
                                echo -e “ \ 033 [36mSysfs_conf> \ 033 [32mSuper-cpu \ 033 [0m <\ 033 [32msuccess \ 033 [0m ”  || \
                                echo -e “ \ 033 [36mSysfs_conf> \ 033 [32mSuper-cpu \ 033 [0m <\ 033 [32mfailed \ 033 [0m ”
                        别的
                                echo -e “ \ 033 [36mSysfs_conf> \ 033 [33mAuto \ 033 [0m- \ 033 [32mSuper-cpu \ 033 [0m <\ 033 [33mExists \ 033 [0m ”
                        科幻
                别的
                        echo -e “ $ datt  $ f_repeat  $ role_base_tools  $ exits ”
                科幻

        别的
                install_base_tools && check_lotus_base
        科幻
}
