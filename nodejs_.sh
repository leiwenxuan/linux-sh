cd /opt &&
wget https://npm.taobao.org/mirrors/node/v10.15.0/node-v10.15.0-linux-x64.tar.xz &&
tar xf node-v10.15.0-linux-x64.tar.xz  &&
mv node-v10.15.0-linux-x64 node-10.15  &&
ln -s node-10.15 node &&
echo 'export PATH=/opt/node/bin:$PATH' >>/etc/profile  &&
source /etc/profile 