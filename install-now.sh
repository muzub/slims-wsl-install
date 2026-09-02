#!/bin/bash
# install-now.sh - Instalasi SLiMS WSL 1 perintah tanpa clone repo
# Cara pakai: bash <(curl -fsSL https://raw.githubusercontent.com/muzub/slims-wsl-install/main/install-now.sh)

set -e

echo "🚀 SLiMS WSL Auto-Installer"
echo "==========================="
echo ""

# Download install.sh dari GitHub
INSTALLER_URL="https://raw.githubusercontent.com/muzub/slims-wsl-install/main/install.sh"

echo "📥 Downloading installer..."
TMP_INSTALLER="/tmp/slims-install-$(date +%s).sh"

if command -v curl &> /dev/null; then
    curl -fsSL "$INSTALLER_URL" -o "$TMP_INSTALLER"
elif command -v wget &> /dev/null; then
    wget -q "$INSTALLER_URL" -O "$TMP_INSTALLER"
else
    echo "❌ Error: curl or wget required"
    exit 1
fi

echo ""
echo "📝 Running installer..."
echo ""

# Jalankan installer
bash "$TMP_INSTALLER"

# Cleanup
rm -f "$TMP_INSTALLER"

echo ""
echo "==========================="
echo "✅ Done!"
echo "==========================="
