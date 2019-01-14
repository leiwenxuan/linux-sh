mkdir ~/.pip &&
cd ~/.pip &&
touch pip.conf &&
cat >> pip.conf << EOF
[global]
index-url = http://mirrors.aliyun.com/pypi/simple/
[install]
trusted-host = mirrors.aliyun.com
EOF
