# Installer Linux headless per Orca

<!-- i18n: locale=it; source=README.md -->

[English (en)](../../../README.md) | **Italiano (it)** | [Tutte le lingue](../README.md)

Questo installer esegue Orca come servizio `systemd` senza interfaccia grafica su un server Linux e lo associa a Orca desktop o mobile.

## Avvio rapido

Esegui questi comandi sul server. Durante l’installazione inserisci un indirizzo Pairing raggiungibile dal client.

```bash
curl -fLO https://raw.githubusercontent.com/garhidiba/linux-orca-installer/main/install_orca.sh
chmod +x install_orca.sh
sudo ./install_orca.sh
```

Lo script installa dipendenze e AppImage più recente, mostra un QR per il pairing mobile e termina in modalità HOST/RUNTIME.

## Ambiente e pairing

- Supportati: Debian, Ubuntu, Armbian, Orange Pi OS e altri sistemi `apt-get`, `x86_64`/`amd64` o `aarch64`/`arm64`, con `systemd`.
- Il server deve raggiungere GitHub; il client deve raggiungere la porta `6768` e l’indirizzo Pairing.
- Usa un indirizzo LAN, DNS, overlay o `wss://` raggiungibile; non usare `0.0.0.0`, `*` o `::`.

Le dipendenze Electron/GTK, Xvfb, DBus e QR vengono installate automaticamente. Consulta l’elenco completo nel [documento inglese](../../../README.md#dependencies).

## Comandi quotidiani

```bash
sudo orca-pair host
sudo orca-pair mobile
sudo orca-pair both
sudo orca-pair show
sudo orca-pair status
sudo orca-pair log
sudo orca-update
```

`host` crea l’URL desktop, `mobile` mostra il QR e `both` esegue entrambi i passaggi; il risultato è HOST/RUNTIME. `orca-update` e ogni riavvio del servizio cercano aggiornamenti.

## Risoluzione dei problemi

Controlla stato e log se Orca non si avvia o non compare l’URL di Pairing. Il comando attende fino a 60 secondi. Riesegui l’installer per inserire un nuovo indirizzo. Condividi gli URL di Pairing solo con persone e dispositivi fidati.

```bash
sudo orca-pair status
sudo orca-pair log
sudo ./install_orca.sh
```
