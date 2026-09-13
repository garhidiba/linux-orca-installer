# Orca headless Linux-installatieprogramma

<!-- i18n: locale=nl; source=README.md -->

[English (en)](../../../README.md) | **Nederlands (nl)** | [Alle talen](../README.md)

[Official Orca website](https://onorca.dev) · [Official GitHub repository](https://github.com/stablyai/orca)

Dit installatieprogramma draait Orca als headless `systemd`-service op een Linux-server en koppelt het met desktop- of mobiele Orca.

## Snel beginnen

Voer deze opdrachten uit op de server. Tijdens de installatie voer je een Pairing-adres in dat de client kan bereiken.

```bash
curl -fLO https://raw.githubusercontent.com/garhidiba/linux-orca-installer/main/install_orca.sh
chmod +x install_orca.sh
sudo ./install_orca.sh
```

Het script installeert afhankelijkheden en de nieuwste AppImage, toont een QR-code voor mobiele pairing en eindigt in de HOST/RUNTIME-modus.

## Omgeving en pairing

- Ondersteund: Debian, Ubuntu, Armbian, Orange Pi OS en andere `apt-get`-systemen, `x86_64`/`amd64` of `aarch64`/`arm64`, en `systemd`.
- De server moet GitHub kunnen bereiken; de client moet poort `6768` en het Pairing-adres kunnen bereiken.
- Gebruik een bereikbaar LAN-, DNS-, overlay- of `wss://`-adres; gebruik nooit `0.0.0.0`, `*` of `::`.

Electron/GTK-, Xvfb-, DBus- en QR-afhankelijkheden worden automatisch geïnstalleerd. Zie de volledige lijst in het [Engelse document](../../../README.md#dependencies).

## Dagelijkse opdrachten

```bash
sudo orca-pair host
sudo orca-pair mobile
sudo orca-pair both
sudo orca-pair show
sudo orca-pair status
sudo orca-pair log
sudo orca-update
```

`host` maakt de desktop-URL, `mobile` toont de QR-code en `both` doet beide; het eindigt in HOST/RUNTIME. `orca-update` en elke herstart van de service controleren op updates.

## Problemen oplossen

Controleer status en log als Orca niet start of geen Pairing-URL toont. De opdracht wacht maximaal 60 seconden. Voer het installatieprogramma opnieuw uit voor een nieuw adres. Deel Pairing-URL’s alleen met vertrouwde personen en apparaten.

```bash
sudo orca-pair status
sudo orca-pair log
sudo ./install_orca.sh
```
