<powershell>
net user Administrator "PuppetPassword01!"

$puppet_server = "master.inf.puppet.vm"
$host_entry = "${master_ip} $puppet_server"
$host_entry | Out-File -FilePath C:\Windows\System32\Drivers\etc\hosts -Append -Encoding ascii

$agent_certname = Invoke-RestMethod -Uri http://169.254.169.254/latest/meta-data/public-hostname

[Net.ServicePointManager]::ServerCertificateValidationCallback = {$true};
$webClient = New-Object System.Net.WebClient;
$webClient.DownloadFile('https://master.inf.puppet.vm:8140/packages/current/install.ps1', 'install.ps1'); .\install.ps1 "main:certname=$agent_certname"

"target_env: $target_env" | Out-File -FilePath C:\ProgramData\PuppetLabs\facter\facts.d\env.yaml

Start-Sleep -s 60
& "C:\Program Files\Puppet Labs\Puppet\bin\puppet.bat" agent -t
</powershell>
