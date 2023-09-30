source config.conf
sudo apt update
sudo apt upgrade -y
yes | apt install mariadb-server
""
""
systemctl enable mariadb
systemctl start mariadb
#MARIAPASS="123"
echo -e "$MARIAPASS\n$MARIAPASS\ny\ny\ny\ny\n" | sudo mysql_secure_installation

apt -y install rabbitmq-server memcached python3-pymysql 
""
""
rabbitmqctl add_user openstack $RABBITPASS
#rabbitmqctl change_password openstack 123

rabbitmqctl set_permissions openstack ".*" ".*" ".*" 

bash ./db.sh
if [ $? -ne 0 ]; then
    echo "bash ./db.sh error"
    exit 1
fi

mv /etc/mysql/mariadb.conf.d/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf.org
wget -O /etc/mysql/mariadb.conf.d/50-server.cnf https://github.com/NguyenHNhan/Openstack/raw/main/conf/control/50-server.cnf

mv /etc/memcached.conf /etc/memcached.conf.org
wget -O /etc/memcached.conf https://github.com/NguyenHNhan/Openstack/raw/main/conf/control/memcached.conf

systemctl restart mariadb rabbitmq-server memcached

apt -y install keystone python3-openstackclient apache2 libapache2-mod-wsgi-py3 python3-oauth2client 
""
""
mv /etc/keystone/keystone.conf /etc/keystone/keystone.org
wget -O /etc/keystone/keystone.conf https://github.com/NguyenHNhan/Openstack/raw/main/conf/control/keystone.conf

su -s /bin/bash keystone -c "keystone-manage db_sync" 
keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone 
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone 
keystone-manage bootstrap --bootstrap-password $UOPENSTACK \
--bootstrap-admin-url http://$IPControl:5000/v3/ \
--bootstrap-internal-url http://$IPControl:5000/v3/ \
--bootstrap-public-url http://$IPControl:5000/v3/ \
--bootstrap-region-id RegionOne

#cai dat servername
mv /etc/apache2/apache2.conf /etc/apache2/apache2.org
wget -O /etc/apache2/apache2.conf https://github.com/NguyenHNhan/Openstack/raw/main/conf/control/apache2.conf

a2enmod wsgi
""
""
systemctl restart apache2 

#wget -O /etc/apache2/sites-available/keystone.conf https://github.com/NguyenHNhan/Openstack/raw/main/conf/sites-available/keystone.conf

export OS_PROJECT_DOMAIN_NAME=default
export OS_USER_DOMAIN_NAME=default
export OS_PROJECT_NAME=admin
export OS_USERNAME=admin
export OS_PASSWORD=$UOPENSTACK
export OS_AUTH_URL=http://$IPControl:5000/v3
export OS_IDENTITY_API_VERSION=3
export OS_IMAGE_API_VERSION=2

openstack project create --domain default --description "Service Project" service && ./user_service.sh

yes | apt-get install glance
mv /etc/glance/glance-api.conf /etc/glance/glance-api.org
wget -O /etc/glance/glance-api.conf https://github/NguyenHNhan/Openstack/raw/main/conf/control/glance-api.conf

chmod 640 /etc/glance/glance-api.conf 
chown root:glance /etc/glance/glance-api.conf 
su -s /bin/bash glance -c "glance-manage db_sync" 
systemctl restart glance-api 
systemctl enable glance-api 

apt -y install nova-api nova-conductor nova-scheduler nova-novncproxy placement-api python3-novaclient 
""
wget -O /etc/nova/nova.conf https://github/NguyenHNhan/Openstack/raw/main/conf/control/nova.conf

chmod 640 /etc/nova/nova.conf 
chgrp nova /etc/nova/nova.conf 
wget -O /etc/placement/placement.conf https://github.com/NguyenHNhan/Openstack/raw/main/conf/control/placement.conf

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

apt -y install neutron-server 
""
""
#neutron-plugin-ml2 neutron-linuxbridge-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent python3-neutronclient 

mv /etc/neutron/neutron.conf /etc/neutron/neutron.org
wget -O  /etc/neutron/neutron.conf https://github/NguyenHNhan/Openstack/raw/main/conf/control/neutron.conf

touch /etc/neutron/fwaas_driver.ini 
chmod 640 /etc/neutron/{neutron.conf,fwaas_driver.ini} 
chgrp neutron /etc/neutron/{neutron.conf,fwaas_driver.ini} 

#mv /etc/neutron/l3_agent.ini /etc/neutron/l3_agent.org
#wget -O /etc/neutron/l3_agent.ini https://github/NguyenHNhan/Openstack/raw/main/conf/l3_agent.ini

#mv /etc/neutron/dhcp_agent.ini /etc/neutron/dhcp_agent.org
#wget -O /etc/neutron/dhcp_agent.ini https://github/NguyenHNhan/Openstack/raw/main/conf/dhcp_agent.ini

#mv /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugins/ml2/ml2_conf.org
#wget -O /etc/neutron/plugins/ml2/ml2_conf.ini 

#mv /etc/neutron/plugins/ml2/linuxbridge_agent.ini /etc/neutron/plugins/ml2/linuxbridge_agent.org
#/etc/neutron/plugins/ml2/linuxbridge_agent.ini 

wget -O /etc/nova/nova.conf https://github.com/NguyenHNhan/Openstack/raw/main/conf/control/novaV2/nova.conf
systemctl restart nova-api 

mv /etc/cinder/cinder.conf /etc/cinder/cinder.conf.org
wget -O /etc/cinder/cinder.conf https://github.com/NguyenHNhan/Openstack/raw/main/conf/control/cinder.conf

chmod 640 /etc/cinder/cinder.conf

chgrp cinder /etc/cinder/cinder.conf

su -s /bin/bash cinder -c "cinder-manage db sync"

systemctl restart cinder-scheduler

systemctl enable cinder-scheduler

export OS_VOLUME_API_VERSION=3

apt -y install openstack-dashboard 
""
""
systemctl restart apache2 
cat <<EOL > openstack_vars.sh
export OS_PROJECT_DOMAIN_NAME=$OS_PROJECT_DOMAIN_NAME
export OS_USER_DOMAIN_NAME=$OS_USER_DOMAIN_NAME
export OS_PROJECT_NAME=$OS_PROJECT_NAME
export OS_USERNAME=$OS_USERNAME
export OS_PASSWORD=$OS_PASSWORD
export OS_AUTH_URL=$OS_AUTH_URL
export OS_IDENTITY_API_VERSION=$OS_IDENTITY_API_VERSION
export OS_IMAGE_API_VERSION=$OS_IMAGE_API_VERSION
export OS_VOLUME_API_VERSION=$OS_VOLUME_API_VERSION
export MARIAPASS=$MARIAPASS
export USERDB=$USERDB
export UOPENSTACK=$UOPENSTACK
export RABBITPASS=$RABBITPASS
export IPControl=$IPControl
EOL


