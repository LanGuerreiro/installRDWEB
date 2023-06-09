$date= Get-Date -Format "MMddyyyy-HHmm"
Start-Transcript -Path c:\Script\RDPWEB\config01-$date.log

$myFQDN=(Get-WmiObject win32_computersystem).DNSHostName+'.'+(Get-WmiObject win32_computersystem).Domain
Write-Host "FQDN: $myFQDN" -ForegroundColor Green

Write-Host "Waiting for services runnig Sleep 120s" -ForegroundColor Green
Start-Sleep -Seconds 120

Write-Host "Set ConnectionBroker WebAccessServer SessionHost" -ForegroundColor Green
New-RDSessionDeployment -ConnectionBroker  "$myFQDN" -WebAccessServer "$myFQDN" -SessionHost "$myFQDN"

Write-Host "Set GatewayConfiguration" -ForegroundColor Green
set-RDDeploymentGatewayConfiguration -gatewaymode custom -GatewayExternalFQDN "$myFQDN" -LogonMethod AllowUserToSelectDuringConnection -UseCachedCredentials $True -BypassLocal $True -ConnectionBroker "$myFQDN" -force

Write-Host "Creating ColletcionName JUMP_CLIENT_01" -ForegroundColor Green
New-RDSessionCollection -CollectionName "JUMP_CLIENT_01" -SessionHost "$myFQDN" -CollectionDescription "Session Collector to jump customer" -ConnectionBroker "$myFQDN"

Write-Host "Publish APP" -ForegroundColor Green
New-RDRemoteApp -CollectionName "JUMP_CLIENT_01" -DisplayName "Notepad" -FilePath "C:\Windows\System32\Notepad.exe"
New-RDRemoteApp -CollectionName "JUMP_CLIENT_01" -DisplayName "Microsoft Edge" -FilePath "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"
New-RDRemoteApp -CollectionName "JUMP_CLIENT_01" -DisplayName "RDP CLIENT" -FilePath "C:\Windows\system32\mstsc.exe"

Write-Host "ADD RDGATEWAY" -ForegroundColor Green
Add-RDServer -Server "$myFQDN" -Role "RDS-GATEWAY" -ConnectionBroker "$myFQDN" -GatewayExternalFqdn "$myFQDN"

Write-Host "Creating SSL Certificate Self Signed" -ForegroundColor Green
$Path = "C:\Script\RDPWEB\SSL\SSL.pfx"   
$cert = New-SelfSignedCertificate -DnsName RDPWEB-CONT-1.sk.int -CertStoreLocation cert:\LocalMachine\My
$pwd = ConvertTo-SecureString -String "123" -Force -AsPlainText
Export-PfxCertificate -Cert $cert -FilePath C:\Script\RDPWEB\SSL\SSL.pfx -Password $pwd
Export-Certificate -Cert $cert -FilePath "C:\Script\RDPWEB\SSL\SSL.cer"

Write-Host "Set SSL RDRedirector" -ForegroundColor Green
Set-RDCertificate -Role RDRedirector -Password $pwd -ConnectionBroker "$myFQDN" -ImportPath $Path -force 
Write-Host "Set SSL RDGateway" -ForegroundColor Green
Set-RDCertificate -Role RDGateway -Password $pwd -ConnectionBroker "$myFQDN" -ImportPath $Path -force
Write-Host "Set SSL RDWebAccess" -ForegroundColor Green
Set-RDCertificate -Role RDWebAccess -Password $pwd -ConnectionBroker "$myFQDN" -ImportPath $Path -force
Write-Host "Set SSL RDPublishing" -ForegroundColor Green
Set-RDCertificate -Role RDPublishing -Password $pwd -ConnectionBroker "$myFQDN" -ImportPath $Path -force

Write-Host "Deploy RDP WEB" -ForegroundColor Green
Write-Host "Install RDWebClientManagement" -ForegroundColor Green
Install-Module -Name RDWebClientManagement -AcceptLicense -Confirm:$false -force

Write-Host "Install RDWebClientPackage" -ForegroundColor Green
Install-RDWebClientPackage -Confirm:$false

Write-Host "Import RDWebClientBrokerCert" -ForegroundColor Green
Import-RDWebClientBrokerCert "C:\Script\RDPWEB\SSL\SSL.cer"

Write-Host "Publish-RDWebClientPackage" -ForegroundColor Green
Publish-RDWebClientPackage -Type Production -Latest


Write-Host "Remove taskschedule conf01" -ForegroundColor Green 
Unregister-ScheduledTask -TaskName RDPWEB-config01 -Confirm:$false

Stop-Transcript
exit 0
