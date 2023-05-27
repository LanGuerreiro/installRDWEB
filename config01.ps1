Start-Transcript -Path c:\Script\RDPWEB\config01.log

Write-Host "Remove taskschedule conf01" -ForegroundColor Green
Unregister-ScheduledTask -TaskName RDPWEB-CONF01 -Confirm:$false

Write-Host "Set ConnectionBroker WebAccessServer SessionHost" -ForegroundColor Green
$myFQDN=(Get-WmiObject win32_computersystem).DNSHostName+'.'+(Get-WmiObject win32_computersystem).Domain

Write-Host "FQDN: $myFQDN" -ForegroundColor Green
New-RDSessionDeployment -ConnectionBroker  "$myFQDN" -WebAccessServer "$myFQDN" -SessionHost "$myFQDN"


Stop-Transcript
exit 0


$servername = 'localhost'

Invoke-Command -ComputerName $servername -ScriptBlock { 
     if (Get-ChildItem "HKLM:\Software\Microsoft\Windows\CurrentVersion\Component Based Servicing\RebootPending" -EA Ignore) { return $true }
     if (Get-Item "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\Auto Update\RebootRequired" -EA Ignore) { return $true }
     if (Get-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager" -Name PendingFileRenameOperations -EA Ignore) { return $true }
     try { 
       $util = [wmiclass]"\\.\root\ccm\clientsdk:CCM_ClientUtilities"
       $status = $util.DetermineIfRebootPending()
       if(($status -ne $null) -and $status.RebootPending){
         return $true
		 
shutdown -r -t 10 -f
Stop-Transcript
exit 0
		 
       }
     }catch{}
 
     return $false
Write-Host "Nada"

}
