apt -y install nova-compute nova-compute-kvm

wget -O /etc/nova/nova.conf https://github.com/NguyenHNhan/Openstack/raw/main/conf/computer/conf/nova.conf
systemctl restart nova-compute

su -s /bin/bash nova -c "nova-manage cell_v2 discover_hosts"

openstack compute service list

apt -y install neutron-common neutron-plugin-ml2 neutron-linuxbridge-agent 

mv /etc/neutron/neutron.conf /etc/neutron/neutron.conf.org 
wget -O /etc/neutron/neutron.conf https://github.com/NguyenHNhan/Openstack/raw/main/conf/computer/neutron.conf

chmod 640 /etc/neutron/neutron.conf

chgrp neutron /etc/neutron/neutron.conf

wget -O /etc/neutron/plugins/ml2/ml2_conf.ini https://github.com/NguyenHNhan/Openstack/raw/main/conf/computer/conf/ml2_conf.ini
wget -O /etc/neutron/plugins/ml2/linuxbridge_agent.ini https://github.com/NguyenHNhan/Openstack/raw/main/conf/computer/conf/linuxbridge_agent.ini

ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini

systemctl restart nova-compute neutron-linuxbridge-agent

systemctl enable neutron-linuxbridge-agent 

#network
apt -y install neutron-common neutron-plugin-ml2 neutron-ovn-metadata-agent ovn-host openvswitch-switch
/etc/neutron/neutron.conf

chmod 640 /etc/neutron/neutron.conf

chgrp neutron /etc/neutron/neutron.conf

/etc/neutron/plugins/ml2/ml2_conf.ini

chmod 640 /etc/neutron/plugins/ml2/ml2_conf.ini
chgrp neutron /etc/neutron/plugins/ml2/ml2_conf.ini

/etc/neutron/neutron_ovn_metadata_agent.ini

/etc/default/openvswitch-switch

systemctl restart openvswitch-switch ovn-controller ovn-host
ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini
systemctl restart neutron-ovn-metadata-agent
systemctl restart nova-compute
ovs-vsctl set open . external-ids:ovn-remote=tcp:172.20.200.98:6642
ovs-vsctl set open . external-ids:ovn-encap-type=geneve
ovs-vsctl set open . external-ids:ovn-encap-ip=172.20.200.98

systemctl restart nova-api




