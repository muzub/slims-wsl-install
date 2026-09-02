# firewall-windows.ps1
# Konfigurasi Windows Firewall untuk SLiMS WSL
# Jalankan sebagai Administrator di Windows PowerShell

Write-Host "🔥 Configuring Windows Firewall for SLiMS..." -ForegroundColor Cyan
Write-Host ""

# Hapus rule lama jika ada
Remove-NetFirewallRule -DisplayName "Apache HTTP" -ErrorAction SilentlyContinue
Remove-NetFirewallRule -DisplayName "MySQL" -ErrorAction SilentlyContinue
Remove-NetFirewallRule -DisplayName "SLiMS Apache" -ErrorAction SilentlyContinue
Remove-NetFirewallRule -DisplayName "SLiMS MySQL" -ErrorAction SilentlyContinue

# Tambah rule baru
Write-Host "📡 Adding firewall rules..." -ForegroundColor Yellow
New-NetFirewallRule -DisplayName "SLiMS Apache" -Direction Inbound -Protocol TCP -LocalPort 80 -Action Allow | Out-Null
New-NetFirewallRule -DisplayName "SLiMS MySQL" -Direction Inbound -Protocol TCP -LocalPort 3306 -Action Allow | Out-Null

Write-Host ""
Write-Host "✅ Firewall configured successfully!" -ForegroundColor Green
Write-Host "🌐 SLiMS is now accessible from other PCs in your network" -ForegroundColor Green
Write-Host ""
Write-Host "To find your WSL IP address, run in WSL:" -ForegroundColor Cyan
Write-Host "  hostname -I" -ForegroundColor White
Write-Host ""
Write-Host "Then access SLiMS from other PC: http://<WSL-IP>/slims" -ForegroundColor Green
