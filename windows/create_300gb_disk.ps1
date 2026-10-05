<#
.SYNOPSIS
    Creates and attaches a 300GB dynamic ext4 VHDX to WSL2 for Android ROM compilation.
.DESCRIPTION
    Android ROM compilation requires a native Linux filesystem (ext4) with case sensitivity,
    symlink, and POSIX permission support. This script creates an expandable 300GB virtual disk
    on Windows, assigns the necessary WSL permissions, and mounts it into WSL2.
.NOTES
    Must be run from an elevated PowerShell console ("Run as Administrator").
#>

param (
    [string]$DiskPath = "D:\mi5-rom\mi5_build.vhdx",
    [int]$SizeMB = 307200 # 300 GB
)

# Ensure elevated administrator privileges
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    Write-Error "This script MUST be run as Administrator! Please right-click PowerShell and select 'Run as Administrator'."
    exit 1
}

$parentDir = Split-Path -Path $DiskPath -Parent
if (-not (Test-Path $parentDir)) {
    New-Item -ItemType Directory -Path $parentDir -Force | Out-Null
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " PixelGemini OS - WSL2 300GB VHDX Disk Setup" -ForegroundColor Cyan
Write-Host " Target Path: $DiskPath" -ForegroundColor Yellow
Write-Host " Max Size:    $([math]::Round($SizeMB / 1024, 2)) GB (Dynamic/Expandable)" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

# 1. Create Expandable VHDX
if (Test-Path $DiskPath) {
    Write-Host "[*] VHDX file already exists at $DiskPath. Skipping creation." -ForegroundColor Green
} else {
    Write-Host "[*] Creating dynamic VHDX using diskpart..." -ForegroundColor Yellow
    $diskpartScript = @"
create vdisk file="$DiskPath" maximum=$SizeMB type=expandable
exit
"@
    $tempScript = Join-Path $env:TEMP "create_vdisk_mi5.txt"
    Set-Content -Path $tempScript -Value $diskpartScript -Encoding ASCII
    diskpart /s $tempScript | Out-Null
    Remove-Item -Force $tempScript
    Write-Host "[+] VHDX successfully created!" -ForegroundColor Green
}

# 2. Grant WSL Virtual Machine Permissions
Write-Host "[*] Configuring ACL permissions for WSL service account..." -ForegroundColor Yellow
icacls $parentDir /grant "*S-1-5-83-0:(OI)(CI)(F)" /t | Out-Null
icacls $DiskPath /grant "Everyone:(F)" | Out-Null
Write-Host "[+] Permissions configured successfully." -ForegroundColor Green

# 3. Mount to WSL2 as bare device
Write-Host "[*] Mounting VHDX to WSL2 as bare block device..." -ForegroundColor Yellow
try {
    wsl.exe --mount "$DiskPath" --vhd --bare
    Write-Host "[+] VHDX successfully attached to WSL2!" -ForegroundColor Green
} catch {
    Write-Warning "Failed to mount VHDX directly. Error: $_"
}

Write-Host ""
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " NEXT STEP: FORMAT AND MOUNT INSIDE WSL2 (UBUNTU)" -ForegroundColor Cyan
Write-Host " Open your Ubuntu terminal and run:" -ForegroundColor White
Write-Host ""
Write-Host "   # 1. Check which block device is 300G (usually /dev/sdg):" -ForegroundColor Yellow
Write-Host "   lsblk" -ForegroundColor Gray
Write-Host ""
Write-Host "   # 2. Format with ext4 (replace /dev/sdX with the 300G disk):" -ForegroundColor Yellow
Write-Host "   sudo mkfs.ext4 -F -L mi5_build /dev/sdX" -ForegroundColor Gray
Write-Host ""
Write-Host "   # 3. Mount and give permissions:" -ForegroundColor Yellow
Write-Host "   sudo mkdir -p /mnt/mi5workspace" -ForegroundColor Gray
Write-Host "   sudo mount /dev/sdX /mnt/mi5workspace" -ForegroundColor Gray
Write-Host "   sudo chown -R `$USER:`$USER /mnt/mi5workspace" -ForegroundColor Gray
Write-Host "==========================================================" -ForegroundColor Cyan
