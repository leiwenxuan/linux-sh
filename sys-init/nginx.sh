yum install pcre pcre-devel lsof -y  &&
rpm -qa pcre pcre-devel  &&
yum install openssl openssl-devel -y && 
rpm -qa openssl openssl-devel &&
mkdir -p  /root/tools &&
cd /root/tools  &&
wget -q http://nginx.org/download/nginx-1.14.2.tar.gz &&
ls
tar xf nginx-1.14.2.tar.gz  &&
cd nginx-1.14.2  &&
useradd www -s /sbin/nologin -M &&
./configure --user=www --group=www --with-http_ssl_module --with-http_stub_status_module --prefix=/opt/nginx-1.14.2 &&
echo $?  &&
make &&
make install &&
ln -s /opt/nginx-1.14.2 /opt/nginx  &&
##start Nginx 
/opt/nginx/sbin/nginx  &&
##check Port 80 &&
netstat -lntup|grep 80  &&
lsof -i :80  &&
hostname -I