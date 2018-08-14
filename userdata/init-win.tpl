<powershell>
net user Administrator "PuppetPassword01!"

$puppet_server = "master.inf.puppet.vm"
$host_entry = "${master_ip} $puppet_server"
$host_entry | Out-File -FilePath C:\Windows\System32\Drivers\etc\hosts -Append -Encoding ascii
Start-Sleep -s 60

[Net.ServicePointManager]::ServerCertificateValidationCallback = {$true};
$webClient = New-Object System.Net.WebClient;
$webClient.DownloadFile('https://master.inf.puppet.vm:8140/packages/current/install.ps1', 'install.ps1'); .\install.ps1
</powershell>
