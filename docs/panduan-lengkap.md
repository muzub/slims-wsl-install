# Panduan Lengkap SLiMS WSL

Panduan detail instalasi dan konfigurasi SLiMS di WSL.

## 📋 Prerequisites

Sebelum instalasi, pastikan:

1. **Windows 10/11** dengan WSL2 terinstal
2. **Ubuntu** (atau distro Linux lain) sudah diinstal di WSL
3. **Minimal 2GB RAM** tersedia
4. **Minimal 10GB storage** tersedia
5. **Koneksi internet** untuk download SLiMS dan dependencies

## 🚀 Instalasi

### Langkah 1: Clone Repository

```bash
git clone https://github.com/muzub/slims-wsl-install.git
cd slims-wsl-install
```

### Langkah 2: Jalankan Instalasi

```bash
bash install.sh
```

Skrip akan:
- Update package list
- Install Apache, MariaDB, PHP 8.x, dan ekstensi yang diperlukan
- Download SLiMS 9 Bulian dari GitHub
- Setup database dan user
- Konfigurasi virtual host Apache
- Buat skrip `fix-ip.sh` untuk update IP

### Langkah 3: Konfigurasi Firewall (Opsional)

Jika ingin akses dari PC lain, jalankan di **Windows PowerShell (Admin)**:

```powershell
.\firewall-windows.ps1
```

### Langkah 4: Akses SLiMS

- **Localhost**: http://localhost/slims
- **Jaringan**: http://[IP-WSL]/slims

## ⚙️ Konfigurasi Lanjutan

### Ganti Password Database

Edit kredensial di skrip instalasi atau manual:

```bash
sudo mysql -e "ALTER USER 'slims'@'localhost' IDENTIFIED BY 'password_baru';"
sudo mysql -e "FLUSH PRIVILEGES;"
```

Lalu update file konfigurasi SLiMS di `/var/www/html/slims/config.php`

### Backup Database

```bash
mysqldump -u slims -pslims123 slims > backup_slims.sql
```

### Restore Database

```bash
mysql -u slims -pslims123 slims < backup_slims.sql
```

### Auto-start Services saat WSL Boot

Edit `/etc/rc.local`:

```bash
sudo nano /etc/rc.local
```

Tambahkan:
```bash
#!/bin/bash
service apache2 start
service mariadb start
```

## 📊 Monitoring

### Cek Status Services

```bash
sudo service apache2 status
sudo service mariadb status
```

### Cek Resource Usage

```bash
htop
```

### Cek Disk Usage

```bash
df -h
```

## 🔒 Keamanan

### Ganti Password Default

Segera ganti password default setelah instalasi:

1. Database user `slims`
2. Admin SLiMS (setelah instalasi web)

### Firewall

Pastikan hanya port yang diperlukan yang terbuka:
- Port 80 (HTTP) - untuk akses web
- Port 3306 (MySQL) - hanya jika perlu akses remote database

### Update Berkala

```bash
sudo apt update
sudo apt upgrade -y
```

## 📝 Tips

### Akses Cepat

Buat alias di `~/.bashrc`:

```bash
echo "alias slims='cd /var/www/html/slims'" >> ~/.bashrc
echo "alias slims-log='sudo tail -f /var/log/apache2/error.log'" >> ~/.bashrc
source ~/.bashrc
```

### SLiMS di Root Domain

Jika ingin akses di `http://[IP-WSL]/` tanpa `/slims`:

1. Pindahkan file ke `/var/www/html/`
2. Update virtual host `DocumentRoot`

### Multiple SLiMS Instances

Untuk instalasi multiple SLiMS (misal development dan production):

1. Buat virtual host terpisah
2. Gunakan port atau subdomain berbeda
3. Buat database terpisah

## 🆘 Troubleshooting

Lihat [troubleshooting.md](troubleshooting.md) untuk solusi masalah umum.
