 apt -y install nova-compute nova-compute-kvm

systemctl restart nova-compute

su -s /bin/bash nova -c "nova-manage cell_v2 discover_hosts"

 openstack compute service list
