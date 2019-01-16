yum install gcc patch libffi-devel python-devel  zlib-devel bzip8-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel -y $$
cd /opt &&
wget https://www.python.org/ftp/python/3.6.8/Python-3.6.8.tgz &&
tar -zxvf Python-3.6.8.tgz &&
cd  /opt/Python-3.6.8 &&
./configure --prefix=/opt/python36/ &&
make && make install &&
echo "export PTAH=/opt/python36/bin:$PTAH" >> /etc/profile  &&
source /etc/profile  

