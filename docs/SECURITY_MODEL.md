# Security model

ThinkPad Battery Tray separates the user interface from privileged battery threshold writes.

## Components

### Tray application

Installed as:

    /usr/local/bin/thinkpad-battery-tray

The tray app runs as the normal desktop user.

It reads battery information from:

    /sys/class/power_supply/BAT0/

It does not need root privileges to display battery status.

### Privileged helper

Installed as:

    /usr/local/libexec/thinkpad-battery-threshold-helper

The helper performs the privileged write operations needed to change battery charge thresholds.

It supports only these operations:

    conserve
    full
    set START STOP

The helper validates threshold values before writing them.

Accepted values:

- Start threshold must be a number from 0 to 100
- Stop threshold must be a number from 0 to 100
- Start threshold must be less than or equal to stop threshold

### polkit policy

Installed as:

    /usr/share/polkit-1/actions/io.github.shiny_sand.thinkpad_battery.policy

The polkit policy allows the graphical app to request authorization for changing battery thresholds.

The GUI does not run as root.

## Files modified by the helper

The helper writes to:

    /sys/class/power_supply/BAT0/charge_control_start_threshold
    /sys/class/power_supply/BAT0/charge_control_end_threshold

It does not modify system package configuration, bootloader settings, kernel parameters, tuned profiles, or TLP settings.

## Why not run the GUI as root?

Running GUI apps as root is fragile, especially on modern Wayland desktops.

This project keeps the graphical app unprivileged and limits elevation to a small auditable shell helper.

## Boot restore behavior

The systemd service:

    lenovo-battery-thresholds.service

runs the helper in conservation mode at boot.

This restores:

    start=70
    stop=80

The design keeps full-charge mode temporary. If the user forgets to return to conservation mode, the next boot restores it.
