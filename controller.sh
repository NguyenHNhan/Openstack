source config.conf
yes | apt install mariadb-server
systemctl enable mariadb
systemctl start mariadb
#MARIAPASS="123"
echo -e "$MARIAPASS\n$MARIAPASS\ny\ny\ny\ny\n" | sudo mysql_secure_installation

apt -y install rabbitmq-server memcached python3-pymysql 

rabbitmqctl add_user openstack $RABBITPASS
#rabbitmqctl change_password openstack 123

rabbitmqctl set_permissions openstack ".*" ".*" ".*" 

wget -O /etc/mysql/mariadb.conf.d/50-server.cnf https://github.com/NguyenHNhan/Openstack/raw/main/conf/50-server.cnf

wget -O /etc/memcached.conf https://github.com/NguyenHNhan/Openstack/raw/main/conf/memcached.conf

systemctl restart mariadb rabbitmq-server memcached

apt -y install keystone python3-openstackclient apache2 libapache2-mod-wsgi-py3 python3-oauth2client 

#cau hinh keystone
wget -O /etc/keystone/keystone.conf https://github.com/NguyenHNhan/Openstack/raw/main/conf/keystone.conf

su -s /bin/bash keystone -c "keystone-manage db_sync" 
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone 
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone 
keystone-manage bootstrap --bootstrap-password 123 \
--bootstrap-admin-url http://172.20.200.7:5000/v3/ \
--bootstrap-internal-url http://172.20.200.7:5000/v3/ \
--bootstrap-public-url http://172.20.200.7:5000/v3/ \
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
export OS_AUTH_URL=http://172.20.200.7:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2

openstack project create --domain default --description "Service Project" service
#glancle
openstack user create --domain default --project service --password $UOPENSTACK glance 
openstack role add --project service --user glance admin 
openstack service create --name glance --description "OpenStack Image service" image
openstack endpoint create --region RegionOne image public http://172.20.200.7:9292



sudo apt-get install glance
wget -O /etc/glance/glance-api.conf https://github/NguyenHNhan/Openstack/raw/main/conf/glance-api.conf
chmod 640 /etc/glance/glance-api.conf 
chown root:glance /etc/glance/glance-api.conf 
su -s /bin/bash glance -c "glance-manage db_sync" 
systemctl restart glance-api 
systemctl enable glance-api 

#nova and placement 
openstack user create --domain default --project service --password $UOPENSTACK nova 
openstack role add --project service --user nova admin 
openstack user create --domain default --project service --password $UOPENSTACK placement 
openstack role add --project service --user placement admin 
openstack service create --name nova --description "OpenStack Compute service" compute 
openstack service create --name placement --description "OpenStack Compute Placement service" placement 
openstack endpoint create --region RegionOne compute public http://172.20.200.7:8774/v2.1/%\(tenant_id\)s 
openstack endpoint create --region RegionOne placement public http://172.20.200.7:8778 

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

systemctl restart nova-novncproxy 

openstack compute service list 

#neutron
openstack user create --domain default --project service --password $UOPENSTACK neutron 
openstack role add --project service --user neutron admin 
openstack service create --name neutron --description "OpenStack Networking service" network 
openstack endpoint create --region RegionOne network public http://172.20.200.7:9696 

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


