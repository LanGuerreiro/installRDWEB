Set-ExecutionPolicy -ExecutionPolicy Unrestricted

netsh advfirewall firewall add rule name='ICMP Allow incoming V4 echo request' protocol=icmpv4:8,any dir=in action=allow
netsh advfirewall firewall add rule name='ICMP Allow incoming V6 echo request' protocol=icmpv6:8,any dir=in action=allow

Import-Module ServerManager
Install-WindowsFeature RDS-Connection-Broker
Install-WindowsFeature RDS-Gateway
Install-WindowsFeature RDS-RD-Server
Install-WindowsFeature RDS-Web-Access
Install-WindowsFeature RSAT-RDS-Tools

$myFQDN=(Get-WmiObject win32_computersystem).DNSHostName+'.'+(Get-WmiObject win32_computersystem).Domain
New-RDSessionDeployment -ConnectionBroker $myFQDN' -WebAccessServer '$myFQDN' -SessionHost '$myFQDN'


shutdown -r -t 10
exit 0
