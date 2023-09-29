apt -y install nova-compute nova-compute-kvm

systemctl restart nova-compute

su -s /bin/bash nova -c "nova-manage cell_v2 discover_hosts"

openstack compute service list

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
ovs-vsctl set open . external-ids:ovn-remote=tcp:[10.0.0.50]:6642 #networknode
ovs-vsctl set open . external-ids:ovn-encap-type=geneve
ovs-vsctl set open . external-ids:ovn-encap-ip=[10.0.0.51]#computernode
