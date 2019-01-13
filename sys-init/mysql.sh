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
mkdir /data/{3306,3307}/data -p &&
ln -s /opt/mysql-5.6/  /opt/mysql &&
cat>/data/3306/my.cnf<<EOF
[client]
port            = 3306
socket          = /data/3306/mysql.sock

[mysql]
no-auto-rehash

[mysqld]
user    = mysql
port    = 3306
socket  = /data/3306/mysql.sock
basedir = /opt/mysql
datadir = /data/3306/data
open_files_limit    = 1024
back_log = 600
max_connections = 800
max_connect_errors = 3000
external-locking = FALSE
max_allowed_packet =8M
sort_buffer_size = 1M
join_buffer_size = 1M
thread_cache_size = 100
thread_concurrency = 2
query_cache_size = 2M
query_cache_limit = 1M
query_cache_min_res_unit = 2k
#default_table_type = InnoDB
thread_stack = 192K
#transaction_isolation = READ-COMMITTED
tmp_table_size = 2M
max_heap_table_size = 2M
long_query_time = 1
#log_long_format
#log-error = /data/3306/error.log
#log-slow-queries = /data/3306/slow.log
pid-file = /data/3306/mysql.pid
log-bin = /data/3306/mysql-bin
relay-log = /data/3306/relay-bin
relay-log-info-file = /data/3306/relay-log.info
binlog_cache_size = 1M
max_binlog_cache_size = 1M
max_binlog_size = 2M
expire_logs_days = 7
key_buffer_size = 16M
read_buffer_size = 1M
read_rnd_buffer_size = 1M
bulk_insert_buffer_size = 1M
#myisam_sort_buffer_size = 1M
#myisam_max_sort_file_size = 10G
#myisam_max_extra_sort_file_size = 10G
#myisam_repair_threads = 1
#myisam_recover
lower_case_table_names = 1
skip-name-resolve
slave-skip-errors = 1032,1062
replicate-ignore-db=mysql

server-id = 1

innodb_additional_mem_pool_size = 4M
innodb_buffer_pool_size = 32M
innodb_data_file_path = ibdata1:10M:autoextend
innodb_file_io_threads = 4
innodb_thread_concurrency = 8
innodb_flush_log_at_trx_commit = 2
innodb_log_buffer_size = 2M
innodb_log_file_size = 4M
innodb_log_files_in_group = 3
innodb_max_dirty_pages_pct = 90
innodb_lock_wait_timeout = 120
innodb_file_per_table = 0
[mysqldump]
quick
max_allowed_packet = 2M

[mysqld_safe]
log-error=/data/3306/mysql3306.err
pid-file=/data/3306/mysqld.pid
EOF &&


cat>/data/3306/mysql<<EOF
#!/bin/sh
#chery
#email:pusichina@163.com
#blog:http://www.cnblogs.com/lemonblue/


#init
port=3306
mysql_user="root"
mysql_pwd="root1234"
CmdPath="/opt/mysql/bin"
mysql_sock="/data/${port}/mysql.sock"
#startup function
function_start_mysql()
{
    if [ ! -e "$mysql_sock" ];then
      printf "Starting MySQL...\n"
      /bin/sh ${CmdPath}/mysqld_safe --defaults-file=/data/${port}/my.cnf 2>&1 > /dev/null &
    else
      printf "MySQL is running...\n"
      exit
    fi
}

#stop function
function_stop_mysql()
{
    if [ ! -e "$mysql_sock" ];then
       printf "MySQL is stopped...\n"
       exit
    else
       printf "Stoping MySQL...\n"
       ${CmdPath}/mysqladmin -u ${mysql_user} -p${mysql_pwd} -S /data/${port}/mysql.sock shutdown
   fi
}

#restart function
function_restart_mysql()
{
    printf "Restarting MySQL...\n"
    function_stop_mysql
    sleep 2
    function_start_mysql
}

case $1 in
start)
    function_start_mysql
;;
stop)
    function_stop_mysql
;;
restart)
    function_restart_mysql
;;
*)
    printf "Usage: /data/${port}/mysql {start|stop|restart}\n"
esac
EOF &&

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

