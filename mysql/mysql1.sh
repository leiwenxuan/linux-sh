ln -s /opt/mysql-5.6/  /opt/mysql &&
find /data -type f -name "mysql"|xargs chmod 755 &&
find /data -type f -name "mysql"|ls -l && 

chown -R mysql.mysql /data/ &&
cd /opt/mysql/scripts/ &&
./mysql_install_db --basedir=/opt/mysql/ --datadir=/data/3306/data --user=mysql &&

ln -s /opt/mysql/bin/* /usr/local/sbin/ &&
echo ""> /data/3306/mysql3306.err &&
chown -R mysql.mysql /data/3306/mysql3306.err &&
/data/3306/mysql start  &&
netstat -lntup|grep 3306 &&
mysql -uroot -p -S /data/3306/mysql.sock 

