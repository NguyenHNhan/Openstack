openstack user create --domain default --project service --password 123 glance 
openstack role add --project service --user glance admin 
openstack service create --name glance --description "OpenStack Image service" image
openstack endpoint create --region RegionOne image public http://172.20.200.7:9292

#nova and placement 
openstack user create --domain default --project service --password 123 nova 
openstack role add --project service --user nova admin 
openstack user create --domain default --project service --password 123 placement 
openstack role add --project service --user placement admin 
openstack service create --name nova --description "OpenStack Compute service" compute 
openstack service create --name placement --description "OpenStack Compute Placement service" placement 
openstack endpoint create --region RegionOne compute public http://172.20.200.7:8774/v2.1/%\(tenant_id\)s 
openstack endpoint create --region RegionOne placement public http://172.20.200.7:8778 

#neutron
openstack user create --domain default --project service --password 123 neutron 
openstack role add --project service --user neutron admin 
openstack service create --name neutron --description "OpenStack Networking service" network 
openstack endpoint create --region RegionOne network public http://172.20.200.7:9696 

#cinder
openstack user create --domain default --project service --password 123 cinder 
openstack role add --project service --user cinder admin 
openstack service create --name cinderv3 --description "OpenStack Block Storage" volumev3 
openstack endpoint create --region RegionOne volumev3 public http://172.20.200.7:8776/v3/%\(tenant_id\)s 
