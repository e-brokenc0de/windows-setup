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

# Define Chocolatey packages array
$packages = @("googlechrome", "vscode", "discord", "telegram", "notepadplusplus", "jetbrainstoolbox")

# Installing packages using Chocolatey
Beautify-Output "Installing Packages using Chocolatey"
foreach ($package in $packages) {
    Write-StepMessage "Installing package $package..." $Colors["Cyan"]
    try {
        choco install $package -y --ignore-checksum *> $null
        if ($LASTEXITCODE -ne 0) {
            Write-StepMessage "Package installation failed for $package. Skipping..." $Colors["Red"]
        } else {
            Write-StepMessage "$package installed successfully!" $Colors["Green"]
        }
    } catch {
        Write-StepMessage "An error occurred while installing $package. Skipping..." $Colors["Yellow"]
    }
}

# Installing Windows features (WSL and Virtual Machine Platform)
Beautify-Output "Installing Windows Features"
Write-StepMessage "Enabling Windows Subsystem for Linux (WSL) and Virtual Machine Platform..." $Colors["Cyan"]
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -NoRestart
Write-StepMessage "Windows features installed successfully!" $Colors["Green"]

# Update WSL
Write-StepMessage "Updating WSL..." $Colors["Cyan"]
wsl --update
Write-StepMessage "WSL updated successfully!" $Colors["Green"]

# Update WSL and Install Ubuntu
Beautify-Output "Updating WSL and Installing Ubuntu"
Write-StepMessage "Updating WSL..." $Colors["Cyan"]
wsl --set-default-version 2
Write-StepMessage "WSL updated successfully!" $Colors["Green"]
Write-StepMessage "Installing Ubuntu..." $Colors["Cyan"]
wsl --install -d Ubuntu
Write-StepMessage "Ubuntu installed successfully!" $Colors["Green"]

# Download and install 922S5Proxy
Beautify-Output "Installing 922S5Proxy"
Write-StepMessage "Downloading 922S5Proxy..." $Colors["Cyan"]
$installerPath = "$env:TEMP\922S5Proxy_1.5.5.0509_1023.exe"
Invoke-WebRequest -Uri "https://dl.922proxy.com/version/202405/922S5Proxy_1.5.5.0509_1023.exe" -OutFile $installerPath
if (Test-Path $installerPath) {
    Write-StepMessage "Installing 922S5Proxy..." $Colors["Cyan"]
    Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait
    if ($LASTEXITCODE -eq 0) {
        Write-StepMessage "922S5Proxy installed successfully!" $Colors["Green"]
    } else {
        Write-StepMessage "922S5Proxy installation failed!" $Colors["Red"]
        exit 1
    }
} else {
    Write-StepMessage "Failed to download 922S5Proxy!" $Colors["Red"]
    exit 1
}

# Download and install GoLogin
Beautify-Output "Installing GoLogin"
Write-StepMessage "Downloading GoLogin..." $Colors["Cyan"]
$installerPathGoLogin = "$env:TEMP\gologin.exe"
Invoke-WebRequest -Uri "https://dl.gologin.com/gologin.exe" -OutFile $installerPathGoLogin
if (Test-Path $installerPathGoLogin) {
    Write-StepMessage "Installing GoLogin..." $Colors["Cyan"]
    Start-Process -FilePath $installerPathGoLogin -ArgumentList "/S" -Wait
    if ($LASTEXITCODE -eq 0) {
        Write-StepMessage "GoLogin installed successfully!" $Colors["Green"]
    } else {
        Write-StepMessage "GoLogin installation failed!" $Colors["Red"]
        exit 1
    }
} else {
    Write-StepMessage "Failed to download GoLogin!" $Colors["Red"]
    exit 1
}

# Install Docker using Chocolatey
Beautify-Output "Installing Docker using Chocolatey"
Write-StepMessage "Installing Docker..." $Colors["Cyan"]
try {
    choco install docker-desktop -y --ignore-checksum *> $null
    if ($LASTEXITCODE -ne 0) {
        Write-StepMessage "Docker installation failed!" $Colors["Red"]
        exit 1
    } else {
        Write-StepMessage "Docker installed successfully!" $Colors["Green"]
    }
} catch {
    Write-StepMessage "An error occurred while installing Docker. Skipping..." $Colors["Yellow"]
}

# Update all installed Chocolatey packages
Beautify-Output "Updating all installed Chocolatey packages"
Write-StepMessage "Updating all Chocolatey packages..." $Colors["Cyan"]
try {
    choco upgrade all -y *> $null
    if ($LASTEXITCODE -ne 0) {
        Write-StepMessage "Failed to update some Chocolatey packages!" $Colors["Red"]
        exit 1
    } else {
        Write-StepMessage "All Chocolatey packages updated successfully!" $Colors["Green"]
    }
} catch {
    Write-StepMessage "An error occurred while updating Chocolatey packages. Skipping..." $Colors["Yellow"]
}

# Perform Windows Update
Beautify-Output "Performing Windows Update"
Write-StepMessage "Updating Windows..." $Colors["Cyan"]
try {
    Install-WindowsUpdate -AcceptAll -AutoReboot *> $null
    if ($LASTEXITCODE -ne 0) {
        Write-StepMessage "Windows Update failed!" $Colors["Red"]
        exit 1
    } else {
        Write-StepMessage "Windows updated successfully!" $Colors["Green"]
    }
} catch {
    Write-StepMessage "An error occurred while updating Windows. Skipping..." $Colors["Yellow"]
}

# Pin applications to taskbar
Beautify-Output "Pinning applications to taskbar"
Write-StepMessage "Pinning Google Chrome, Visual Studio Code, Telegram, and Windows Terminal to the taskbar..." $Colors["Cyan"]

$taskScript = @"
\$appsToPin = @(
    'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe',
    'C:\\Users\\\$env:USERNAME\\AppData\\Local\\Programs\\Microsoft VS Code\\Code.exe',
    'C:\\Users\\\$env:USERNAME\\AppData\\Roaming\\Telegram Desktop\\Telegram.exe',
    'C:\\Program Files\\WindowsApps\\Microsoft.WindowsTerminal_8wekyb3d8bbwe\\wt.exe'
)

foreach (\$app in \$appsToPin) {
    \$shell = New-Object -ComObject shell.application
    \$folder = \$shell.Namespace((Split-Path \$app))
    \$item = \$folder.Parsename((Split-Path \$app -Leaf))
    \$verb = \$item.Verbs() | Where-Object { \$_.Name -eq 'Pin to Taskbar' }
    if (\$verb) {
        \$verb.DoIt()
    }
}
"@

$taskScriptPath = "$env:TEMP\PinAppsToTaskbar.ps1"
Set-Content -Path $taskScriptPath -Value $taskScript

$action = New-ScheduledTaskAction -Execute 'PowerShell.exe' -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$taskScriptPath`""
$trigger = New-ScheduledTaskTrigger -AtStartup
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount
$task = New-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -Settings (New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries)

Register-ScheduledTask -TaskName "PinAppsToTaskbar" -InputObject $task
Start-ScheduledTask -TaskName "PinAppsToTaskbar"
Write-StepMessage "Applications pinned to taskbar successfully!" $Colors["Green"]
