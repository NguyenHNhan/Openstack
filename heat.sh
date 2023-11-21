openstack user create --domain default --project service --password 123 heat 
openstack role add --project service --user heat admin 
openstack role create heat_stack_owner 
openstack role create heat_stack_user 
openstack role add --project admin --user admin heat_stack_owner 
openstack service create --name heat --description "Openstack Orchestration" orchestration 
openstack service create --name heat-cfn --description "Openstack Orchestration" cloudformation 
heat_api=172.20.60.100
openstack endpoint create --region RegionOne orchestration public http://$heat_api:8004/v1/%\(tenant_id\)s 
openstack endpoint create --region RegionOne cloudformation public http://$heat_api:8000/v1 
openstack domain create --description "Stack projects and users" heat 
openstack user create --domain heat --password 123 heat_domain_admin 
openstack role add --domain heat --user heat_domain_admin admin 
mysql 
create database heat; 
grant all privileges on heat.* to heat@'localhost' identified by '123'; 
grant all privileges on heat.* to heat@'%' identified by '123'; 
flush privileges; 
exit 

apt -y install heat-api heat-api-cfn heat-engine python3-heatclient python3-vitrageclient python3-zunclient 


 mv /etc/heat/heat.conf /etc/heat/heat.conf.org

 vi /etc/heat/heat.conf
# create new

[DEFAULT]
deferred_auth_method = trusts
trusts_delegated_roles = heat_stack_owner
# Heat API Host
heat_metadata_server_url = http://172.20.60.110:8000
heat_waitcondition_server_url = http://172.20.60.110:8000/v1/waitcondition
heat_watch_server_url = http://172.20.60.110:8003
heat_stack_user_role = heat_stack_user
# Heat domain name
stack_user_domain_name = heat
# Heat domain admin username
stack_domain_admin = heat_domain_admin
# Heat domain admin's password
stack_domain_admin_password = 123
# RabbitMQ connection info
transport_url = rabbit://openstack:123@172.20.60.100

# MariaDB connection info
[database]
connection = mysql+pymysql://heat:123@172.20.60.100/heat

# Keystone connection info
[clients_keystone]
auth_uri = http://172.20.60.100:5000

# Keystone connection info
[ec2authtoken]
auth_uri = http://172.20.60.100:5000

[heat_api]
bind_host = 0.0.0.0
bind_port = 8004

[heat_api_cfn]
bind_host = 0.0.0.0
bind_port = 8000

# Keystone auth info
[keystone_authtoken]
www_authenticate_uri = http://172.20.60.100:5000
auth_url = http://172.20.60.100:5000
memcached_servers = 172.20.60.100:11211
auth_type = password
project_domain_name = default
user_domain_name = default
project_name = service
username = heat
password = 123

[trustee]
auth_type = password
auth_url = http://172.20.60.100:5000
username = heat
password = 123
user_domain_name = default

 chmod 640 /etc/heat/heat.conf

 chgrp heat /etc/heat/heat.conf

 su -s /bin/bash heat -c "heat-manage db_sync"

 systemctl restart heat-api heat-api-cfn heat-engine 
