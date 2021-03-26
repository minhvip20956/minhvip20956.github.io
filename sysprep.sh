## SySPrep only for CentOS
## By Cong Minh
## Run with command
## curl -o sysprep.sh https://raw.githubusercontent.com/minhvip20956/minhvip20956.github.io/master/sysprep.sh && chmod +x sysprep.sh && sh sysprep.sh
##

# Disabled Firewalld
systemctl disable firewalld

# Disabled SELINUX
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

# Update OS
yum update --skip-broken -y
yum upgrade -y
yum autoremove -y

# Install Default Software and QEMU Service
yum install nano screen qemu-guest-agent -y
systemctl enable qemu-guest-agent

# Install Yum Cron
yum install yum-cron -y
sed -i 's/download_updates = no/download_updates = yes/g' /etc/yum/yum-cron.conf
sed -i 's/apply_updates = no/apply_updates = yes/g' /etc/yum/yum-cron.conf
systemctl enable yum-cron

# Clean up System
/sbin/service rsyslog stop
/sbin/service auditd stop
/bin/package-cleanup --oldkernels --count=1
/usr/bin/yum clean all
/usr/sbin/logrotate -f /etc/logrotate.conf
/bin/rm -f /var/log/*-???????? /var/log/*.gz
/bin/rm -f /var/log/dmesg.old
/bin/rm -rf /var/log/anaconda
/bin/cat /dev/null > /var/log/audit/audit.log
/bin/cat /dev/null > /var/log/wtmp
/bin/cat /dev/null > /var/log/lastlog
/bin/cat /dev/null > /var/log/grubby
/bin/rm -f /etc/machine-id
/bin/rm -f /etc/udev/rules.d/70*
/bin/sed -i '/^(HWADDR|UUID)=/d' /etc/sysconfig/network-scripts/ifcfg-e*
/bin/rm -rf /tmp/*
/bin/rm -rf /var/tmp/*
/bin/rm -f /etc/ssh/*key*
/bin/rm -f ~root/.bash_history
unset HISTFILE
/bin/rm -rf ~root/.ssh/
/bin/rm -f ~root/anaconda-ks.cfg
/bin/rm -f sysprep.sh

# System go to SysPrep Mode
history -c
sys-unconfig
