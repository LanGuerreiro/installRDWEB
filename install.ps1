Write-Host "Set policy" -ForegroundColor Green

Set-ExecutionPolicy -ExecutionPolicy Unrestricted

Write-Host "Set firewall Role" -ForegroundColor Green
netsh advfirewall firewall add rule name='ICMP Allow incoming V4 echo request' protocol=icmpv4:8,any dir=in action=allow
#netsh advfirewall firewall add rule name='ICMP Allow incoming V6 echo request' protocol=icmpv6:8,any dir=in action=allow

Write-Host "Import Server manager" -ForegroundColor Green
Import-Module ServerManager

Write-Host "Install RDS-Connection-Broker " -ForegroundColor Green
Install-WindowsFeature RDS-Connection-Broker

Write-Host "Install RDS-Gateway" -ForegroundColor Green
Install-WindowsFeature RDS-Gateway

Write-Host "isntall RDS-RD-Server" -ForegroundColor Green
Install-WindowsFeature RDS-RD-Server

Write-Host "Install RDS-Web-Access" -ForegroundColor Green
Install-WindowsFeature RDS-Web-Access

Write-Host "Install RSAT-RDS-Tools" -ForegroundColor Green
Install-WindowsFeature RSAT-RDS-Tools

#Write-Host "Set ConnectionBroker WebAccessServer SessionHost" -ForegroundColor Green
#$myFQDN=(Get-WmiObject win32_computersystem).DNSHostName+'.'+(Get-WmiObject win32_computersystem).Domain

#Write-Host "FQDN: $myFQDN" -ForegroundColor Green
#New-RDSessionDeployment -ConnectionBroker  "$myFQDN" -WebAccessServer "$myFQDN" -SessionHost "$myFQDN"


shutdown -r -t 10
exit 0
