# This kickstart file should only be used with EL > 5 and/or Fedora > 7.
# For older versions please use the sample.ks kickstart file.

#platform=x86, AMD64, or Intel EM64T
# System authorization information
auth  --useshadow  --enablemd5
# System bootloader configuration
bootloader --append=" crashkernel=auto" --location=mbr --boot-drive=sdy
# Partition clearing information
clearpart --all --initlabel
# Use graphical install
graphical

# Firewall configuration
firewall --enabled
# Run the Setup Agent on first boot
firstboot --enable
ignoredisk --only-use=sdy
# Keyboard layouts
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8

# Use network installation
url --url=$tree
# If any cobbler repo definitions were referenced in the kickstart profile, include them here.
$yum_repo_stanza
# Network information
$SNIPPET('network_config')
# Reboot after installation
reboot

#Root password
rootpw --iscrypted $default_password_crypted
# SELinux configuration
selinux --disabled
# System timezone
timezone  Asia/Shanghai
# Install OS instead of upgrade
install
# Allow anaconda to partition the system as needed
# Disk partitioning information
part /boot --fstype="xfs" --ondisk=sdy --size=1024
part / --fstype="xfs" --ondisk=sdy --size=455784

%pre
#!/bin/bash
cat > /etc/sysconfig/network-scripts/ifcfg-bond0 <<EOF
DEVICE=bond0
TYPE=Bond
NM_CONTROLLED=no
BOOTPROTO=static
BONDING_OPTS="mode=4 miimon=100 xmit_hash_policy=layer3+4" 
USERCTL=no
ONBOOT=yes
IPADDR=10.10.193.
NETMASK=255.255.255.0
GATEWAY=10.10.193.254
EOF
cat > /etc/sysconfig/network-scripts/ifcfg-enp94s0f0 <<EOF
TYPE=Ethernet
BOOTPROTO=none
DEVICE=enp94s0f0
ONBOOT=yes
MASTER=bond0
SLAVE=yes
NM_CONTROLLED=no
EOF
cat > /etc/sysconfig/network-scripts/ifcfg-enp95s0f0 <<EOF
TYPE=Ethernet
BOOTPROTO=none
DEVICE=enp95s0f0
ONBOOT=yes
MASTER=bond0
SLAVE=yes
NM_CONTROLLED=no
EOF
%end


%packages
@^minimal
@core
kexec-tools

%end

%post
systemctl stop firewalld
systemctl disable firewalld 
systemctl stop NetworkManager
systemctl disable NetworkManager
setenforce 0
sed -i "s/SELINUX=enforcing/SELINUX=disabled/g" /etc/selinux/config
systemctl stop abrtd
systemctl disable abrtd
systemctl disable --now abrt-ccpp.service

%end
