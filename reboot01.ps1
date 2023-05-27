$date= Get-Date -Format "MMddyyyy-HHmm"

Start-Transcript -Path c:\Script\RDPWEB\reboot -$date.log

Write-Host "Tasktaskschedule to continue config01" -ForegroundColor Green

$AtStartup = New-ScheduledTaskTrigger -AtStartup -RandomDelay 00:01:00
$Settings = New-ScheduledTaskSettingsSet
$Principal = New-ScheduledTaskPrincipal -UserID "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount -RunLevel Highest
$Action = New-ScheduledTaskAction -Execute 'powershell.exe' -Argument '-NonInteractive -NoLogo -NoProfile -ExecutionPolicy Bypass -File "c:\Script\RDPWEB\config01.ps1"'
$Task = New-ScheduledTask -Trigger $AtStartup -Settings $Settings -Action $Action -Principal $Principal
Register-ScheduledTask -TaskName "RDPWEB-config01" -InputObject $Task

Write-Host "Remove taskschedule conf01" -ForegroundColor Green 
 Unregister-ScheduledTask -TaskName RDPWEB-CONF01 -Confirm:$false

Write-Host "Rebooting" -ForegroundColor Green
shutdown -r -t 10 -f
Stop-Transcript
exit 0
