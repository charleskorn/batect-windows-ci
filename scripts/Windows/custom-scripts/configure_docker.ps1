# Based on https://github.com/appveyor/ci/blob/master/scripts/docker-appveyor.psm1, adapted to use C: instead of D:
$ErrorActionPreference = 'Stop'

Write-Output "Starting Docker..."
& $env:ProgramFiles\Docker\Docker\DockerCli.exe -Start --testftw!928374kasljf039 >$null 2>&1

Write-Output "Starting desktop app..."
Start-Process "$env:ProgramFiles\Docker\Docker\Docker Desktop.exe"

Write-Output "Done!"
