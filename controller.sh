
yes | apt install mariadb-server
systemctl enable mariadb
systemctl start mariadb
NEWPASSDB="123"
echo -e "$NEWPASSDB\n$NEWPASSDB\ny\ny\ny\ny\n" | sudo mysql_secure_installation

apt -y install rabbitmq-server memcached python3-pymysql 
####################
rabbitmqctl add_user openstack 123
#rabbitmqctl change_password openstack 123

rabbitmqctl set_permissions openstack ".*" ".*" ".*" 

wget -O /etc/mysql/mariadb.conf.d/50-server.cnf https://github.com/NguyenHNhan/Openstack/raw/main/conf/50-server.cnf

wget -O /etc/memcached.conf https://github.com/NguyenHNhan/Openstack/raw/main/conf/memcached.conf

apt -y install keystone python3-openstackclient apache2 libapache2-mod-wsgi-py3 python3-oauth2client 

PASSDB="123"
SQL_COMMANDS="
DROP DATABASE IF EXISTS keystone;
CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO keystone@'localhost' IDENTIFIED BY '$PASSDB';
GRANT ALL PRIVILEGES ON keystone.* TO keystone@'%' IDENTIFIED BY '$PASSDB';
FLUSH PRIVILEGES;
"
mysql <<< "$SQL_COMMANDS"
#cau hinh keystone
wget -O /etc/keystone/keystone.conf https://github.com/NguyenHNhan/Openstack/raw/main/conf/keystone.conf

su -s /bin/bash keystone -c "keystone-manage db_sync" 
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone 
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone 
keystone-manage bootstrap --bootstrap-password 123 \
--bootstrap-admin-url https://controller:5000/v3/ \
--bootstrap-internal-url https://controller:5000/v3/ \
--bootstrap-public-url https://controller:5000/v3/ \
--bootstrap-region-id RegionOne

wget -O /etc/apache2/apache2.conf https://github.com/NguyenHNhan/Openstack/raw/main/conf/apache2.conf

a2enmod wsgi

systemctl restart apache2 

#wget -O /etc/apache2/sites-available/keystone.conf https://github.com/NguyenHNhan/Openstack/raw/main/conf/sites-available/keystone.conf

export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=123
export OS_AUTH_URL=https://controller:5000/v3
export OS_IDENTITY_API_VERSION=3
#export OS_IMAGE_API_VERSION=3
#nova-api
apt-get install nova-api
systemctl restart nova-api
systemctl enable nova-api
#glancle
openstack user create --domain default --project service --password 123 glance 
openstack role add --project service --user glance admin 
openstack service create --name glance --description "OpenStack Image service" image
 openstack endpoint create --region RegionOne image public http://controller:9292

SQL_COMMANDS="
DROP DATABASE IF EXISTS glance;
CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO stackdb@'localhost' IDENTIFIED BY '$PASSDB';
GRANT ALL PRIVILEGES ON glance.* TO stackdb@'%' IDENTIFIED BY '$PASSDB';
FLUSH PRIVILEGES;
"
mysql <<< "$SQL_COMMANDS"

sudo apt-get install glance
wget -O /etc/glance/glance-api.conf https://github/NguyenHNhan/Openstack/raw/main/conf/glance-api.conf
chmod 640 /etc/glance/glance-api.conf 
chown root:glance /etc/glance/glance-api.conf 
su -s /bin/bash glance -c "glance-manage db_sync" 
systemctl restart glance-api 
systemctl enable glance-api 

#nova and placement 
openstack user create --domain default --project service --password 123 nova 
openstack role add --project service --user nova admin 
openstack user create --domain default --project service --password 123 placement 
openstack role add --project service --user placement admin 
openstack service create --name nova --description "OpenStack Compute service" compute 
openstack service create --name placement --description "OpenStack Compute Placement service" placement 
openstack endpoint create --region RegionOne compute public http://controller:8774/v2.1/%\(tenant_id\)s 
openstack endpoint create --region RegionOne placement public http://controller:8778 

PASSDB="123"

SQL_COMMANDS="
DROP DATABASE IF EXISTS nova;
CREATE DATABASE nova;
GRANT ALL PRIVILEGES ON nova.* TO stackdb@'localhost' IDENTIFIED BY '$PASSDB';
GRANT ALL PRIVILEGES ON nova.* TO stackdb@'%' IDENTIFIED BY '$PASSDB';
DROP DATABASE IF EXISTS nova_api;
CREATE DATABASE nova_api;
GRANT ALL PRIVILEGES ON nova_api.* TO stackdb@'localhost' IDENTIFIED BY '$PASSDB';
GRANT ALL PRIVILEGES ON nova_api.* TO stackdb@'%' IDENTIFIED BY '$PASSDB';
DROP DATABASE IF EXISTS placement;
CREATE DATABASE nova_cell0;
GRANT ALL PRIVILEGES ON nova_cell0.* TO stackdb@'localhost' IDENTIFIED BY '$PASSDB';
GRANT ALL PRIVILEGES ON nova_cell0.* TO stackdb@'%' IDENTIFIED BY '$PASSDB';
DROP DATABASE IF EXISTS placement;
CREATE DATABASE placement;
GRANT ALL PRIVILEGES ON placement.* TO stackdb@'localhost' IDENTIFIED BY '$PASSDB';
GRANT ALL PRIVILEGES ON placement.* TO stackdb@'%' IDENTIFIED BY '$PASSDB';
FLUSH PRIVILEGES;
"
mysql <<< "$SQL_COMMANDS"

apt -y install nova-api nova-conductor nova-scheduler nova-novncproxy placement-api python3-novaclient 
""
wget -O /etc/nova/nova.conf https://github/NguyenHNhan/Openstack/raw/main/conf/nova.conf

 chmod 640 /etc/nova/nova.conf 
 chgrp nova /etc/nova/nova.conf 
wget -O /etc/placement/placement.conf https://github/NguyenHNhan/Openstack/raw/main/conf/placement.conf

chgrp placement /etc/placement/placement.conf 
chmod 640 /etc/placement/placement.conf 

su -s /bin/bash placement -c "placement-manage db sync" 
su -s /bin/bash nova -c "nova-manage api_db sync" 
su -s /bin/bash nova -c "nova-manage cell_v2 map_cell0" 
su -s /bin/bash nova -c "nova-manage db sync" 
su -s /bin/bash nova -c "nova-manage cell_v2 create_cell --name cell1" 

systemctl restart apache2 
for service in api conductor scheduler; do
systemctl restart nova-$service
done 

apt -y install nova-compute nova-compute-kvm 
systemctl restart nova-compute nova-novncproxy 

/etc/nova/nova.conf 
openstack compute service list 

#create img
#wget http://cloud-images.ubuntu.com/releases/20.04/release/ubuntu-20.04-server-cloudimg-amd64.img 
#modprobe nbd 
#qemu-nbd --connect=/dev/nbd0 ubuntu-20.04-server-cloudimg-amd64.img 
#mount /dev/nbd0p1 /mnt 

#neutron
openstack user create --domain default --project service --password servicepassword neutron 
openstack role add --project service --user neutron admin 
openstack service create --name neutron --description "OpenStack Networking service" network 
openstack endpoint create --region RegionOne network public http://controller:9696 

SQL_COMMANDS="
DROP DATABASE IF EXISTS neutron_ml2;
CREATE DATABASE neutron_ml2;
GRANT ALL PRIVILEGES ON neutron_ml2.* TO stackdb@'localhost' IDENTIFIED BY '$PASSDB';
GRANT ALL PRIVILEGES ON neutron_ml2.* TO stackdb@'%' IDENTIFIED BY '$PASSDB';
FLUSH PRIVILEGES;"

apt -y install neutron-server neutron-plugin-ml2 neutron-linuxbridge-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent python3-neutronclient 

wget -O  /etc/neutron/neutron.conf https://github/NguyenHNhan/Openstack/raw/main/conf/neutron.conf

touch /etc/neutron/fwaas_driver.ini 
chmod 640 /etc/neutron/{neutron.conf,fwaas_driver.ini} 
chgrp neutron /etc/neutron/{neutron.conf,fwaas_driver.ini} 

wget -O /etc/neutron/l3_agent.ini https://github/NguyenHNhan/Openstack/raw/main/conf/l3_agent.ini

wget -O /etc/neutron/dhcp_agent.ini https://github/NguyenHNhan/Openstack/raw/main/conf/dhcp_agent.ini

wget -O /etc/neutron/plugins/ml2/ml2_conf.ini 
/etc/neutron/plugins/ml2/linuxbridge_agent.ini 

/etc/nova/nova.conf 
apt -y install openstack-dashboard 

