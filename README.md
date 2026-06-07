# ThinkPad Battery Tray

A small KDE Plasma system tray app for managing ThinkPad and Lenovo battery charge thresholds on Fedora/Linux.

It provides a simple GUI for switching between battery preservation and full-charge modes without installing TLP or replacing Fedora power management.

## Features

- KDE Plasma system tray app
- Modern Qt6/PySide6 interface
- Right-click tray menu for quick mode switching
- Shows current battery percentage, charge status, and thresholds
- Conservation mode: 70 / 80
- Balanced mode: 80 / 90
- Full-charge mode: 95 / 100
- Custom thresholds from the UI
- Full-charge mode is temporary by design
- On next boot, conservation mode is restored automatically
- Uses a small polkit-protected helper for privileged writes
- Keeps Fedora tuned / tuned-ppd intact

## Screenshot

A screenshot can be added here later:

    screenshots/thinkpad-battery-tray.png

## Supported systems

This project is intended for Fedora KDE Plasma systems where the kernel exposes battery threshold files such as:

    /sys/class/power_supply/BAT0/charge_control_start_threshold
    /sys/class/power_supply/BAT0/charge_control_end_threshold

It was built and tested on a Lenovo ThinkPad P15v running Fedora KDE Plasma.

It may work on other ThinkPad or Lenovo laptops that expose the same Linux power_supply threshold interface.

## Requirements

- Fedora Linux
- KDE Plasma system tray
- Python 3
- PySide6
- polkit
- A battery exposed as BAT0
- Writable kernel charge-threshold files

The installer installs required Fedora packages:

    python3-pyside6
    polkit

## Install

Clone the repository:

    git clone git@github.com:shiny-sand/thinkpad-battery-tray.git
    cd thinkpad-battery-tray

Run the installer:

    chmod +x thinkpad-battery-tray-install.sh
    ./thinkpad-battery-tray-install.sh

Start the tray app:

    thinkpad-battery-tray &

It will also be added to autostart for future logins.

## Usage

Open the tray icon or right-click it.

Available modes:

| Mode | Start | Stop | Use case |
|---|---:|---:|---|
| Conservation | 70% | 80% | Daily docked use |
| Balanced | 80% | 90% | More portable daily use |
| Full until reboot | 95% | 100% | Travel or maximum battery |
| Custom | User-defined | User-defined | Manual control |

## CLI commands

The installer also provides command-line helpers:

    battery-conserve
    battery-balanced
    battery-full
    battery-thresholds

## Boot behavior

The systemd service restores conservation mode on boot:

    lenovo-battery-thresholds.service

This means that if full-charge mode is enabled and forgotten, the laptop returns to conservation mode after the next reboot.

## Security model

The tray app runs as the normal desktop user.

It does not run the full GUI as root. Instead, privileged writes are handled by a small helper:

    /usr/local/libexec/thinkpad-battery-threshold-helper

The helper is called through polkit and writes only to the battery threshold files.

See:

    docs/SECURITY_MODEL.md

## Uninstall

See:

    docs/UNINSTALL.md

## Known limitations

- Assumes the main battery is BAT0
- Designed around Lenovo / ThinkPad threshold support
- Not a replacement for full laptop power management
- Does not manage CPU profiles, power profiles, suspend policy, or fan behavior

## License

MIT License. See LICENSE.
