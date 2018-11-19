#!/bin/bash

# Stop logging services
/sbin/service rsyslog stop 
/sbin/service auditd stop

# Remove old kernels
package-cleanup --oldkernels --count=1

# Clear yum cache
yum clean all

# Rotate and remove logs
/usr/sbin/logrotate -f /etc/logrotate.conf 
/bin/rm -f /var/log/*-???????? /var/log/*.gz 
/bin/rm -f /var/log/dmesg.old 
/bin/rm -rf /var/log/anaconda

# Truncate audit logs
/bin/cat /dev/null > /var/log/audit/audit.log 
/bin/cat /dev/null > /var/log/wtmp 
/bin/cat /dev/null > /var/log/lastlog 
/bin/cat /dev/null > /var/log/grubby

# Remove persistent udev rules
/bin/rm -f /etc/udev/rules.d/70*

# Remove unique IDs from ethernet interface files
/bin/sed -i '/^HWADDR=|UUID=/d' /etc/sysconfig/network-scripts/ifcfg-e*

# Clean /tmp directory
/bin/rm –rf /tmp/* 
/bin/rm –rf /var/tmp/*

# Remove SSH keys
/bin/rm –f /etc/ssh/*key*

# Remove root's shell history
/bin/rm -f ~root/.bash_history 
unset HISTFILE

# Remove root's SSH history
/bin/rm -rf ~root/.ssh/

# Remove other junk
/bin/rm -f ~root/anaconda-ks.cfg

# Clear bash history and shut down (note these may need to be done outside a script)
history –c 
sys-unconfig