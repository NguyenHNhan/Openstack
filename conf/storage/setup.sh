apt -y install cinder-volume python3-mysqldb

mv /etc/cinder/cinder.conf /etc/cinder/cinder.conf.org
wget -O /etc/cinder/cinder.conf https://github.com/NguyenHNhan/Openstack/raw/main/conf/storage/conf/cinder.conf

chmod 640 /etc/cinder/cinder.conf
chgrp cinder /etc/cinder/cinder.conf
systemctl restart cinder-volume
systemctl enable cinder-volume

apt -y install targetcli-fb python3-rtslib-fb

systemctl restart cinder-volume
