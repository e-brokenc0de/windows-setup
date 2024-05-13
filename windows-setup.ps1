# Enhanced function to display step messages with customizable color
function Write-StepMessage {
    param(
        [string]$Message,
        [ConsoleColor]$Color
    )
    Write-Host "$Message" -ForegroundColor $Color
}

# Function to beautify the output
function Beautify-Output {
    param(
        [string]$Message
    )
    Write-Host "`n$($Message.ToUpper())" -ForegroundColor DarkCyan
}

# Improved handling of ANSI color sequences for PowerShell
$Colors = @{
    "Green" = [ConsoleColor]::Green
    "Yellow" = [ConsoleColor]::Yellow
    "Cyan" = [ConsoleColor]::Cyan
    "Red" = [ConsoleColor]::Red
}

# Installing Chocolatey and checking installation status
Beautify-Output "Installing Chocolatey"
Write-StepMessage "Checking Chocolatey installation..." $Colors["Cyan"]
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-StepMessage "Chocolatey is not installed. Installing Chocolatey..." $Colors["Yellow"]

    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-StepMessage "Chocolatey installation failed!" $Colors["Red"]
        exit 1
    } else {
        Write-StepMessage "Chocolatey installed successfully!" $Colors["Green"]
    }
} else {
    Write-StepMessage "Chocolatey is already installed." $Colors["Green"]
}

# Installing packages using Chocolatey
Beautify-Output "Installing Packages using Chocolatey"
Write-StepMessage "Installing packages..." $Colors["Cyan"]
choco install googlechrome vscode discord telegram notepadplusplus emeditor docker-desktop -y --ignore-checksum
if ($LASTEXITCODE -ne 0) {
    Write-StepMessage "Package installation failed!" $Colors["Red"]
    exit 1
} else {
    Write-StepMessage "Packages installed successfully!" $Colors["Green"]
}

# Installing Windows features (WSL and Virtual Machine Platform)
Beautify-Output "Installing Windows Features"
Write-StepMessage "Enabling Windows Subsystem for Linux (WSL) and Virtual Machine Platform..." $Colors["Cyan"]
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
Write-StepMessage "Windows features installed successfully!" $Colors["Green"]

# Update WSL and Install Ubuntu
Beautify-Output "Updating WSL and Installing Ubuntu"
Write-StepMessage "Updating WSL..." $Colors["Cyan"]
wsl --set-default-version 2
Write-StepMessage "WSL updated successfully!" $Colors["Green"]
Write-StepMessage "Installing Ubuntu..." $Colors["Cyan"]
wsl --install -d Ubuntu
Write-StepMessage "Ubuntu installed successfully!" $Colors["Green"]