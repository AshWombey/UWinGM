# =================================================================================
# PowerShell Script for Safe Windows Gaming Tweaks
# Based on the guide by Patreon user "PC Gaming: Optimized"
# Script created by Gemini (Corrected Version)
# =================================================================================

# --- Перевірка запуску від імені Адміністратора ---
if (-NOT ([System.Security.Principal.WindowsPrincipal][System.Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([System.Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "Цей скрипт потрібно запустити від імені Адміністратора!"
    Write-Host "Натисніть правою кнопкою миші на файлі скрипта та виберіть 'Виконати за допомогою PowerShell'."
    Read-Host "Натисніть Enter, щоб вийти."
    exit
}

Clear-Host

# --- Допоміжна функція для меню вибору ---
function Show-Menu {
    Write-Host "Оберіть дію:" -ForegroundColor White
    Write-Host "  [1] Застосувати твік"
    Write-Host "  [2] Пропустити цей твік"
    Write-Host "  [3] Вийти зі скрипта"

    while ($true) {
        $input = Read-Host "Ваш вибір [1-3]"
        switch ($input) {
            '1' { return 'Apply' }
            '2' { return 'Skip' }
            '3' { return 'Exit' }
            default { Write-Warning "Неправильний вибір. Будь ласка, введіть 1, 2 або 3." }
        }
    }
}

# --- Функція для встановлення значення в реєстрі ---
function Set-RegistryValue {
    param(
        [string]$Path,
        [string]$Name,
        $Value,
        [string]$Type = "DWord"
    )

    Write-Host "  - Шлях: $Path" -ForegroundColor Gray
    Write-Host "  - Параметр: $Name" -ForegroundColor Gray
    Write-Host "  - Значення: $Value" -ForegroundColor Gray

    try {
        if (-not (Test-Path $Path)) {
            Write-Host "  - Створення ключа реєстру, оскільки він відсутній..." -ForegroundColor Cyan
            New-Item -Path $Path -Force -ErrorAction Stop | Out-Null
        }
        Set-ItemProperty -Path $Path -Name $Name -Value $Value -Type $Type -ErrorAction Stop
        Write-Host "[УСПІХ] Параметр '$Name' успішно встановлено." -ForegroundColor Green
    }
    catch {
        Write-Error "[ПОМИЛКА] Не вдалося встановити параметр '$Name'. Помилка: $($_.Exception.Message)"
    }
}


# =================================================================================
# ОСНОВНА ЧАСТИНА СКРИПТА
# =================================================================================

Write-Host "================================================================" -ForegroundColor Green
Write-Host "            ІНТЕРАКТИВНИЙ СКРИПТ ДЛЯ ОПТИМІЗАЦІЇ ІГОР"
Write-Host "================================================================" -ForegroundColor Green
Write-Host

# --- Твік 1: Win32PrioritySeparation ---
Write-Host "Твік #1: Оптимізація планувальника ЦП (Win32PrioritySeparation)" -ForegroundColor Yellow
Write-Host "Опис: Цей твік налаштовує процесор і систему на 'короткий, фіксований пріоритет', що призводить до помітно меншої затримки вводу, вищих показників 1% Lows FPS та більш плавного/стабільного часу кадру без недоліків для фонових програм."
Write-Host

$choice = Show-Menu
if ($choice -eq 'Apply') {
    Write-Host "`n[ДІЯ] Застосування твіку 'Win32PrioritySeparation'..." -ForegroundColor Cyan
    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\PriorityControl" -Name "Win32PrioritySeparation" -Value 0x28
}
elseif ($choice -eq 'Exit') { exit }
else { Write-Host "`nПропускаємо твік." -ForegroundColor Gray }
Read-Host "Натисніть Enter, щоб продовжити..."
Clear-Host

# --- Твік 2: DWM MPO Fix ---
Write-Host "Твік #2: Виправлення рендерингу DWM MPO (DWM MPO Fix)" -ForegroundColor Yellow
Write-Host "Опис: Виправляє випадкові проблеми з рендерингом, особливо при перемиканні програм за допомогою Alt+Tab (особливо браузерів), які можуть призводити до 'залипання' частини вікна на екрані. Також може покращити плавність анімацій у Windows в цілому."
Write-Host

$choice = Show-Menu
if ($choice -eq 'Apply') {
    Write-Host "`n[ДІЯ] Застосування твіку 'DWM MPO Fix'..." -ForegroundColor Cyan
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows\Dwm" -Name "OverlayMinFPS" -Value 0
}
elseif ($choice -eq 'Exit') { exit }
else { Write-Host "`nПропускаємо твік." -ForegroundColor Gray }
Read-Host "Натисніть Enter, щоб продовжити..."
Clear-Host

# --- Твік 3: Вимкнення Power Throttling ---
Write-Host "Твік #3: Вимкнення програмного обмеження потужності (Power Throttling)" -ForegroundColor Yellow
Write-Host "Опис: Вимикає штучне обмеження потужності, яке Windows застосовує для економії енергії. Це усуває можливі 'вузькі місця' в продуктивності ЦП/ГП під час ігор. Цей твік створює ключ реєстру, якщо він відсутній."
Write-Host

$choice = Show-Menu
if ($choice -eq 'Apply') {
    Write-Host "`n[ДІЯ] Застосування твіку 'Power Throttling'..." -ForegroundColor Cyan
    Set-RegistryValue -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -Name "PowerThrottlingOff" -Value 1
}
elseif ($choice -eq 'Exit') { exit }
else { Write-Host "`nПропускаємо твік." -ForegroundColor Gray }
Read-Host "Натисніть Enter, щоб продовжити..."
Clear-Host

# --- Твік 4: Вимкнення Network Throttling ---
Write-Host "Твік #4: Вимкнення програмного обмеження мережі (Network Throttling)" -ForegroundColor Yellow
Write-Host "Опис: Вимикає штучне обмеження пропускної здатності мережі, яке Windows застосовує для економії ресурсів."
Write-Host

$choice = Show-Menu
if ($choice -eq 'Apply') {
    Write-Host "`n[ДІЯ] Застосування твіку 'Network Throttling'..." -ForegroundColor Cyan
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "NetworkThrottlingIndex" -Value 0xffffffff
}
elseif ($choice -eq 'Exit') { exit }
else { Write-Host "`nПропускаємо твік." -ForegroundColor Gray }
Read-Host "Натисніть Enter, щоб продовжити..."
Clear-Host


# --- Твік 5: Пріоритезація ігор ---
Write-Host "Твік #5: Пріоритезація ігрових завдань (Prioritize Games)" -ForegroundColor Yellow
Write-Host "Опис: Змінює приховані налаштування Windows для надання вищого пріоритету ігровим процесам порівняно з іншими фоновими завданнями, що працює автоматично і без сторонніх програм."
Write-Host

$choice = Show-Menu
if ($choice -eq 'Apply') {
    Write-Host "`n[ДІЯ] Застосування твіку 'Prioritize Games'..." -ForegroundColor Cyan
    $gamePath = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games"
    Set-RegistryValue -Path $gamePath -Name "GPU Priority" -Value 8
    Set-RegistryValue -Path $gamePath -Name "Priority" -Value 6
    Set-RegistryValue -Path $gamePath -Name "Scheduling Category" -Value "High" -Type String
    Set-RegistryValue -Path $gamePath -Name "SFIO Priority" -Value "High" -Type String
}
elseif ($choice -eq 'Exit') { exit }
else { Write-Host "`nПропускаємо твік." -ForegroundColor Gray }
Read-Host "Натисніть Enter, щоб продовжити..."
Clear-Host

# --- Твік 6: Збільшення чутливості системи ---
Write-Host "Твік #6: Збільшення чутливості системи (System Responsiveness)" -ForegroundColor Yellow
Write-Host "Опис: За замовчуванням Windows резервує 20% ресурсів ЦП для фонових завдань. Цей твік зменшує це значення до 10%, дозволяючи системі виділяти більше ресурсів для активних завдань, таких як ігри."
Write-Host

$choice = Show-Menu
if ($choice -eq 'Apply') {
    Write-Host "`n[ДІЯ] Застосування твіку 'System Responsiveness'..." -ForegroundColor Cyan
    Set-RegistryValue -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "SystemResponsiveness" -Value 10
}
elseif ($choice -eq 'Exit') { exit }
else { Write-Host "`nПропускаємо твік." -ForegroundColor Gray }
Read-Host "Натисніть Enter, щоб продовжити..."
Clear-Host

# --- Завершення ---
Write-Host "================================================================" -ForegroundColor Green
Write-Host "            Всі твіки було оброблено."
Write-Host "Для того, щоб більшість змін набули чинності, рекомендується"
Write-Host "перезавантажити комп'ютер."
Write-Host "================================================================" -ForegroundColor Green
Read-Host "Натисніть Enter, щоб завершити."
