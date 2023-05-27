Write-Host "Set ConnectionBroker WebAccessServer SessionHost" -ForegroundColor Green
$myFQDN=(Get-WmiObject win32_computersystem).DNSHostName+'.'+(Get-WmiObject win32_computersystem).Domain

Write-Host "FQDN: $myFQDN" -ForegroundColor Green
New-RDSessionDeployment -ConnectionBroker  "$myFQDN" -WebAccessServer "$myFQDN" -SessionHost "$myFQDN"
