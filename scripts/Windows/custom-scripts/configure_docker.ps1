# Based on https://github.com/appveyor/ci/blob/master/scripts/docker-appveyor.psm1, adapted to use C: instead of D:
$ErrorActionPreference = 'Stop'

Write-Output "Removing existing share..."
Remove-SmbShare -Name C -ErrorAction SilentlyContinue -Force

Write-Output "Starting Docker..."
& $env:ProgramFiles\Docker\Docker\DockerCli.exe -Start --testftw!928374kasljf039 >$null 2>&1

Write-Output "Enabling sharing for C:\..."
& $env:ProgramFiles\Docker\Docker\DockerCli.exe -Mount=C -Username="$env:computername\$env:appveyor_user" -Password="$env:appveyor_password" --testftw!928374kasljf039 >$null 2>&1

Write-Output "Disabling firewall rule..."
Disable-NetFirewallRule -DisplayGroup "File and Printer Sharing" -Direction Inbound

Write-Output "Done!"
