#!/bin/sh
mkdir /root/tools -p 
cd /root/tools/ &&
wget https://downloads.mysql.com/archives/get/file/mysql-5.6.41.tar.gz &&
tar xf mysql-5.6.41.tar.gz &&
cd mysql-5.6.41 &&
yum install -y ncurses-devel libaio-devel gcc gcc-c++ ncurses-devel cmake autoconf &&
useradd mysql -s /sbin/nologin -M &&
id mysql &&

cmake  .  -DCMAKE_INSTALL_PREFIX=/opt/mysql-5.6 -DMYSQL_DATADIR=/opt/mysql-5.6/data -DMYSQL_UNIX_ADDR=/opt/mysql-5.6/tmp/mysql.sock -DDEFAULT_CHARSET=utf8 -DDEFAULT_COLLATION=utf8_general_ci -DEXTRA_CHARSETS=gbk,gb2312,utf8,ascii -DENABLED_LOCAL_INFILE=ON -DWITH_INNOBASE_STORAGE_ENGINE=1 -DWITH_FEDERATED_STORAGE_ENGINE=1 -DWITH_BLACKHOLE_STORAGE_ENGINE=1 -DWITHOUT_EXAMPLE_STORAGE_ENGINE=1 -DWITHOUT_PARTITION_STORAGE_ENGINE=0 -DWITH_FAST_MUTEXES=1 -DWITH_ZLIB=bundled -DENABLED_LOCAL_INFILE=1 -DWITH_READLINE=1 -DWITH_EMBEDDED_SERVER=1 -DWITH_DEBUG=0  &&

make && make install  &&

ln -s /opt/mysql-5.6/  /opt/mysql &&
find /data -type f -name "mysql"|xargs chmod 755 &&
find /data -type f -name "mysql"|ls -l && 

chown -R mysql.mysql /data/ &&
cd /opt/mysql/scripts/ &&
./mysql_install_db --basedir=/opt/mysql/ --datadir=/data/3306/data --user=mysql &&
./mysql_install_db --basedir=/opt/mysql/ --datadir=/data/3307/data --user=mysql &&

ln -s /opt/mysql/bin/* /usr/local/sbin/ &&
echo ""> /data/3306/mysql3306.err &&
echo ""> /data/3306/mysql3306.err &&

chown -R mysql.mysql /data/3306/mysql3306.err &&
chown -R mysql.mysql /data/3306/mysql3306.err &&

/data/3306/mysql start  &&
netstat -lntup|grep 3306 &&
mysql -uroot -p -S /data/3306/mysql.sock 

