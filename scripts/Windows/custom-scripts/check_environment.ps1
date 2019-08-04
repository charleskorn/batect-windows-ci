$ErrorActionPreference = 'Stop'

function main {
    checkJava
    checkDocker
    checkPython
    checkBash
}

function runAndCaptureOutput([String]$application, [String]$arg) {
    $command = Get-Command $application

    $info = New-Object System.Diagnostics.ProcessStartInfo
    $info.FileName = $command.Source
    $info.Arguments = $arg
    $info.RedirectStandardError = $true
    $info.RedirectStandardOutput = $true
    $info.UseShellExecute = $false

    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $info
    $process.Start() | Out-Null
    $process.WaitForExit()

    $stdin = $process.StandardOutput.ReadToEnd()
    $stderr = $process.StandardError.ReadToEnd()
    
    return ($stdin + "`n" + $stderr).Trim()
}

function checkApp([String]$name, [String]$executableName, [String]$versionArg, [String]$expectedContents) {
    Write-Output "------------------------------------------------------------------------------------------------------------------"
    Write-Output "Checking $name version..."

    $versionOutput = runAndCaptureOutput $executableName $versionArg

    Write-Output $versionOutput

    if (-not ($versionOutput.Contains($expectedContents))) {
        Write-Error "Incorrect $name version installed, expected output to contain $expectedContents."
    }

    Write-Output ""
    Write-Output "OK!"
    Write-Output ""
}

function checkJava {
    checkApp 'Java' 'java' '-version' 'java version "1.8.'
}

function checkDocker {
    Write-Output "------------------------------------------------------------------------------------------------------------------"
    Write-Output "Starting Docker..."
    & $env:ProgramFiles\Docker\Docker\DockerCli.exe -Start --testftw!928374kasljf039 >$null 2>&1
    Write-Output ""

    checkApp 'Docker' 'docker' 'version' 'OS/Arch:          linux/amd64'

    docker run --rm alpine:3.10 sh -c 'echo Hello world!'

    if ($LastExitCode -ne 0) {
        Write-Error "Docker is not configured correctly"
    }
}

function checkPython {
    checkApp 'Python' 'python' '--version' 'Python 3.7'
}

function checkBash {
    checkApp 'Bash' 'bash' '--version' 'x86_64-pc-msys'
}

main