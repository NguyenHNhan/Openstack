# Openstack
    Control Node:
        neutron-server: Dịch vụ Neutron Server sẽ chạy trên control node để quản lý cơ sở dữ liệu và giao tiếp với các thành phần khác của OpenStack.

    Network Node:
        neutron-plugin-ml2: Plugin mạng ML2 cho Neutron, được sử dụng để quản lý mạng trong Neutron.
        neutron-linuxbridge-agent: Agent cho việc quản lý bridge mạng.
        neutron-l3-agent: Agent cho việc quản lý tính năng L3 (routing).
        neutron-dhcp-agent: Agent cho việc quản lý tính năng DHCP.
        neutron-metadata-agent: Agent cho việc quản lý tính năng metadata.

    Compute Nodes (các node compute):
        neutron-linuxbridge-agent: Agent cho việc quản lý bridge mạng.
        neutron-dhcp-agent: Agent cho việc quản lý tính năng DHCP.
