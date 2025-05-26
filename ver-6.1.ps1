# Digital Developer v6.1 - GUI PowerShell Lengkap dengan 17 Fungsi

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Management

# =================== WARNA MODERN ===================
$colorPrimary       = [System.Drawing.Color]::FromArgb(33, 150, 243)
$colorPrimaryDark   = [System.Drawing.Color]::FromArgb(25, 118, 210)
$colorText          = [System.Drawing.Color]::FromArgb(33, 33, 33)
$colorBackground    = [System.Drawing.Color]::FromArgb(245, 245, 245)
$colorOutputBack    = [System.Drawing.Color]::FromArgb(230, 230, 230)
$colorSuccess       = [System.Drawing.Color]::FromArgb(27, 94, 32)
$colorError         = [System.Drawing.Color]::FromArgb(183, 28, 28)

# =================== FONT ===================
$fontTitle     = New-Object System.Drawing.Font("Segoe UI", 16, [System.Drawing.FontStyle]::Bold)
$fontRegular   = New-Object System.Drawing.Font("Segoe UI", 10)
$fontOutput    = New-Object System.Drawing.Font("Consolas", 9)

# =================== FORM UTAMA ===================
$form = New-Object Windows.Forms.Form
$form.Text = "Digital Developer"
$form.Size = New-Object Drawing.Size(850, 750)
$form.StartPosition = 'CenterScreen'
$form.BackColor = $colorBackground
$form.FormBorderStyle = 'FixedSingle'
$form.MaximizeBox = $false

# =================== LABEL TITLE ===================
$title = New-Object Windows.Forms.Label
$title.Text = "SAMBER_NYOWO_OS_FIXER v6.1"
$title.Font = $fontTitle
$title.ForeColor = $colorPrimaryDark
$title.AutoSize = $true
$title.Location = New-Object Drawing.Point(20,20)
$form.Controls.Add($title)

# =================== PANEL SCROLL MENU ===================
$scrollPanel = New-Object Windows.Forms.Panel
$scrollPanel.Location = New-Object Drawing.Point(20,60)
$scrollPanel.Size = New-Object Drawing.Size(580,400)
$scrollPanel.BackColor = [System.Drawing.Color]::White
$scrollPanel.AutoScroll = $true
$form.Controls.Add($scrollPanel)

$menuItems = @(
    "01 - Bersihkan file sampah",
    "02 - Flush DNS dan Renew IP",
    "03 - System File Checker (advanced)",
    "04 - Check Disk (easy)",
    "05 - Defragmentasi Hard Disk (easy)",
    "06 - Reset Komponen Windows Update (medium)",
    "07 - Install DirectX (grapic)" ,
    "08 - PC Info (system)" ,
    "09 - Periksa SMART Disk (healt)" ,
    "10 - Full Clean Temporary (healt)",
    "11 - Reset Jaringan",
    "12 - Update Driver (healt)",
    "13 - Backup Registry (system repair)",
    "14 - Restore Registry (system repair)",
    "15 - Install Intel Graphics Driver (grapic,driver)",
    "16 - Install AMD Ryzen Chipset (grapic,driver)",
    "17 - Install HW Info"
)

$items = @()
$y = 10
foreach ($text in $menuItems) {
    $cb = New-Object Windows.Forms.CheckBox
    $cb.Text = $text
    $cb.Font = $fontRegular
    $cb.ForeColor = $colorText
    $cb.Location = New-Object Drawing.Point(10,$y)
    $cb.Size = New-Object Drawing.Size(400,24)
    $scrollPanel.Controls.Add($cb)

    $txt = New-Object Windows.Forms.TextBox
    $txt.Location = New-Object Drawing.Point(420,$y)
    $txt.Size = New-Object Drawing.Size(130,24)
    $txt.ReadOnly = $true
    $txt.BackColor = $colorOutputBack
    $txt.ForeColor = $colorPrimaryDark
    $txt.TextAlign = 'Center'
    $scrollPanel.Controls.Add($txt)

    $items += @{Checkbox = $cb; OutputBox = $txt}
    $y += 30
}

# =================== OUTPUT TEXTBOX ===================
$output = New-Object Windows.Forms.TextBox
$output.Location = New-Object Drawing.Point(20,470)
$output.Size = New-Object Drawing.Size(580,100)
$output.Multiline = $true
$output.ScrollBars = 'Vertical'
$output.ReadOnly = $true
$output.Font = $fontOutput
$output.BackColor = $colorOutputBack
$form.Controls.Add($output)

# =================== PROGRESS BAR ===================
$progress = New-Object Windows.Forms.ProgressBar
$progress.Location = New-Object Drawing.Point(20,580)
$progress.Size = New-Object Drawing.Size(580,20)
$progress.Style = 'Continuous'
$form.Controls.Add($progress)

# =================== INFO PANEL ===================
$infoPanel = New-Object Windows.Forms.Panel
$infoPanel.Location = New-Object Drawing.Point(620,60)
$infoPanel.Size = New-Object Drawing.Size(200,540)
$infoPanel.BackColor = [System.Drawing.Color]::White
$form.Controls.Add($infoPanel)

$osBox = New-Object Windows.Forms.TextBox
$osBox.Multiline = $true
$osBox.ReadOnly = $true
$osBox.ScrollBars = 'Vertical'
$osBox.Font = $fontRegular
$osBox.BackColor = [System.Drawing.Color]::White
$osBox.ForeColor = $colorPrimaryDark
$osBox.Size = New-Object Drawing.Size(190,450)
$osBox.Location = New-Object Drawing.Point(5,5)
$infoPanel.Controls.Add($osBox)

# =================== FUNSI BUTTON MODERN ===================
function New-ModernButton($text, $x, $y, $width, $action) {
    $btn = New-Object Windows.Forms.Button
    $btn.Text = $text
    $btn.Size = New-Object Drawing.Size($width, 36)
    $btn.Location = New-Object Drawing.Point($x, $y)
    $btn.BackColor = $colorPrimary
    $btn.ForeColor = [Drawing.Color]::White
    $btn.Font = $fontRegular
    $btn.FlatStyle = 'Flat'
    $btn.FlatAppearance.BorderSize = 0

    $btn.Add_MouseEnter({ $this.BackColor = $colorPrimaryDark; $this.Cursor = 'Hand' })
    $btn.Add_MouseLeave({ $this.BackColor = $colorPrimary; $this.Cursor = 'Default' })

    $btn.Add_Click($action)
    return $btn
}

# =================== LOG OUTPUT ===================
function Write-Log($msg) {
    $output.AppendText("$msg`r`n")
    $output.SelectionStart = $output.Text.Length
    $output.ScrollToCaret()
}

# =================== FUNGSI OS INFO ===================
function Convert-DmtfDateSafe($dmtf) {
    if ([string]::IsNullOrEmpty($dmtf)) { return '-' }
    try { return [Management.ManagementDateTimeConverter]::ToDateTime($dmtf) } catch { return '-' }
}

function Get-OSInfo {
    $os = Get-CimInstance Win32_OperatingSystem
    return @(
        "OS: $($os.Caption)",
        "Version: $($os.Version)",
        "Build: $($os.BuildNumber)",
        "Arch: $($os.OSArchitecture)",
        "Install: $(Convert-DmtfDateSafe $os.InstallDate)",
        "Last Boot: $(Convert-DmtfDateSafe $os.LastBootUpTime)"
    ) -join "`r`n"
}

# =================== FUNGSI UTAMA TASK ===================
function Run-SelectedTask($index) {
    switch ($index) {
        0 { Write-Log "Membersihkan file sampah..."; Remove-Item -Path "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue }
        1 { Write-Log "Flush DNS dan Renew IP..."; ipconfig }
        2 { Write-Log "Menjalankan System File Checker..."; 
    # Jalankan sebagai Administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Silakan jalankan skrip ini sebagai Administrator." -ForegroundColor Red
    pause
    exit
}

# Lokasi log
$logPath = "$env:USERPROFILE\Desktop\SFC-Scan-Log.txt"

# Menjalankan SFC
Write-Host "Menjalankan System File Checker..." -ForegroundColor Cyan
Start-Process -FilePath "cmd.exe" -ArgumentList "/c sfc /scannow" -Verb RunAs -Wait

# Mengecek hasil dari CBS.log
$srcLog = "$env:windir\Logs\CBS\CBS.log"
$copyLog = "$env:TEMP\CBS_temp.log"

# Salin bagian terbaru CBS.log (akses hanya oleh admin)
if (Test-Path $srcLog) {
    Copy-Item $srcLog -Destination $copyLog -Force
    $sfcResults = Select-String -Path $copyLog -Pattern 'SR'
    $sfcResults | Out-File -FilePath $logPath -Encoding utf8
    Write-Host "`n✅ Scan selesai. Hasil disimpan ke: $logPath" -ForegroundColor Green
} else {
    Write-Host "⚠️ Tidak dapat menemukan CBS.log untuk melihat detail hasil scan." -ForegroundColor Yellow
}

# Tampilkan ringkasan ke layar
if ($sfcResults) {
    Write-Host "`n--- Ringkasan Hasil Scan ---`n" -ForegroundColor White
    $sfcResults | ForEach-Object { Write-Host $_.Line -ForegroundColor Gray }
}
DISM /RestoreHealth
    }
        3 { Write-Log "Menjalankan CHKDSK..."; chkdsk C: /F /R }
        4 { Write-Log "Menjalankan Defrag..."; defrag C: -f }
        5 {
            Write-Log "Reset Komponen Windows Update..."
            net stop wuauserv
            net stop bits
            Remove-Item -Path "$env:windir\SoftwareDistribution\*" -Recurse -Force -ErrorAction SilentlyContinue
            net start wuauserv
            net start bits
        }
        6 { Write-Log "Install DirectX..."; Start-Process -FilePath "https://download.microsoft.com/download/1/1/0/1105DA7D-3C3E-4D5D-B91D-D5DC822E6EB1/directx_Jun2010_redist.exe" -UseShellExecute }
        7 {
            Write-Log "Menampilkan info PC..."
            Get-ComputerInfo | Out-String | ForEach-Object { Write-Log $_ }
        }
        8 {
            Write-Log "Cek SMART Disk..."
            $smart = Get-WmiObject -Namespace root\wmi -Class MSStorageDriver_FailurePredictStatus
            if ($smart) {
                $smart | Format-List | Out-String | ForEach-Object { Write-Log $_ }
            } else {
                Write-Log "SMART Disk info tidak ditemukan."
            }
            
        }
        9 { Write-Log "Full Clean Temp..."; Remove-Item -Path "$env:LOCALAPPDATA\Temp\*" -Recurse -Force -ErrorAction SilentlyContinue }
        10 {
            Write-Log "Reset Jaringan..."
            netsh winsock reset
            netsh int ip reset
        }
        '11' {
    Write-Log "==============================================="
    Write-Log "                UPDATE DRIVER"
    Write-Log "==============================================="
    Write-Log "Memindai dan mengupdate driver melalui Windows Update..."

    try {
        if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
            Write-Log "Modul PSWindowsUpdate belum terpasang. Mengunduh..."
            Install-Module -Name PSWindowsUpdate -Force -Scope CurrentUser
        }

        Import-Module PSWindowsUpdate -Force

        # Aktifkan Microsoft Update tanpa konfirmasi
        Add-WUServiceManager -MicrosoftUpdate -Confirm:$false

        # Update driver dari Microsoft Update
        Write-Log "Memulai proses pencarian dan instalasi update driver..."
        Get-WindowsUpdate -MicrosoftUpdate -Category Drivers -Install -AcceptAll -IgnoreReboot -Verbose

        Write-Log "Update driver selesai."
    }
    catch {
        Write-Log "Terjadi kesalahan saat update driver: $_"
    }




          }
        12 { Write-Log "Backup Registry..."; reg export HKLM\Software "$env:USERPROFILE\Desktop\backup-hklm.reg" /y }
        13 { Write-Log "Restore Registry..."; reg import "$env:USERPROFILE\Desktop\backup-hklm.reg" }
        14 { Write-Log "Install Intel Graphics Driver..."; Start-Process "https://www.intel.com/content/www/us/en/download/19344/intel-graphics-windows-dch-drivers.html" -UseShellExecute }
        15 { Write-Log "Install AMD Ryzen Chipset..."; Start-Process "https://www.amd.com/en/support/chipsets/amd-socket-am4/b550" -UseShellExecute }
        16 {
            Write-Log "check for permisson in your os..."
            Set-ExecutionPolicy -Scope CurrentUser unrestricted -Force
            Write-Log "download hwinfo latest from digital developer..."
            Invoke-WebRequest https://github.com/DIFAMUKTI22/digitaldeveloper/raw/refs/heads/main/hwi64.exe -OutFile "$env:TEMP\hwinfo.exe"
            Write-Log "memulai installing hwinfo...."
            Start-Process "$env:TEMP\hwinfo.exe"
        }
        default { Write-Log "Fungsi tidak ditemukan." }
    }
}

# =================== BUTTON ===================
$form.Controls.Add((New-ModernButton "Select All" 20 620 130 {
    foreach ($item in $items) { $item.Checkbox.Checked = $true }
}))

$form.Controls.Add((New-ModernButton "Clear All" 175 620 130 {
    foreach ($item in $items) { $item.Checkbox.Checked = $false }
}))

$form.Controls.Add((New-ModernButton "Run Selected" 470 620 130 {
    $output.Clear()
    $progress.Value = 0
    $selected = $items | Where-Object { $_.Checkbox.Checked }
    if ($selected.Count -eq 0) {
        Write-Log "Tidak ada yang dipilih."
        return
    }
    $i = 0
    foreach ($item in $selected) {
        $i++
        $idx = [array]::IndexOf($items, $item)
        Write-Log "Menjalankan: $($item.Checkbox.Text)"
        try {
            Run-SelectedTask $idx
            $item.OutputBox.Text = "OK"
            $item.OutputBox.ForeColor = $colorSuccess
        } catch {
            $item.OutputBox.Text = "Error"
            $item.OutputBox.ForeColor = $colorError
        }
        Start-Sleep -Milliseconds 300
        $progress.Value = [Math]::Round(($i / $selected.Count) * 100)
    }
    Write-Log "Selesai."
    $progress.Value = 100
}))

# =================== EVENT FORM SHOWN ===================
$form.Add_Shown({
    foreach ($item in $items) {
        $txt = $item.OutputBox
        $exists = $false
        if ($item.Checkbox.Text -like '*DirectX*') {
            $exists = Test-Path "C:\Windows\System32\dxdiag.exe"
        } elseif ($item.Checkbox.Text -like '*Intel Graphics*') {
            $exists = Test-Path "C:\Windows\System32\igfxtray.exe"
        } elseif ($item.Checkbox.Text -like '*AMD Ryzen*') {
            $exists = Test-Path "C:\Program Files\AMD"
        } elseif ($item.Checkbox.Text -like '*HW INFO*') {
            $exists = Test-Path "C:\Program Files\HWiNFO64"
        }
        $txt.Text = if ($exists) { 'Detected' } else { 'Not Found' }
        $txt.ForeColor = if ($exists) { $colorSuccess } else { $colorError }
    }
    $osBox.Text = Get-OSInfo
    $form.Activate()
})

# =================== JALANKAN FORM ===================
[void]$form.ShowDialog()
