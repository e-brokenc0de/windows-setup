# ANSI escape sequences for styling output
$Green = [char]27 + '[32m'
$Yellow = [char]27 + '[33m'
$Cyan = [char]27 + '[36m'
$ResetColor = [char]27 + '[0m'

# Function to display step messages with color
function Write-StepMessage {
    param(
        [string]$Message,
        [string]$Color
    )
    Write-Host "$Color$Message$ResetColor"
}

# Function to beautify the output
function Beautify-Output {
    param(
        [string]$Message
    )
    Write-Host "`n$($Message.ToUpper())" -ForegroundColor DarkCyan
}

# Step 1: Check if Scoop is installed or install Scoop
Beautify-Output "Installing Scoop"
Write-StepMessage "Checking Scoop installation..." $Cyan
if (-not (Test-Path $env:USERPROFILE\scoop)) {
    Write-StepMessage "Scoop is not installed. Installing Scoop..." $Yellow
    iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
    Write-StepMessage "Scoop installed successfully!" $Green
} else {
    Write-StepMessage "Scoop is already installed." $Green
}

# Step 2: Install Git using Scoop
Beautify-Output "Installing Git using Scoop"
Write-StepMessage "Installing Git..." $Cyan
scoop install git
Write-StepMessage "Git installed successfully!" $Green

# Step 3: Check if Chocolatey is installed or install Chocolatey
Beautify-Output "Installing Chocolatey"
Write-StepMessage "Checking Chocolatey installation..." $Cyan
if (-not (Test-Path $env:ProgramData\chocolatey)) {
    Write-StepMessage "Chocolatey is not installed. Installing Chocolatey..." $Yellow
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    Write-StepMessage "Chocolatey installed successfully!" $Green
} else {
    Write-StepMessage "Chocolatey is already installed." $Green
}

# Step 4: Install packages using Chocolatey
Beautify-Output "Installing Packages using Chocolatey"
Write-StepMessage "Installing packages..." $Cyan
choco install googlechrome vscode discord telegram notepadplusplus emeditor docker-desktop `
--source windowsfeatures `
--confirm `
--no-progress `
--use-system-powershell `
--override `
--ignore-dependencies `
--not-silent
Write-StepMessage "Packages installed successfully!" $Green
