sudo ip route add 172.29.249.0/22 via 192.168.64.128
ovs-vsctl --may-exist add-br br-provider -- set bridge br-provider \
  protocols=OpenFlow13

ip address add 172.29.248.1/22 dev br-vlan

sudo sysctl net.ipv4.ip_forward
sudo iptables -t nat -A POSTROUTING -o ens33 -j MASQUERADE
sudo sh -c "iptables-save > /etc/iptables.rules"
sudo nano /etc/network/if-up.d/iptables-rules
#!/bin/sh
iptables-restore < /etc/iptables.rules

sudo chmod +x /etc/network/if-up.d/iptables-rules
