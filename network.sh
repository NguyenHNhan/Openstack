 apt -y install neutron-plugin-ml2 neutron-linuxbridge-agent neutron-l3-agent neutron-dhcp-agent neutron-metadata-agent python3-neutronclient 

 wget -O /etc/neutron/neutron.conf https://github.com/NguyenHNhan/Openstack/raw/main/conf/network/neutron.conf

  chmod 640 /etc/neutron/neutron.conf

   chgrp neutron /etc/neutron/neutron.conf

   /etc/neutron/plugins/ml2/ml2_conf.ini

   /etc/neutron/plugins/ml2/linuxbridge_agent.ini

   /etc/nova/nova.conf

   # ln -s /etc/neutron/plugins/ml2/ml2_conf.ini /etc/neutron/plugin.ini

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

