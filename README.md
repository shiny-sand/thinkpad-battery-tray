# ThinkPad Battery Tray

Small Fedora KDE Plasma tray app for Lenovo battery charge thresholds.

## Modes

- Conservation: 70 / 80
- Balanced: 80 / 90
- Full until reboot: 95 / 100
- Custom thresholds from the UI
- Boot default restores conservation mode

## Installed components

- /usr/local/bin/thinkpad-battery-tray
- /usr/local/bin/battery-conserve
- /usr/local/bin/battery-balanced
- /usr/local/bin/battery-full
- /usr/local/bin/battery-thresholds
- /usr/local/libexec/thinkpad-battery-threshold-helper
- /etc/systemd/system/lenovo-battery-thresholds.service
- /usr/share/polkit-1/actions/io.github.shiny_sand.thinkpad_battery.policy
- /usr/share/applications/thinkpad-battery-tray.desktop
- ~/.config/autostart/thinkpad-battery-tray.desktop

## Reinstall

From this folder:

    chmod +x thinkpad-battery-tray-install.sh
    ./thinkpad-battery-tray-install.sh

## Start manually

    thinkpad-battery-tray &

## Check current thresholds

    battery-thresholds

## CLI modes

    battery-conserve
    battery-balanced
    battery-full

## Behavior

battery-full is temporary. On next boot, lenovo-battery-thresholds.service restores conservation mode.
