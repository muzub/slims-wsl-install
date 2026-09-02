#!/bin/bash
# SLiMS WSL Uninstaller
# Menghapus instalasi SLiMS dari WSL

set -e

echo "⚠️  SLiMS Uninstaller"
echo "==================="
echo ""

read -p "Are you sure you want to uninstall SLiMS? (y/n): " CONFIRM

if [ "$CONFIRM" != "y" ]; then
    echo "❌ Cancelled"
    exit 0
fi

echo ""
echo "🗑️ Removing SLiMS files..."
sudo rm -rf /var/www/html/slims

echo "🗑️ Removing Apache virtual host..."
sudo a2dissite slims.conf 2>/dev/null || true
sudo rm -f /etc/apache2/sites-available/slims.conf

# Restore default site jika ada
if [ -f /etc/apache2/sites-available/000-default.conf ]; then
    sudo a2ensite 000-default.conf 2>/dev/null || true
fi

echo "🗑️ Removing database..."
read -p "Delete 'slims' database? (y/n): " DELETE_DB
if [ "$DELETE_DB" = "y" ]; then
    sudo mysql -e "DROP DATABASE IF EXISTS slims;"
    sudo mysql -e "DROP USER IF EXISTS 'slims'@'localhost';"
    sudo mysql -e "DROP USER IF EXISTS 'slims'@'%';"
fi

echo "🗑️ Removing fix-ip.sh script..."
sudo rm -f /usr/local/bin/fix-ip.sh

echo ""
echo "==================="
echo "✅ SLiMS uninstalled!"
echo "==================="
echo ""
echo "💡 To reinstall, run: bash install.sh"
echo ""
