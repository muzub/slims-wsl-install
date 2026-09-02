# SLiMS WSL Install

Instalasi SLiMS (Senayan Library Management System) di WSL (Windows Subsystem for Linux) dengan **1 perintah**.

## 🚀 Instalasi Cepat

### 1. Clone Repository

```bash
git clone https://github.com/muzub/slims-wsl-install.git
cd slims-wsl-install
```

### 2. Jalankan Skrip Instalasi

```bash
bash install.sh
```

Skrip akan:
- ✅ Install Apache, MySQL (MariaDB), PHP 8.x, dan dependensi
- ✅ Download SLiMS 9 Bulian terbaru dari GitHub
- ✅ Setup database dan user otomatis
- ✅ Konfigurasi virtual host Apache
- ✅ Buat skrip `fix-ip.sh` untuk update IP

### 3. Buka Browser

- **Localhost**: http://localhost/slims
- **Dari PC lain**: http://[IP-WSL]/slims

  Untuk melihat IP WSL:
  ```bash
  hostname -I
  ```

  Contoh: Jika IP adalah `192.168.1.100`, akses dari PC lain:
  ```
  http://192.168.1.100/slims
  ```

## 🔧 Konfigurasi Firewall Windows

Jika ingin mengakses dari PC lain, jalankan di **Windows PowerShell (Admin)**:

```powershell
.\firewall-windows.ps1
```

Atau manual:

```powershell
netsh advfirewall firewall add rule name="SLiMS Apache" dir=in action=allow protocol=TCP localport=80
netsh advfirewall firewall add rule name="SLiMS MySQL" dir=in action=allow protocol=TCP localport=3306
```

## 💡 Jika IP Berubah Setelah Restart

WSL menggunakan IP dinamis yang bisa berubah setelah restart. Jika ini terjadi:

```bash
fix-ip.sh
```

Skrip ini akan:
1. Mendapatkan IP terbaru
2. Update konfigurasi Apache
3. Restart Apache
4. Menampilkan URL akses terbaru

## 📝 Kredensial Database Default

- **Host**: `localhost`
- **Database**: `slims`
- **User**: `slims`
- **Password**: `slims123`

## 🗑️ Uninstall

```bash
bash uninstall.sh
```

## 📋 Requirements

- Windows 10/11 dengan WSL2 terinstal
- Ubuntu (atau distro Linux lain) di WSL
- Minimal 2GB RAM
- Minimal 10GB storage
- Koneksi internet

## 📚 Dokumentasi Lengkap

- [Panduan Lengkap](docs/panduan-lengkap.md) - Instalasi detail dan konfigurasi lanjutan
- [Troubleshooting](docs/troubleshooting.md) - Solusi masalah umum

## 🐛 Troubleshooting Cepat

### Tidak bisa akses dari PC lain?

1. Pastikan firewall Windows sudah dibuka (lihat bagian Firewall di atas)
2. Pastikan PC lain dalam jaringan yang sama
3. Cek IP WSL dengan `hostname -I`
4. Test koneksi: `ping [IP-WSL]` dari PC lain

### IP berubah setelah restart?

Jalankan `fix-ip.sh` untuk update konfigurasi Apache.

### Port 80 sudah digunakan aplikasi lain?

Edit `/etc/apache2/ports.conf` dan ganti port 80 ke port lain (misal 8080), lalu restart Apache:
```bash
sudo service apache2 restart
```

## 📄 License

MIT License
