# Orca Headless Linux Installer

<!-- i18n: locale=de; source=README.md -->

[English (en)](../../../README.md) | **Deutsch (de)** | [Alle Sprachen](../README.md)

Dieses Installationsskript betreibt Orca als headless `systemd`-Dienst auf einem Linux-Server und koppelt ihn mit Desktop- oder Mobile-Orca.

## Schnellstart

Führe diese Befehle auf dem Server aus. Während der Installation wird eine für den Client erreichbare Pairing-Adresse abgefragt.

```bash
curl -fLO https://raw.githubusercontent.com/garhidiba/linux-orca-installer/main/install_orca.sh
chmod +x install_orca.sh
sudo ./install_orca.sh
```

Das Skript installiert Abhängigkeiten und das neueste AppImage, zeigt einen QR-Code für Mobile Pairing und endet im HOST/RUNTIME-Modus.

## Umgebung und Pairing

- Unterstützt werden Debian, Ubuntu, Armbian, Orange Pi OS und andere `apt-get`-Systeme mit `x86_64`/`amd64` oder `aarch64`/`arm64` sowie `systemd`.
- Der Server benötigt GitHub-Zugriff; der Client muss Port `6768` und die Pairing-Adresse erreichen können.
- Verwende eine erreichbare LAN-, DNS-, Overlay- oder `wss://`-Adresse, niemals `0.0.0.0`, `*` oder `::`.

Electron/GTK, Xvfb, DBus und QR-Abhängigkeiten werden automatisch installiert. Die vollständige Liste steht im [englischen Original](../../../README.md#dependencies).

## Tägliche Befehle

```bash
sudo orca-pair host
sudo orca-pair mobile
sudo orca-pair both
sudo orca-pair show
sudo orca-pair status
sudo orca-pair log
sudo orca-update
```

`host` erstellt die Desktop-URL, `mobile` den QR-Code und `both` erledigt beides; danach läuft HOST/RUNTIME. `orca-update` und jeder Dienstneustart prüfen auf Updates.

## Fehlerbehebung

Prüfe Status und Log, wenn Orca nicht startet oder keine Pairing-URL erscheint. Das Kommando wartet bis zu 60 Sekunden. Starte den Installer erneut, um eine neue Adresse einzugeben. Pairing-URLs nur mit vertrauenswürdigen Personen und Geräten teilen.

```bash
sudo orca-pair status
sudo orca-pair log
sudo ./install_orca.sh
```
