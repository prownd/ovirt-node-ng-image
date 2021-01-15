#
# THIS KICKSTART IS ONLY USED FOR BUILDING OVIRT NODE
#
#              NOT FOR INSTALLATION
#


# Network information
#network  --bootproto=dhcp --device=enp7s0 --onboot=off --ipv6=auto --no-activate
#network  --hostname=localhost.localdomain
#url --mirrorlist=http://10.10.1.191/repo/BaseOS
#url --url=http://10.10.1.191/repo/BaseOS
#repo --name="AppStream" --baseurl=http://10.10.1.191/repo/AppStream --install
#repo --name="ovirt4.4" --baseurl=http://10.10.1.191/repo/ovirt4.4 --install
#repo --name="PowerTools" --baseurl=http://10.10.1.191/repo/PowerTools --install


url --url=http://10.10.3.101/superredos/8.3.2012/BaseOS/x86_64/os
repo --name="AppStream" --baseurl=http://10.10.3.101/superredos/8.3.2012/AppStream/x86_64/os
repo --name="ovirt4.4" --baseurl=http://10.10.1.191/repo/ovirt4.4 
repo --name="kernel4.19" --baseurl=http://10.10.1.191/repo/kernel4.19 
repo --name="PowerTools" --baseurl=http://10.10.3.101/superredos/8.3.2012/PowerTools/x86_64/os

lang en_US.UTF-8
keyboard us
#timezone --utc Etc/UTC
timezone Asia/Shanghai --isUtc --nontp
network --noipv6
#network  --bootproto=dhcp
auth --enableshadow --passalgo=sha512
selinux --enforcing
rootpw --lock
firstboot --reconfig
clearpart --all --initlabel
bootloader --timeout=1
part / --size=5120 --fstype=ext4 --fsoptions=discard
poweroff



#module --name=javapackages-tools
#module --name=pki-deps
#module --name=postgresql --stream=12
#module --name=virt
# Root password
#rootpw --iscrypted $6$wOXTo3Fb62hMrCw5$GvTtXkwHb1qAdKobsL1XzvUvoaFlo5KWul./0z89isEa8xewpm8Mdh6cMBgpi9xASIZ6R.gJECBSX6TB197nT.
# Run the Setup Agent on first boot
#firstboot --enable
# Do not configure the X Window System
#skipx
# System services
#services --enabled="chronyd"
# System timezone
#timezone America/New_York --isUtc
#user --groups=wheel --name=tom --password=$6$iWGJT1hNtS7ObNFp$wi7JBJUcK2lQt2Vo0H/Au.ldSQ0V7iquvQ4YY833r.3JOkNEECDLgPozxbQVwoHn6MCGjbcsDiNrinVa4EWz40 --iscrypted --gecos="tom"

%packages --excludedocs --ignoremissing --excludeWeakdeps
dracut-config-generic
-dracut-config-rescue
dracut-live
%end


%post --erroronfail

set -x

#echo "module_hotfixes=true" >> /etc/yum.repos.d/ovirt4.4.repo
cat >  /etc/yum.repos.d/ovirt-basic.repo<<EOF
[ovirtappstream]
name=OvirtAppStream
#baseurl=http://10.10.3.101/superredos/8.3.2012/AppStream/x86_64/os
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/8.3.2011/AppStream/x86_64/os
enabled=1
gpgcheck=0

[ovirtbaseos]
name=OvirtBaseOS
#baseurl=http://10.10.3.101/superredos/8.3.2012/BaseOS/x86_64/os
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/8.3.2011/BaseOS/x86_64/os
enabled=1
gpgcheck=0

[ovirtpowertools]
name=OvirtPowerTools
#baseurl=http://10.10.3.101/superredos/8.3.2012/PowerTools/x86_64/os
baseurl=https://mirrors.tuna.tsinghua.edu.cn/centos/8.3.2011/PowerTools/x86_64/os
enabled=1
gpgcheck=0

[ovirtkernel]
name=OvirtKernel
baseurl=http://10.10.1.191/repo/kernel4.19
enabled=1
gpgcheck=0

EOF

cat >  /etc/yum.repos.d/ovirt4.4.repo<<EOF
[ovirt4.4]
name=ovirt4.4
baseurl=http://10.10.1.191/repo/ovirt4.4
enabled=1
gpgcheck=0
module_hotfixes=true
EOF

cat >  /tmp/ovirt_install_cmd.sh<<EOF
dnf --disablerepo=*  --enablerepo=ovirtbaseos  --enablerepo=ovirtappstream  --enablerepo=ovirt4.4 --enablerepo=ovirtpowertools  --enablerepo=ovirtkernel -y makecache

sleep 1
dnf --disablerepo=*  --enablerepo=ovirtbaseos  --enablerepo=ovirtappstream  --enablerepo=ovirt4.4 --enablerepo=ovirtpowertools  --enablerepo=ovirtkernel -y module enable javapackages-tools pki-deps postgresql:12

sleep 1
dnf --disablerepo=*  --enablerepo=ovirtbaseos  --enablerepo=ovirtappstream  --enablerepo=ovirt4.4 --enablerepo=ovirtpowertools  --enablerepo=ovirtkernel -y install ovirt-engine vdsm vdsm-cli imgbased
sleep 1
dnf --disablerepo=*  --enablerepo=ovirtbaseos  --enablerepo=ovirtappstream  --enablerepo=ovirt4.4 --enablerepo=ovirtpowertools  --enablerepo=ovirtkernel -y install ovirt-engine vdsm vdsm-cli imgbased

EOF

sh   /tmp/ovirt_install_cmd.sh


#clean tmp file
/usr/bin/rm -f /tmp/ovirt_install_cmd.sh
/usr/bin/rm -f /etc/yum.repos.d/ovirt4.4.repo
/usr/bin/rm -f /etc/yum.repos.d/ovirt-basic.repo

%end

