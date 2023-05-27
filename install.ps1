netsh advfirewall firewall add rule name='ICMP Allow incoming V4 echo request' protocol=icmpv4:8,any dir=in action=allow
netsh advfirewall firewall add rule name='ICMP Allow incoming V6 echo request' protocol=icmpv6:8,any dir=in action=allow

Import-Module ServerManager
Install-WindowsFeature RDS-Connection-Broker
Install-WindowsFeature RDS-Gateway
Install-WindowsFeature RDS-RD-Server
Install-WindowsFeature RDS-Web-Access
Install-WindowsFeature RSAT-RDS-Tools

shutdown -r -t 10
exit 0
