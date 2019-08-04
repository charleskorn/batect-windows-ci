choco install docker-desktop

Write-Host "Creating DockerExchange user..."
net user DockerExchange /add

Write-Host "Installing docker-appveyor PowerShell module..."

$dockerAppVeyorPath = "$($env:USERPROFILE)\Documents\WindowsPowerShell\Modules\docker-appveyor"
New-Item $dockerAppVeyorPath -ItemType Directory -Force

(New-Object Net.WebClient).DownloadFile('https://raw.githubusercontent.com/appveyor/ci/master/scripts/docker-appveyor.psm1', "$dockerAppVeyorPath\docker-appveyor.psm1")

Remove-Module docker-appveyor -ErrorAction SilentlyContinue
Import-Module docker-appveyor

$UserModulesPath = "$($env:USERPROFILE)\Documents\WindowsPowerShell\Modules"
$PSModulePath = [Environment]::GetEnvironmentVariable('PSModulePath', 'Machine')
if(-not $PSModulePath.contains($UserModulesPath)) {
    [Environment]::SetEnvironmentVariable('PSModulePath', "$PSModulePath;$UserModulesPath", 'Machine')
}

Write-Host "Mapping docker-switch-windows.cmd to Switch-DockerWindows..."

@"
@echo off
powershell -command "Switch-DockerWindows"
"@ | Set-Content -Path "$env:ProgramFiles\Docker\Docker\resources\bin\docker-switch-windows.cmd"

Write-Host "Mapping docker-switch-linux.cmd to Switch-DockerLinux..."

@"
@echo off
powershell -command "Switch-DockerLinux"
"@ | Set-Content -Path "$env:ProgramFiles\Docker\Docker\resources\bin\docker-switch-linux.cmd"

Write-Host "Done"

$containersFeature = (Get-WindowsOptionalFeature -FeatureName Containers -Online)
if ($containersFeature -and $containersFeature.State -ne 'Enabled') {
    Write-Host "Installing Containers feature..."
    Enable-WindowsOptionalFeature -FeatureName Containers -Online -All -NoRestart
} else {
    Write-Host "Containers feature already installed."
}

if ((Get-WmiObject Win32_Processor).VirtualizationFirmwareEnabled[0] -and (Get-WmiObject Win32_Processor).SecondLevelAddressTranslationExtensions[0]) {
    Write-Host "Installing Hyper-V feature..."
    Install-WindowsFeature -Name Hyper-V -IncludeManagementTools
} else {
    Write-Error "Can't install Hyper-V: virtualization is not enabled."
}
