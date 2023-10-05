[DEFAULT]
interface_driver = neutron.agent.linux.interface.OVSDHCPInterfaceDriver
systemctl status neutron-dhcp-agent
journalctl -u neutron-dhcp-agent
/etc/neutron/dhcp_agent.ini
Control Node
HOST_IP=172.20.200.7
FLAT_INTERFACE=enp0s31f6
FIXED_RANGE=10.1.0.0/24
FIXED_NETWORK_SIZE=256

SERVICE_HOST=172.20.200.7
DATABASE_HOST=172.20.200.7
RABBIT_HOST=172.20.200.7
MEMCACHED_SERVERS=172.20.200.7:11211

Compute Node
HOST_IP=172.20.200.8
SERVICE_HOST=172.20.200.7

FLAT_INTERFACE=enp0s31f6
FIXED_RANGE=10.1.0.0/24
FIXED_NETWORK_SIZE=256

Network Node
HOST_IP=172.20.200.9
SERVICE_HOST=172.20.200.7

FLAT_INTERFACE=enp0s31f6
FIXED_RANGE=10.1.0.0/24
FIXED_NETWORK_SIZE=256

