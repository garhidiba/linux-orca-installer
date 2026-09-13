# Orca Headless Linux Installer

**English (en)** | [한국어 (ko)](docs/i18n/ko/README.md) | [All languages](docs/i18n/README.md)

[Official Orca website](https://onorca.dev) · [Official GitHub repository](https://github.com/stablyai/orca)

Install and run Orca as a headless `systemd` service on a Linux server, then pair it with desktop or mobile Orca clients.

The installer downloads the latest Orca AppImage, installs its Electron/GTK runtime dependencies, provides a virtual display for headless operation, and configures automatic service startup and updates.

## Documentation

- [Language versions and translation guide](docs/i18n/README.md)
- [Korean guide / 한국어 가이드 (ko)](docs/i18n/ko/README.md)
- [Quick start](#quick-start)
- [Supported environments](#supported-environments)
- [Dependencies](#dependencies)
- [Everyday commands](#everyday-commands)
- [Troubleshooting](#troubleshooting)

## Quick start

Run these commands on the server that will host Orca. The installer prompts for a **Pairing address** that the Orca client can actually reach.

```bash
curl -fLO https://raw.githubusercontent.com/garhidiba/linux-orca-installer/main/install_orca.sh
chmod +x install_orca.sh
sudo ./install_orca.sh
```

To run directly without keeping a local copy:

```bash
curl -fsSL https://raw.githubusercontent.com/garhidiba/linux-orca-installer/main/install_orca.sh | sudo -E bash
```

For production servers, downloading the script first lets you inspect it before execution. The raw URL works after `install_orca.sh` has been committed and pushed to the repository's `main` branch.

The interactive installation does the following:

1. Installs apt packages and the latest Orca AppImage.
2. Starts mobile pairing and prints a terminal QR code. Scan it, then press Enter.
3. Prints the desktop/runtime Pairing URL. The service finishes in HOST/RUNTIME mode.

## Supported environments

| Area | Supported scope |
| --- | --- |
| Distribution | Debian, Ubuntu, Armbian, Orange Pi OS, and other `apt-get`-based Linux distributions |
| CPU | `x86_64`/`amd64` and `aarch64`/`arm64` |
| Service manager | `systemd` |
| Runtime | Headless server using Xvfb as a virtual display |

The current script does not support Fedora/RHEL, Arch, Alpine, 32-bit ARM, `armv7`, 32-bit x86, or environments without `systemd`.

### Before you install

- The installing user must be able to run `sudo`.
- The server needs network access to GitHub releases and `raw.githubusercontent.com`.
- TCP port `6768` and the selected Pairing address must be reachable from the Orca client.
- Firewall, NAT, reverse proxy, and DNS configuration are outside the installer; configure them for your own network path.

## Choosing a Pairing address

If you press Enter at the prompt, the installer uses its detected IPv4 address. Otherwise, enter the endpoint your clients use to reach this server.

| Scenario | Example |
| --- | --- |
| Same LAN | `192.168.50.121` |
| Local DNS | `orangepi.local` |
| Overlay network | `100.80.10.20` |
| Existing external WebSocket endpoint | `wss://orca.example.com` |

`0.0.0.0`, `*`, and `::` are not valid Pairing addresses.

## Dependencies

No separate dependency step is normally required: the installer runs `apt-get update` and installs everything it needs.

| Purpose | Packages installed by the script |
| --- | --- |
| Download and installer tools | `curl`, `file`, `jq`, `ca-certificates` |
| QR and headless display | `qrencode`, `xvfb`, `xauth` |
| Session bus | `dbus`, `dbus-x11` |
| Electron/Chromium runtime | NSS, X11/XCB, GTK/AT-SPI, Pango/Cairo, GBM/DRM, audio, and FUSE libraries |

For Debian 13's `t64` transition, the script automatically selects an available package name from each pair:

```text
libatk1.0-0t64        or libatk1.0-0
libatk-bridge2.0-0t64 or libatk-bridge2.0-0
libatspi2.0-0t64      or libatspi2.0-0
libgtk-3-0t64         or libgtk-3-0
libcups2t64           or libcups2
libasound2t64         or libasound2
libfuse2t64           or libfuse2
```

To repair dependencies or repeat setup, rerun the installer instead of choosing these compatibility packages by hand:

```bash
sudo ./install_orca.sh
```

## Installed components

| Path | Purpose |
| --- | --- |
| `/opt/orca/orca.AppImage` | Downloaded Orca AppImage |
| `/opt/orca/update.sh` | Checks and downloads the latest version |
| `/opt/orca/run.sh` | Runs Orca through Xvfb and DBus |
| `/opt/orca/.version` | Installed Orca version |
| `/etc/orca/config.json` | Pairing address, port, and current pairing mode |
| `/etc/systemd/system/orca.service` | `systemd` service definition |
| `/usr/local/sbin/orca-pair` | Pairing and status command |
| `/usr/local/sbin/orca-update` | Manual update command |
| `/var/lib/orca-pairing/` | Last generated Host and Mobile Pairing URLs |

The service runs as the user who invoked the installer with `sudo`; when installed directly as `root`, it runs as `root`.

## Everyday commands

### Pairing

| Command | Result |
| --- | --- |
| `sudo orca-pair host` | Restarts in HOST/RUNTIME mode and prints/saves a desktop Pairing URL. |
| `sudo orca-pair mobile` | Restarts in MOBILE mode and prints/saves a QR code and Mobile Pairing URL. |
| `sudo orca-pair both` | Creates the mobile QR pairing, waits for Enter, then creates the HOST/RUNTIME pairing. |
| `sudo orca-pair show` | Displays the last saved Host and Mobile Pairing URLs. |

`orca-pair both` always leaves the service in HOST/RUNTIME mode.

### Status, logs, and service control

```bash
# Orca configuration and systemd status
sudo orca-pair status

# Follow Orca logs
sudo orca-pair log

# systemd status
systemctl status orca

# Restart the service
sudo systemctl restart orca

# Follow the service journal directly
journalctl -u orca -f -o cat
```

### Updates

```bash
# Check for a new AppImage, update if needed, then restart the service
sudo orca-update

# A normal service restart also checks for updates
sudo systemctl restart orca
```

If the update check cannot reach GitHub but an AppImage is already installed, Orca continues with the existing version. The initial installation needs network access because it must download the AppImage.

## Troubleshooting

### Unsupported architecture

The result must be `x86_64` or `aarch64`.

```bash
uname -m
```

### The service stops or no Pairing URL appears

Check the service and inspect its log output:

```bash
sudo orca-pair status
sudo orca-pair log
```

The pairing command waits for a URL for up to 60 seconds after the service restarts. Confirm that the address, port, and network path are correct.

### Incorrect Pairing address

Rerun the installer and enter the correct address. It rewrites `/etc/orca/config.json` and reconfigures the service.

```bash
sudo ./install_orca.sh
```

### The terminal cannot display the QR code

`sudo orca-pair mobile` prints both a QR code and a text Mobile Pairing URL. Use the text URL if your terminal cannot render the QR code reliably.

## Operational notes

- Treat Pairing URLs as sensitive and share them only with trusted users and devices. Do not leave them in public logs, screenshots, or issue reports.
- Generate a new URL with `sudo orca-pair host` or `sudo orca-pair mobile` when needed.
- The current installer does not provide a dedicated uninstall command. Plan decommissioning around the installed paths and `orca.service` listed above.
