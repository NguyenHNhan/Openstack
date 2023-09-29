apt -y install neutron-plugin-ml2 neutron-linuxbridge-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent python3-neutronclient 

wget -O /etc/neutron/neutron.conf https://github.com/NguyenHNhan/Openstack/raw/main/conf/network/neutron.conf

chmod 640 /etc/neutron/neutron.conf

chgrp neutron /etc/neutron/neutron.conf

wget -O /etc/neutron/l3_agent.ini https://github.com/NguyenHNhan/Openstack/raw/main/conf/network/l3_agent.ini

wget -O /etc/neutron/dhcp_agent.ini https://github.com/NguyenHNhan/Openstack/raw/main/conf/network/dhcp_agent.ini

wget -O /etc/neutron/plugins/ml2/ml2_conf.ini https://github.com/NguyenHNhan/Openstack/raw/main/conf/network/dhcp_agent.ini

wget -O /etc/neutron/metadata_agent.ini https://github.com/NguyenHNhan/Openstack/raw/main/conf/network/metadata_agent.ini

wget -O /etc/neutron/plugins/ml2/ml2_conf.ini https://github.com/NguyenHNhan/Openstack/raw/main/conf/network/ml2_conf.ini
wget -O /etc/neutron/plugins/ml2/linuxbridge_agent.ini https://github.com/NguyenHNhan/Openstack/raw/main/conf/network/linuxbridge_agent.ini

#/etc/nova/nova.conf

ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini

systemctl restart nova-compute neutron-linuxbridge-agent

systemctl enable neutron-linuxbridge-agent

apt -y install neutron-server neutron-plugin-ml2 python3-neutronclient ovn-central openvswitch-switch

/etc/neutron/neutron.conf
chmod 640 /etc/neutron/neutron.conf
chgrp neutron /etc/neutron/neutron.conf

/etc/neutron/plugins/ml2/ml2_conf.ini
chmod 640 /etc/neutron/plugins/ml2/ml2_conf.ini

chgrp neutron /etc/neutron/plugins/ml2/ml2_conf.ini

/etc/default/openvswitch-switch
systemctl restart openvswitch-switch
ovs-vsctl add-br br-int

ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini

su -s /bin/bash neutron -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugin.ini upgrade head"

systemctl restart ovn-central ovn-northd

ovn-nbctl set-connection ptcp:6641:[10.0.0.50] -- set connection . inactivity_probe=60000
ovn-sbctl set-connection ptcp:6642:[10.0.0.50] -- set connection . inactivity_probe=60000

systemctl restart neutron-server


#####
ovs-vsctl add-br br-eth1
ovs-vsctl add-port br-eth1 eth1
ovs-vsctl set open . external-ids:ovn-bridge-mappings=physnet1:br-eth1
openstack router create router01
openstack network create private --provider-network-type geneve
openstack subnet create private-subnet --network private \
--subnet-range 192.168.100.0/24 --gateway 192.168.100.1 \
--dns-nameserver 10.0.0.10
openstack router add subnet router01 private-subnet
openstack network create \
--provider-physical-network physnet1 \
--provider-network-type flat --external public
 openstack subnet create public-subnet \
--network public --subnet-range 10.0.0.0/24 \
--allocation-pool start=10.0.0.200,end=10.0.0.254 \
--gateway 10.0.0.1 --dns-nameserver 10.0.0.10 --no-dhcp
openstack router set router01 --external-gateway public
openstack network rbac list
openstack network rbac show 6f9d0ea4-7670-47e2-987b-47e914aa6824
openstack network list
openstack project list
netID=$(openstack network list | grep private | awk '{ print $2 }')
prjID=$(openstack project list | grep hiroshima | awk '{ print $2 }')
openstack network rbac create --target-project $prjID --type network --action access_as_shared $netID
openstack flavor list
openstack image list
openstack network list
