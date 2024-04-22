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

# ANSI escape sequences for styling output
$Green = [console]::ForegroundColor = "Green"
$Yellow = [console]::ForegroundColor = "Yellow"
$Cyan = [console]::ForegroundColor = "Cyan"
$ResetColor = [console]::ResetColor

# Step 3: Check if Chocolatey is installed or install Chocolatey
Beautify-Output "Installing Chocolatey"
Write-StepMessage "Checking Chocolatey installation..." $Cyan
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-StepMessage "Chocolatey is not installed. Installing Chocolatey..." $Yellow

    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) 

    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-StepMessage "Chocolatey installation failed!" $Red
        exit 1
    } else {
        Write-StepMessage "Chocolatey installed successfully!" $Green
    }
} else {
    Write-StepMessage "Chocolatey is already installed." $Green
}

# Step 4: Install packages using Chocolatey
Beautify-Output "Installing Packages using Chocolatey"
Write-StepMessage "Installing packages..." $Cyan
choco install googlechrome vscode discord telegram notepadplusplus emeditor docker-desktop -y
if ($LASTEXITCODE -ne 0) {
    Write-StepMessage "Package installation failed!" $Red
    exit 1
} else {
    Write-StepMessage "Packages installed successfully!" $Green
}

# Step 5: Install Windows features (WSL and Virtual Machine Platform)
Beautify-Output "Installing Windows Features"
Write-StepMessage "Enabling Windows Subsystem for Linux (WSL) and Virtual Machine Platform..." $Cyan
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
Write-StepMessage "Windows features installed successfully!" $Green

# Step 6: Update WSL and Install Ubuntu
Beautify-Output "Updating WSL and Installing Ubuntu"
Write-StepMessage "Updating WSL..." $Cyan
wsl --set-default-version 2
Write-StepMessage "WSL updated successfully!" $Green
Write-StepMessage "Installing Ubuntu..." $Cyan
wsl --install -d Ubuntu
Write-StepMessage "Ubuntu installed successfully!" $Green
