sed -i 's/SELINUX=enforcing/SELINUX=disabled/' /etc/selinux/config &&
grep SELINUX=disabled /etc/selinux/config &&
setenforce 0 &&
firewall-cmd --state   && # 查看防火墙状态
systemctl stop firewalld.service && # 停止防火墙
systemctl disable firewalld.service  # 禁止开机启动