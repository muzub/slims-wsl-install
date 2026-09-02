# Troubleshooting SLiMS WSL

Panduan solusi masalah umum saat menggunakan SLiMS di WSL.

## 🔥 Tidak Bisa Akses dari PC Lain

### 1. Cek Firewall Windows

Pastikan firewall Windows sudah dibuka. Jalankan di **Windows PowerShell (Admin)**:

```powershell
.\firewall-windows.ps1
```

Atau manual:

```powershell
netsh advfirewall firewall add rule name="SLiMS Apache" dir=in action=allow protocol=TCP localport=80
netsh advfirewall firewall add rule name="SLiMS MySQL" dir=in action=allow protocol=TCP localport=3306
```

### 2. Cek IP Address WSL

Jalankan di WSL:

```bash
hostname -I
```

Pastikan IP yang ditampilkan sama dengan yang digunakan di browser.

### 3. Test Koneksi

Dari PC lain, test koneksi dengan ping:

```cmd
ping [IP-WSL]
```

Jika tidak ada response, kemungkinan:
- Firewall masih memblokir
- PC tidak dalam jaringan yang sama
- WSL dalam mode network yang berbeda

### 4. Cek Apache Listening

Di WSL, cek apakah Apache listening di port 80:

```bash
sudo netstat -tlnp | grep :80
```

Harus muncul:
```
tcp6  0  0 :::80  :::*  LISTEN  [pid]/apache2
```

### 5. Restart Services

```bash
sudo service apache2 restart
sudo service mariadb restart
```

## 💻 IP Berubah Setelah Restart

WSL menggunakan DHCP dinamis, jadi IP bisa berubah setiap kali restart.

**Solusi:**

```bash
fix-ip.sh
```

Skrip ini akan:
1. Mendapatkan IP terbaru
2. Update konfigurasi Apache
3. Restart Apache

**Solusi Permanen (Static IP):**

Edit file di Windows: `C:\Users\<YourUser>\.wslconfig`

```ini
[wsl2]
networkingMode=mirrored
localhostForwarding=true
```

Lalu restart WSL:

```powershell
wsl --shutdown
```

## 🌐 Port 80 Sudah Digunakan Aplikasi Lain

Jika port 80 sudah digunakan IIS atau aplikasi lain di Windows:

### Opsi 1: Ganti Port Apache

Edit `/etc/apache2/ports.conf`:

```bash
sudo nano /etc/apache2/ports.conf
```

Ganti:
```apache
Listen 80
```

Menjadi:
```apache
Listen 8080
```

Update virtual host:

```bash
sudo nano /etc/apache2/sites-available/slims.conf
```

Ganti `<VirtualHost *:80>` menjadi `<VirtualHost *:8080>`

Restart Apache:

```bash
sudo service apache2 restart
```

Akses dengan: `http://[IP-WSL]:8080/slims`

### Opsi 2: Matikan IIS (jika ada)

Di Windows PowerShell (Admin):

```powershell
Stop-Service W3SVC
Set-Service W3SVC -StartupType Disabled
```

## 🗄️ Error Koneksi Database

### "Can't connect to MySQL server"

1. Cek apakah MySQL running:
   ```bash
   sudo service mariadb status
   ```

2. Restart MySQL:
   ```bash
   sudo service mariadb restart
   ```

3. Cek kredensial di `config.php` SLiMS:
   - Host: `localhost`
   - User: `slims`
   - Password: `slims123`
   - Database: `slims`

### "Access denied for user"

Reset password database:

```bash
sudo mysql -e "ALTER USER 'slims'@'localhost' IDENTIFIED BY 'slims123';"
sudo mysql -e "FLUSH PRIVILEGES;"
```

## 📁 Permission Denied

### Error saat upload file atau akses folder

Fix permission:

```bash
sudo chown -R www-data:www-data /var/www/html/slims
sudo chmod -R 755 /var/www/html/slims
```

## 🔄 SLiMS Tidak Muncul

### "It works!" atau halaman kosong

1. Pastikan SLiMS ada di folder yang benar:
   ```bash
   ls -la /var/www/html/slims
   ```

2. Cek virtual host:
   ```bash
   cat /etc/apache2/sites-available/slims.conf
   ```

   Pastikan `DocumentRoot` adalah `/var/www/html/slims`

3. Enable site dan restart:
   ```bash
   sudo a2ensite slims.conf
   sudo service apache2 restart
   ```

## 🧹 Uninstall dan Install Ulang

Jika semua gagal, uninstall dan install ulang:

```bash
bash uninstall.sh
bash install.sh
```

## 📞 Masih Bermasalah?

Cek log Apache:

```bash
sudo tail -f /var/log/apache2/error.log
```

Cek log MySQL:

```bash
sudo tail -f /var/log/mysql/error.log
```

Log biasanya memberikan petunjuk error yang spesifik.
