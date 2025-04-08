#set page(paper: "a4")
#set par(justify: true)
#set text(
  font: "New Computer Modern",
  size: 12pt
)

= cli programs

to set ip address

```sh
sudo nmcli con mod "Wired connection 1" ipv4.addresses 192.168.1.100/24
```

set subnet mask

```sh
sudo nmcli con mod "Wired connection 1" ipv4.gateway 192.168.1.1
```

set dns server

```sh
sudo nmcli con mod "Wired connection 1" ipv4.dns "8.8.8.8 8.8.4.4"
# then restart the connection
sudo nmcli con down "Wired connection 1" && sudo nmcli con up "Wired connection 1"
```

verfiy settings using `ip a` or `ipconfig`

```sh
ip a
```

test connectivity using `ping` and `traceroute`

```sh
ping 8.8.8.8 # ping to a host
traceroute 8.8.8.8 # race the route taken by packets to a destination
```

show active network connections with `netstat`

```sh
netstat -tuln
```

show socket connections with `ss`

```sh
ss -tuln
```

disable routing table with `ip route`

```sh
ip route
```

display network interfaces with nmcli

```sh
nmcli dev status
```

configure a dns server with bind9

install bind9 and edit `/etc/bind/named.conf`

configure a DHCP server with isc-dhcp-server

install isc-dhcp-server and edit `/etc/dhcp/dhcpd.conf`

to install a ftp server get vsftpd or proftpd

to query dnf with dig

```sh
dig www.example.com
```

configure firewall with iptables, nftables, ufw.

test services with telnet or curl

```sh
curl http://www.example.com
telnet www.example.com 80
```

scanning with nmap

```sh
nmap 192.168.1.1
```

