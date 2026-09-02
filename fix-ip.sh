#!/bin/bash
# fix-ip.sh - Update SLiMS virtual host dengan IP terbaru
# Skrip ini otomatis dibuat saat instalasi, tapi bisa juga dijalankan manual

set -e

echo "📍 Getting new IP address..."
NEW_IP=$(hostname -I | awk '{print $1}')

if [ -z "$NEW_IP" ]; then
    echo "❌ Error: Could not get IP address"
    exit 1
fi

echo "📍 New IP: $NEW_IP"

VHOST_FILE="/etc/apache2/sites-available/slims.conf"

# Cek apakah file virtual host ada
if [ ! -f "$VHOST_FILE" ]; then
    echo "❌ Error: Virtual host file not found at $VHOST_FILE"
    echo "💡 Make sure you installed SLiMS with network access option"
    exit 1
fi

# Backup konfigurasi lama
sudo cp "$VHOST_FILE" "${VHOST_FILE}.bak"

# Update ServerName di virtual host
sudo sed -i "s/ServerName .*/ServerName $NEW_IP/" "$VHOST_FILE"

# Restart Apache
sudo service apache2 restart

echo ""
echo "✅ Virtual host updated successfully!"
echo "🌐 New access URL: http://$NEW_IP"
echo ""
echo "💡 If you still can't access from other PC:"
echo "   1. Make sure firewall is open (run firewall-windows.ps1 in Windows)"
echo "   2. Test ping from other PC: ping $NEW_IP"
echo "   3. Make sure both PCs are in same network"
