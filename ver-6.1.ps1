Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
# --- Form Setup ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "DIGITAL-DEVELOPER v6.0"
$form.Size = New-Object System.Drawing.Size(600, 700)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false

# --- Label Judul ---
$label = New-Object System.Windows.Forms.Label
$label.Text = "PERAWATAN SYSTEM BY DIGITALDEVELOPER v6.1"
$label.Font = New-Object System.Drawing.Font("Segoe UI",14,[System.Drawing.FontStyle]::Bold)
$label.Size = New-Object System.Drawing.Size(570,30)
$label.Location = New-Object System.Drawing.Point(15,10)
$form.Controls.Add($label)

# --- Panel Scrollable untuk Checkbox ---
$panel = New-Object System.Windows.Forms.Panel
$panel.Location = New-Object System.Drawing.Point(15,50)
$panel.Size = New-Object System.Drawing.Size(570, 420)
$panel.AutoScroll = $true
$panel.BorderStyle = 'FixedSingle'
$form.Controls.Add($panel)

# --- Daftar menu ---
$menuItems = @(
    "01 - Bersihkan file sampah",
    "02 - Flush DNS dan Renew IP",
    "03 - System File Checker (SFC)",
    "04 - Check Disk (CHKDSK)",
    "05 - Defragmentasi Hard Disk",
    "06 - Reset Komponen Windows Update",
    "07 - Install DirectX",
    "08 - PC Info",
    "09 - Periksa SMART Disk",
    "10 - Full Clean Temporary",
    "11 - Reset Jaringan",
    "12 - Update Driver",
    "13 - Backup Registry",
    "14 - Restore Registry",
    "15 - Install Intel Graphics Driver",
    "16 - Install AMD Ryzen Chipset",
    "17 - Install HW Info"
)


# --- Buat checkbox ---
$checkboxes = @()
$ypos = 10
foreach ($item in $menuItems) {
    $cb = New-Object System.Windows.Forms.CheckBox
    $cb.Text = $item
    $cb.Size = New-Object System.Drawing.Size(540,25)
    $cb.Location = New-Object System.Drawing.Point(5, $ypos)
    $panel.Controls.Add($cb)
    $checkboxes += $cb
    $ypos += 30
}

# --- TextBox output log ---
$textboxOutput = New-Object System.Windows.Forms.TextBox
$textboxOutput.Multiline = $true
$textboxOutput.ScrollBars = "Vertical"
$textboxOutput.WordWrap = $true
$textboxOutput.ReadOnly = $true
$textboxOutput.BackColor = [System.Drawing.Color]::Black
$textboxOutput.ForeColor = [System.Drawing.Color]::LightGreen
$textboxOutput.Font = New-Object System.Drawing.Font("Consolas",10)
$textboxOutput.Size = New-Object System.Drawing.Size(570, 100)
$textboxOutput.Location = New-Object System.Drawing.Point(15, 480)
$form.Controls.Add($textboxOutput)

# --- Progress Bar ---
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(15, 590)
$progressBar.Size = New-Object System.Drawing.Size(570, 20)
$progressBar.Minimum = 0
$progressBar.Maximum = 100
$progressBar.Value = 0
$form.Controls.Add($progressBar)

# --- Tombol Run Selected ---
$btnRun = New-Object System.Windows.Forms.Button
$btnRun.Text = "Run Selected"
$btnRun.Size = New-Object System.Drawing.Size(120,30)
$btnRun.Location = New-Object System.Drawing.Point(460, 620)
$form.Controls.Add($btnRun)

# --- Tombol Select All ---
$btnSelectAll = New-Object System.Windows.Forms.Button
$btnSelectAll.Text = "Select All"
$btnSelectAll.Size = New-Object System.Drawing.Size(100,30)
$btnSelectAll.Location = New-Object System.Drawing.Point(15, 620)
$form.Controls.Add($btnSelectAll)

# --- Tombol Clear All ---
$btnClearAll = New-Object System.Windows.Forms.Button
$btnClearAll.Text = "Clear All"
$btnClearAll.Size = New-Object System.Drawing.Size(100,30)
$btnClearAll.Location = New-Object System.Drawing.Point(130, 620)
$form.Controls.Add($btnClearAll)

# --- Fungsi untuk menulis ke log output ---
function Write-Log {
    param([string]$message)
    $textboxOutput.AppendText($message + "`r`n")
    $textboxOutput.SelectionStart = $textboxOutput.Text.Length
    $textboxOutput.ScrollToCaret()
}

# Fungsi 01 - Bersihkan file sampah
function BersihkanFileSampah {
    Write-Log "Membersihkan file sampah..."
    Start-Process -FilePath "cleanmgr.exe" -ArgumentList "/sagerun:1" -NoNewWindow -Wait
    Write-Log "Selesai membersihkan file sampah."
}

# Fungsi 02 - Flush DNS dan Renew IP
function FlushDNSRenewIP {
    Write-Log "Flush DNS dan Renew IP..."
    ipconfig /flushdns | Out-Null
    ipconfig /release | Out-Null
    ipconfig /renew | Out-Null
    Write-Log "Flush DNS dan Renew IP selesai."
}

# Fungsi 03 - System File Checker (SFC)
function SystemFileChecker {
    Write-Log "Menjalankan System File Checker (SFC)..."
    $output = sfc /scannow 2>&1
    foreach ($line in $output) { Write-Log $line }
    Write-Log "SFC selesai."
}


# Fungsi 04 - Check Disk (CHKDSK)
function CheckDisk {
    Write-Log "Menjalankan Check Disk (CHKDSK) pada drive C: ..."
    $output = chkdsk C: /f /r 2>&1
    foreach ($line in $output) { Write-Log $line }
    Write-Log "CHKDSK selesai."
}


# Fungsi 05 - Defragmentasi Hard Disk
function DefragmentasiHardDisk {
    Write-Log "Menjalankan Defragmentasi Hard Disk pada drive C: ..."
    $output = defrag C: /O 2>&1
    foreach ($line in $output) { Write-Log $line }
    Write-Log "Defragmentasi selesai."
}


# Fungsi 06 - Reset Komponen Windows Update
function ResetWindowsUpdate {
    Write-Log "Mereset komponen Windows Update..."
    net stop wuauserv | Out-Null
    net stop cryptSvc | Out-Null
    net stop bits | Out-Null
    net stop msiserver | Out-Null

    Rename-Item -Path "$env:SystemRoot\SoftwareDistribution" -NewName "SoftwareDistribution.old" -ErrorAction SilentlyContinue
    Rename-Item -Path "$env:SystemRoot\System32\catroot2" -NewName "catroot2.old" -ErrorAction SilentlyContinue

    net start wuauserv | Out-Null
    net start cryptSvc | Out-Null
    net start bits | Out-Null
    net start msiserver | Out-Null

    Write-Log "Reset Windows Update selesai."
}


# Fungsi 07 - Install DirectX via Chocolatey
function InstallDirectX {
    Write-Host "Memulai install DirectX menggunakan Chocolatey..."
    if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "Chocolatey tidak ditemukan, menginstal Chocolatey terlebih dahulu..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }
    choco install directx -y
    Write-Host "Install DirectX selesai."
}


# Fungsi 08 - PC Info
function PCInfo {
    Write-Log "Menampilkan informasi hardware dan sistem..."
    $info = systeminfo
    foreach ($line in $info) { Write-Log $line }
    Write-Log "Selesai menampilkan info."
}


# Fungsi 09 - Periksa SMART Disk
function CheckSmartDisk {
    Write-Log "Memeriksa status SMART disk..."
    $smartStatus = wmic diskdrive get status
    foreach ($line in $smartStatus) { Write-Log $line }
    Write-Log "Pemeriksaan SMART selesai."
}


# Fungsi 10 - Full Clean Temporary (full cleaning sesuai batch script)
function FullCleanTemporary {
    Write-Log "Memulai pembersihan temporary files dan cache..."

    # Tanya kill explorer.exe
    $killExplorer = [System.Windows.Forms.MessageBox]::Show("Do you want to kill the explorer.exe process?","Kill Explorer.exe?", 'YesNo', 'Question')
    if ($killExplorer -eq 'Yes') {
        Write-Log "Killing explorer.exe process..."
        Stop-Process -Name explorer -Force -ErrorAction SilentlyContinue
    } else {
        Write-Log "Tidak membunuh explorer.exe."
    }

    Write-Log "Mengosongkan Recycle Bin..."
    Clear-RecycleBin -Force -ErrorAction SilentlyContinue

    Write-Log "Membersihkan DNS cache..."
    ipconfig /flushdns | Out-Null

    # Fungsi DeleteFiles yang memeriksa file kosong
    function DeleteFiles($Path, $Pattern) {
        Write-Log "Memeriksa file '$Pattern' di $Path ..."
        try {
            $files = Get-ChildItem -Path $Path -Recurse -Include $Pattern -ErrorAction SilentlyContinue
            if ($files.Count -eq 0) {
                Write-Log "Tidak ada file '$Pattern' ditemukan di $Path. Dilewati."
            } else {
                Write-Log "Menghapus $($files.Count) file '$Pattern' di $Path ..."
                $files | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
            }
        } catch {
            Write-Log "Gagal menghapus file $Pattern di $Path"
        }
    }

    DeleteFiles "$env:windir" "KB*.log"
    DeleteFiles "$env:SystemDrive\" "*.tmp"
    DeleteFiles "$env:SystemDrive\" "*._mp"
    DeleteFiles "$env:SystemDrive\" "*.log"
    DeleteFiles "$env:SystemDrive\" "*.gid"
    DeleteFiles "$env:SystemDrive\" "*.chk"
    DeleteFiles "$env:SystemDrive\" "*.old"
    DeleteFiles "$env:SystemDrive\recycled" "*.*"
    DeleteFiles "$env:windir" "*.bak"
    DeleteFiles "$env:windir\prefetch" "*.*"

    Write-Log "Membersihkan folder temp Windows..."
    Remove-Item "$env:windir\temp\*" -Recurse -Force -ErrorAction SilentlyContinue
    New-Item -Path "$env:windir\temp" -ItemType Directory -Force | Out-Null

    DeleteFiles "$env:userprofile\cookies" "*.*"
    DeleteFiles "$env:userprofile\local settings\temporary internet files" "*.*"
    DeleteFiles "$env:userprofile\recent" "*.*"
    DeleteFiles "$env:userprofile\local settings\history" "*.*"

    Write-Log "Memulai perbaikan sistem image..."
    dism /Online /Cleanup-Image /RestoreHealth | ForEach-Object { Write-Log $_ }

    Write-Log "Memulai pemeriksaan dan perbaikan file sistem..."
    sfc /scannow | ForEach-Object { Write-Log $_ }

    Write-Log "Menghapus semua system restore point..."
    vssadmin delete shadows /all /quiet | Out-Null

    Write-Log "Menghapus history Run..."
    reg delete "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU" /f | Out-Null

    Write-Log "Menghapus semua event logs..."
    $logs = wevtutil el
    foreach ($log in $logs) {
        wevtutil cl $log
    }

    Write-Log "Membersihkan temporary files pengguna..."
    Remove-Item "$env:TEMP\*" -Recurse -Force -ErrorAction SilentlyContinue

    Write-Log "Membersihkan internet cache files..."
    Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\INetCache\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\INetCookies\*" -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item "$env:LOCALAPPDATA\Microsoft\Windows\INetHistory\*" -Recurse -Force -ErrorAction SilentlyContinue

    Write-Log "Menghapus semua prefetch files..."
    Remove-Item "$env:windir\prefetch\*" -Recurse -Force -ErrorAction SilentlyContinue

    Write-Log "Full clean temporary selesai."
}


# Fungsi 11 - Reset Jaringan
function ResetJaringan {
    Write-Log "Mereset pengaturan jaringan..."
    netsh winsock reset | Out-Null
    netsh int ip reset | Out-Null
    Write-Log "Reset jaringan selesai."
}


# Fungsi 12 - Update Driver (jalankan script powershell dari github)
function UpdateDriver {
    Write-Log "Update driver dimulai..."
    # Contoh pemanggilan powershell script update driver dari URL
    powershell -command "irm https://raw.githubusercontent.com/CHXRITH/DriverUpdate/main/DriverUpdate.ps1 | iex"
    Write-Log "Update driver selesai."
    cls
}


# Fungsi 13 - Backup Registry
function BackupRegistry {
    $backupPath = "$env:userprofile\Desktop\registry-backup.reg"
    Write-Log "Membackup Registry ke $backupPath ..."
    reg export HKEY_LOCAL_MACHINE $backupPath /y | Out-Null
    Write-Log "Backup Registry selesai."
}


# Fungsi 14 - Restore Registry
function RestoreRegistry {
    $backupPath = "$env:userprofile\Desktop\registry-backup.reg"
    if (Test-Path $backupPath) {
        Write-Log "Merestore Registry dari $backupPath ..."
        reg import $backupPath | Out-Null
        Write-Log "Restore Registry selesai."
    } else {
        Write-Log "File backup registry tidak ditemukan: $backupPath"
    }
}


# Fungsi 15 - install intel grapic driver
function installintelgrapic {
    Write-log "chekk all driver in your os"

}


# Fungsi 16 - install amd ryzen grapic driver
function installamdryzengrapicdriver {
    Write-log "check all driver in your os"
}


#Fungsi 17 - install hw info
function installHWINFO {
    Write-log "installing prosses HW INFO"
}
# (fungsi lain kamu bisa tambahkan di sini sesuai sebelumnya...)

# --- Event Tombol Select All ---
$btnSelectAll.Add_Click({
    foreach ($cb in $checkboxes) { $cb.Checked = $true }
})

# --- Event Tombol Clear All ---
$btnClearAll.Add_Click({
    foreach ($cb in $checkboxes) { $cb.Checked = $false }
})

# --- Event Tombol Run Selected ---
$btnRun.Add_Click({
    # Reset progress bar dan output
    $textboxOutput.Clear()
    $progressBar.Value = 0

    # Hitung total checkbox yg terpilih
    $total = ($checkboxes | Where-Object { $_.Checked }).Count
    if ($total -eq 0) {
        Write-Log "Tidak ada opsi yang dipilih."
        return
    }
    
    # Jalankan setiap fungsi yang dipilih, update progress bar
    $index = 0
    foreach ($cb in $checkboxes) {
        if ($cb.Checked) {
            $index++
            Write-Log ">>> Menjalankan: $($cb.Text) ..."
            switch -Regex ($cb.Text) {
                "01" { BersihkanFileSampah }
                "02" { FlushDNSRenewIP }
                "03" { SystemFileChecker }
                "04" { CheckDisk }
                "05" { DefragmentasiHardDisk }
                "06" { ResetWindowsUpdate }
                "07" { InstallDirectX }
                "08" { PCInfo }
                "09" { CheckSmartDisk }
                "10" { FullCleanTemporary }
                "11" { ResetJaringan }
                "12" { UpdateDriver }
                "13" { BackupRegistry }
                "14" { RestoreRegistry }
                "15" { installintelgrapic }
                "16" { installamdryzengrapicdriver }
                "17" {  }
                # Tambahkan fungsi lain sesuai kebutuhan...
                default { Write-Log "Fungsi untuk '$($cb.Text)' belum dibuat." }
            }
            $progressBar.Value = [math]::Round(($index / $total) * 100)
            Write-Log "============================="
        }
    }
    Write-Log "Semua proses selesai."
    $progressBar.Value = 100
})

# --- Jalankan Form ---
$form.Topmost = $true
$form.Add_Shown({ $form.Activate() })
[void]$form.ShowDialog()
