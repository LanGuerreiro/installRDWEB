$date= Get-Date -Format "MMddyyyy-HHmm"
Start-Transcript -Path c:\Script\RDPWEB\config01-$date.log

$myFQDN=(Get-WmiObject win32_computersystem).DNSHostName+'.'+(Get-WmiObject win32_computersystem).Domain
Write-Host "FQDN: $myFQDN" -ForegroundColor Green

Start-Sleep -Seconds 120

Write-Host "Set ConnectionBroker WebAccessServer SessionHost" -ForegroundColor Green
New-RDSessionDeployment -ConnectionBroker  "$myFQDN" -WebAccessServer "$myFQDN" -SessionHost "$myFQDN"

Write-Host "Remove taskschedule conf01" -ForegroundColor Green 
Unregister-ScheduledTask -TaskName RDPWEB-config01 -Confirm:$false

Stop-Transcript
exit 0
