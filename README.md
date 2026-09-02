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

### 3. Buka Browser

- **Localhost**: http://localhost/slims
- **Dari PC lain**: http://<IP-WSL>/slims

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

Skrip ini akan mengupdate konfigurasi Apache dengan IP terbaru.

## 📝 Kredensial Database Default

- **Host**: localhost
- **Database**: slims
- **User**: slims
- **Password**: slims123

## 🗑️ Uninstall

```bash
bash uninstall.sh
```

## 📋 Requirements

- Windows 10/11 dengan WSL2 terinstal
- Ubuntu (atau distro Linux lain) di WSL
- Minimal 2GB RAM
- Minimal 10GB storage

## 📚 Dokumentasi Lengkap

Lihat [docs/panduan-wsl.md](docs/panduan-wsl.md) untuk panduan detail.

## 🐛 Troubleshooting

Lihat [docs/troubleshooting.md](docs/troubleshooting.md) untuk solusi masalah umum.

## 📄 License

MIT License
