# Requires -RunAsAdministrator
# ========================================
# Universal Windows 11 Tweaks Script
# Based on Chris Titus Utility and Patreon guide (post 88124101)
# ========================================

function Require-Admin {
    if (-not ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
        ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
        Write-Warning "Скрипт потрібно запускати від імені адміністратора!"
        exit
    }
}

function Ask-Choice($title, $description) {
    Write-Host "`n=== $title ===" -ForegroundColor Cyan
    Write-Host $description -ForegroundColor Gray
    Write-Host "[1] Застосувати"
    Write-Host "[2] Пропустити"
    do {
        $choice = Read-Host "Ваш вибір (1/2)"
    } until ($choice -in @('1','2'))
    return $choice
}

Require-Admin

# ---- 1. Chris Titus Utility ----
if (Ask-Choice "Chris Titus Utility" "Інструмент для швидкого налаштування Windows (Tweaks, Apps, Config).") -eq '1') {
    Write-Host "Запускаємо Chris Titus Utility..." -ForegroundColor Yellow
    iwr -useb https://christitus.com/win | iex
    Write-Host "Chris Titus Utility виконано." -ForegroundColor Green
} else {
    Write-Host "Пропущено." -ForegroundColor DarkYellow
}

# ---- 2. OverlayMinFPS = 0 ----
if (Ask-Choice "OverlayMinFPS" "Вимикає FPS Overlay мінімального значення у DWM.") -eq '1') {
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\Dwm" -Name "OverlayMinFPS" -Value 0 -PropertyType DWord -Force
    Write-Host "OverlayMinFPS встановлено на 0." -ForegroundColor Green
}

# ---- 3. Power Throttling Off ----
if (Ask-Choice "Power Throttling" "Вимикає Power Throttling для кращої продуктивності.") -eq '1') {
    New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -Name "PowerThrottlingOff" -Value 1 -PropertyType DWord -Force
    Write-Host "Power Throttling вимкнено." -ForegroundColor Green
}

# ---- 4. NetworkThrottlingIndex ----
if (Ask-Choice "Network Throttling" "Встановлює NetworkThrottlingIndex = ffffffff.") -eq '1') {
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 0xffffffff -PropertyType DWord -Force
    Write-Host "NetworkThrottlingIndex змінено." -ForegroundColor Green
}

# ---- 5. TCP Optimizations ----
if (Ask-Choice "TCP Tweaks" "Оптимізує мережеві параметри: TTL, MaxTcpWindowSize, MaxUserPort, Tcp1323Opts, TcpMaxDupAcks, TCPTimedWaitDelay.") -eq '1') {
    $tcp = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters"
    New-ItemProperty -Path $tcp -Name "DefaultTTL" -Value 64 -PropertyType DWord -Force
    New-ItemProperty -Path $tcp -Name "GlobalMaxTcpWindowSize" -Value 65535 -PropertyType DWord -Force
    New-ItemProperty -Path $tcp -Name "MaxUserPort" -Value 65534 -PropertyType DWord -Force
    New-ItemProperty -Path $tcp -Name "Tcp1323Opts" -Value 1 -PropertyType DWord -Force
    New-ItemProperty -Path $tcp -Name "TcpMaxDupAcks" -Value 2 -PropertyType DWord -Force
    New-ItemProperty -Path $tcp -Name "TCPTimedWaitDelay" -Value 30 -PropertyType DWord -Force
    Write-Host "TCP-параметри застосовано." -ForegroundColor Green
}

# ---- 6. System Responsiveness ----
if (Ask-Choice "System Responsiveness" "Зменшує затримки системи для ігрових задач (SystemResponsiveness = 0).") -eq '1') {
    New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "SystemResponsiveness" -Value 0 -PropertyType DWord -Force
    Write-Host "SystemResponsiveness = 0 застосовано." -ForegroundColor Green
}

# ---- 7. Game Mode ----
if (Ask-Choice "Game Mode" "Увімкнення Game Mode через реєстр.") -eq '1') {
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 1 -Force
    Write-Host "Game Mode увімкнено." -ForegroundColor Green
}

# ---- 8. Power Plan ----
if (Ask-Choice "Power Plan" "Увімкнення максимального режиму продуктивності.") -eq '1') {
    powercfg -setactive SCHEME_MIN
    Write-Host "Активовано режим 'Максимальна продуктивність'." -ForegroundColor Green
}

Write-Host "`n=== Усі доступні твіки опрацьовано. ===" -ForegroundColor Cyan
