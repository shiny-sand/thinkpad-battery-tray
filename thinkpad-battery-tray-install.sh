#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
FILES_DIR="$SCRIPT_DIR/files"

INSTALL_USER="${SUDO_USER:-$USER}"
USER_HOME="$(getent passwd "$INSTALL_USER" | cut -d: -f6)"

if [[ ! -d "$FILES_DIR" ]]; then
  echo "ERROR: files directory not found next to this script."
  exit 1
fi

echo "Installing ThinkPad Battery Tray from saved bundle..."
echo "User: $INSTALL_USER"
echo "Home: $USER_HOME"
echo

echo "Installing dependencies..."
sudo dnf install -y python3-pyside6 polkit

echo "Installing /usr/local/bin files..."
for f in "$FILES_DIR"/usr-local-bin/*; do
  [[ -f "$f" ]] || continue
  sudo install -D -m 755 "$f" "/usr/local/bin/$(basename "$f")"
done

echo "Installing helper..."
sudo install -D -m 755 \
  "$FILES_DIR/usr-local-libexec/thinkpad-battery-threshold-helper" \
  "/usr/local/libexec/thinkpad-battery-threshold-helper"

echo "Installing app resources..."
sudo mkdir -p /usr/local/share/thinkpad-battery-tray
sudo cp -av "$FILES_DIR/share-thinkpad-battery-tray/." /usr/local/share/thinkpad-battery-tray/
sudo chown -R root:root /usr/local/share/thinkpad-battery-tray

echo "Installing polkit policy..."
sudo install -D -m 644 \
  "$FILES_DIR/polkit-actions/io.github.shiny_sand.thinkpad_battery.policy" \
  "/usr/share/polkit-1/actions/io.github.shiny_sand.thinkpad_battery.policy"

echo "Installing systemd service..."
sudo install -D -m 644 \
  "$FILES_DIR/etc-systemd-system/lenovo-battery-thresholds.service" \
  "/etc/systemd/system/lenovo-battery-thresholds.service"

sudo systemctl daemon-reload
sudo systemctl enable --now lenovo-battery-thresholds.service

echo "Installing desktop launcher..."
if [[ -f "$FILES_DIR/applications/thinkpad-battery-tray.desktop" ]]; then
  sudo install -D -m 644 \
    "$FILES_DIR/applications/thinkpad-battery-tray.desktop" \
    "/usr/share/applications/thinkpad-battery-tray.desktop"
fi

echo "Installing autostart entry..."
mkdir -p "$USER_HOME/.config/autostart"
if [[ -f "$FILES_DIR/autostart/thinkpad-battery-tray.desktop" ]]; then
  install -m 644 \
    "$FILES_DIR/autostart/thinkpad-battery-tray.desktop" \
    "$USER_HOME/.config/autostart/thinkpad-battery-tray.desktop"
  chown "$INSTALL_USER:$INSTALL_USER" "$USER_HOME/.config/autostart/thinkpad-battery-tray.desktop"
fi

echo
echo "Installed successfully."
echo
echo "Start it now with:"
echo "  thinkpad-battery-tray &"
echo
echo "Check thresholds with:"
echo "  battery-thresholds"
