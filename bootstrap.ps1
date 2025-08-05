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

# Install Git
Write-Host "📦 Installing Git..." -ForegroundColor Blue
winget install --id Git.Git --exact --silent --accept-package-agreements --accept-source-agreements

# Refresh PATH to use git immediately
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Install Python (needed for Ansible)
Write-Host "🐍 Installing Python..." -ForegroundColor Blue
winget install --id Python.Python.3.12 --exact --silent --accept-package-agreements --accept-source-agreements

# Refresh PATH again
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

# Install Ansible via pip
Write-Host "🔧 Installing Ansible..." -ForegroundColor Blue
python -m pip install --upgrade pip
python -m pip install ansible

# Clone the setup repository
$setupPath = "$env:USERPROFILE\windows_setup"
if (Test-Path $setupPath) {
    Write-Host "📁 Setup directory already exists, updating..." -ForegroundColor Yellow
    Set-Location $setupPath
    git pull
} else {
    Write-Host "📥 Cloning setup repository..." -ForegroundColor Blue
    git clone https://github.com/VOTRE_USERNAME/windows_setup.git $setupPath
    Set-Location $setupPath
}

Write-Host "🎉 Bootstrap completed successfully!" -ForegroundColor Green
Write-Host "📍 Setup files are in: $setupPath" -ForegroundColor Cyan
Write-Host "🚀 Next step: Run the Ansible playbook" -ForegroundColor Cyan
Write-Host "   cd $setupPath" -ForegroundColor Gray
Write-Host "   ansible-playbook playbook-windows.yml" -ForegroundColor Gray
