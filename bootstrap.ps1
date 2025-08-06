# Bootstrap script for Windows setup
# Run this script first after Windows reset

Write-Host "🚀 Starting Windows setup bootstrap..." -ForegroundColor Green

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ This script must be run as Administrator!" -ForegroundColor Red
    Write-Host "Right-click PowerShell and select 'Run as Administrator'" -ForegroundColor Yellow
    exit 1
}

# Enable execution policy for scripts
Write-Host "📝 Setting execution policy..." -ForegroundColor Blue
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Install winget if not present (should be on Windows 10/11)
try {
    winget --version | Out-Null
    Write-Host "✅ winget is already installed" -ForegroundColor Green
} catch {
    Write-Host "❌ winget not found. Please install from Microsoft Store or update Windows" -ForegroundColor Red
    exit 1
}

# Enable WSL feature
Write-Host "🐧 Enabling WSL feature..." -ForegroundColor Blue
dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

# Install applications via winget
$apps = @(
    @{Name="7-Zip"; Id="7zip.7zip"},
    @{Name="Git"; Id="Git.Git"},
    @{Name="Docker Desktop"; Id="Docker.DockerDesktop"},
    @{Name="Visual Studio Code"; Id="Microsoft.VisualStudioCode"},
    @{Name="Firefox"; Id="Mozilla.Firefox"},
    @{Name="Chromium"; Id="Chromium.Chromium"},
    @{Name="Discord"; Id="Discord.Discord"}
)

foreach ($app in $apps) {
    Write-Host "📦 Installing $($app.Name)..." -ForegroundColor Blue
    winget install --id $($app.Id) --exact --silent --accept-package-agreements --accept-source-agreements
}

# Install WSL Ubuntu 24.04
Write-Host "🐧 Installing WSL and Ubuntu 24.04..." -ForegroundColor Blue
wsl --install --distribution Ubuntu-24.04

Write-Host "🎉 Windows setup completed successfully!" -ForegroundColor Green
Write-Host "⚠️  REBOOT REQUIRED for WSL to work properly" -ForegroundColor Red
Write-Host ""
Write-Host "🔄 After reboot:" -ForegroundColor Yellow
Write-Host "   • Open Ubuntu from Start Menu to configure WSL" -ForegroundColor Gray
