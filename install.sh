#!/bin/bash
# SLiMS WSL Auto-Installer - Network Ready dengan IP Dinamis
# Instalasi SLiMS di WSL hanya dengan 1 perintah

set -e

echo "🚀 SLiMS WSL Installer"
echo "===================="
echo ""

# Tanya apakah ingin akses dari jaringan
read -p "Akses SLiMS dari PC lain di jaringan? (y/n): " NETWORK_ACCESS
echo ""

# Install dependencies
echo "📦 Installing dependencies..."
sudo apt update
sudo apt install -y apache2 mariadb-server php php-mysql php-gd php-mbstring php-xml git unzip wget

# Dapatkan IP address saat ini
CURRENT_IP=$(hostname -I | awk '{print $1}')
echo "📍 Current WSL IP: $CURRENT_IP"
echo ""

# Konfigurasi Apache
if [ "$NETWORK_ACCESS" = "y" ]; then
    echo "🌐 Configuring network access..."
    
    # Ubah port Apache
    sudo sed -i 's/Listen 127.0.0.1:80/Listen 80/' /etc/apache2/ports.conf
    
    # Buat virtual host dengan IP saat ini
    sudo bash -c "cat > /etc/apache2/sites-available/slims.conf << EOF
<VirtualHost *:80>
    ServerAdmin admin@localhost
    DocumentRoot /var/www/html/slims
    ServerName $CURRENT_IP
    
    <Directory /var/www/html/slims>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
EOF"
    
    sudo a2ensite slims.conf
    sudo a2dissite 000-default.conf 2>/dev/null || true
    
    # Bind MySQL ke semua interface
    sudo sed -i 's/bind-address = 127.0.0.1/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf
    
    # Buat skrip fix-ip.sh
    sudo bash -c "cat > /usr/local/bin/fix-ip.sh << 'SCRIPT'
#!/bin/bash
NEW_IP=\$(hostname -I | awk '{print \$1}')
VHOST_FILE=\"/etc/apache2/sites-available/slims.conf\"
echo \"📍 New IP: \$NEW_IP\"
sudo cp \$VHOST_FILE \${VHOST_FILE}.bak
sudo sed -i \"s/ServerName .*/ServerName \$NEW_IP/\" \$VHOST_FILE
sudo service apache2 restart
echo \"✅ Updated! Access: http://\$NEW_IP\"
SCRIPT"
    sudo chmod +x /usr/local/bin/fix-ip.sh
    
    echo ""
    echo "⚠️  FIREWALL SETUP (Windows PowerShell sebagai Admin):"
    echo "netsh advfirewall firewall add rule name=\"Apache HTTP\" dir=in action=allow protocol=TCP localport=80"
    echo "netsh advfirewall firewall add rule name=\"MySQL\" dir=in action=allow protocol=TCP localport=3306"
    echo ""
    echo "💡 If IP changes after restart, run: fix-ip.sh"
    echo "🌐 Current access URL: http://$CURRENT_IP"
else
    echo "🔒 Localhost only mode"
fi

echo ""

# Start services
echo "🔄 Starting services..."
sudo service apache2 restart
sudo service mariadb start
echo ""

# Download SLiMS
echo "📥 Downloading SLiMS..."
cd /tmp
wget -q https://github.com/slims/slims9_bulian/archive/refs/heads/master.zip
unzip -q master.zip
sudo mv slims9_bulian-master /var/www/html/slims
sudo chown -R www-data:www-data /var/www/html/slims
echo ""

# Database setup
echo "🗄️ Setting up database..."
sudo mysql -e "CREATE DATABASE IF NOT EXISTS slims;"
sudo mysql -e "CREATE USER IF NOT EXISTS 'slims'@'localhost' IDENTIFIED BY 'slims123';"
sudo mysql -e "CREATE USER IF NOT EXISTS 'slims'@'%' IDENTIFIED BY 'slims123';"
sudo mysql -e "GRANT ALL PRIVILEGES ON slims.* TO 'slims'@'localhost';"
sudo mysql -e "GRANT ALL PRIVILEGES ON slims.* TO 'slims'@'%';"
sudo mysql -e "FLUSH PRIVILEGES;"
echo ""

echo "===================="
echo "✅ Installation complete!"
echo "===================="
echo ""
if [ "$NETWORK_ACCESS" = "y" ]; then
    echo "🌐 Network access: http://$CURRENT_IP"
    echo "💡 IP changed? Run: fix-ip.sh"
    echo ""
fi
echo "🌐 Local access: http://localhost/slims"
echo ""
echo "📝 Next steps:"
echo "1. Open browser and go to the URL above"
echo "2. Complete SLiMS web installation"
echo "3. Database host: localhost"
echo "4. Database name: slims"
echo "5. Database user: slims"
echo "6. Database password: slims123"
echo ""
