# Step 1: Check if Scoop is installed or install Scoop
Write-Host "Step 1: Checking Scoop installation..."
if (-not (Test-Path $env:USERPROFILE\scoop)) {
    Write-Host "Scoop is not installed. Installing Scoop..."
    iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
    Write-Host "Scoop installed successfully!"
} else {
    Write-Host "Scoop is already installed."
}

# Step 2: Install Git using Scoop
Write-Host "Step 2: Installing Git using Scoop..."
scoop install git
Write-Host "Git installed successfully!"

# Step 3: Check if Chocolatey is installed or install Chocolatey
Write-Host "Step 3: Checking Chocolatey installation..."
if (-not (Test-Path $env:ProgramData\chocolatey)) {
    Write-Host "Chocolatey is not installed. Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    Write-Host "Chocolatey installed successfully!"
} else {
    Write-Host "Chocolatey is already installed."
}

# Step 4: Install packages using Chocolatey
Write-Host "Step 4: Installing packages using Chocolatey..."
$packages = @('googlechrome', 'vscode', 'docker-desktop', 'discord', 'telegram', 'notepadplusplus', 'emeditor')
foreach ($package in $packages) {
    Write-Host "Installing $package..."
    choco install $package -y
}
Write-Host "Packages installed successfully!"
