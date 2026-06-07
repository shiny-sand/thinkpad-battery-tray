# Uninstall

This removes ThinkPad Battery Tray and its installed helper files.

## Stop the tray app

    pkill -f thinkpad-battery-tray || true

## Remove installed files

    sudo rm -f /usr/local/bin/thinkpad-battery-tray
    sudo rm -f /usr/local/bin/battery-conserve
    sudo rm -f /usr/local/bin/battery-balanced
    sudo rm -f /usr/local/bin/battery-full
    sudo rm -f /usr/local/bin/battery-thresholds

    sudo rm -f /usr/local/libexec/thinkpad-battery-threshold-helper

    sudo rm -f /usr/share/polkit-1/actions/io.github.shiny_sand.thinkpad_battery.policy
    sudo rm -f /usr/share/applications/thinkpad-battery-tray.desktop

    rm -f ~/.config/autostart/thinkpad-battery-tray.desktop

    sudo rm -rf /usr/local/share/thinkpad-battery-tray

## Disable the boot service

    sudo systemctl disable --now lenovo-battery-thresholds.service 2>/dev/null || true
    sudo rm -f /etc/systemd/system/lenovo-battery-thresholds.service
    sudo systemctl daemon-reload

## Optional dependency cleanup

Only remove these if no other software on your system needs them:

    sudo dnf remove python3-pyside6

polkit is a core desktop component and should normally remain installed.

## Verify

    which thinkpad-battery-tray
    which battery-conserve
    systemctl status lenovo-battery-thresholds.service --no-pager

If the commands are not found and the service is missing, the app has been removed.
