$date= Get-Date -Format "MMddyyyy-HHmm"
Start-Transcript -Path c:\Script\RDPWEB\config01-$date.log

$myFQDN=(Get-WmiObject win32_computersystem).DNSHostName+'.'+(Get-WmiObject win32_computersystem).Domain
Write-Host "FQDN: $myFQDN" -ForegroundColor Green

Start-Sleep -Seconds 120

Write-Host "Remove taskschedule conf01" -ForegroundColor Green 
Unregister-ScheduledTask -TaskName RDPWEB-CONF01 -Confirm:$false

Write-Host "Set ConnectionBroker WebAccessServer SessionHost" -ForegroundColor Green
New-RDSessionDeployment -ConnectionBroker  "$myFQDN" -WebAccessServer "$myFQDN" -SessionHost "$myFQDN"

Stop-Transcript
exit 0
