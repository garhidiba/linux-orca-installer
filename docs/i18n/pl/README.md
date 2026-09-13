# Instalator Orca headless dla Linuxa

<!-- i18n: locale=pl; source=README.md -->

[English (en)](../../../README.md) | **Polski (pl)** | [Wszystkie języki](../README.md)

Ten instalator uruchamia Orca jako usługę `systemd` bez interfejsu graficznego na serwerze Linux i paruje ją z Orca na komputerze lub telefonie.

## Szybki start

Uruchom te polecenia na serwerze. Podczas instalacji podaj adres Pairing dostępny dla klienta.

```bash
curl -fLO https://raw.githubusercontent.com/garhidiba/linux-orca-installer/main/install_orca.sh
chmod +x install_orca.sh
sudo ./install_orca.sh
```

Skrypt instaluje zależności i najnowszy AppImage, wyświetla kod QR do parowania mobilnego i kończy w trybie HOST/RUNTIME.

## Środowisko i parowanie

- Obsługiwane są Debian, Ubuntu, Armbian, Orange Pi OS i inne systemy `apt-get`, `x86_64`/`amd64` lub `aarch64`/`arm64` oraz `systemd`.
- Serwer musi mieć dostęp do GitHub; klient musi osiągać port `6768` i adres Pairing.
- Użyj osiągalnego adresu LAN, DNS, overlay lub `wss://`; nie używaj `0.0.0.0`, `*` ani `::`.

Zależności Electron/GTK, Xvfb, DBus i QR są instalowane automatycznie. Pełna lista znajduje się w [dokumencie angielskim](../../../README.md#dependencies).

## Codzienne polecenia

```bash
sudo orca-pair host
sudo orca-pair mobile
sudo orca-pair both
sudo orca-pair show
sudo orca-pair status
sudo orca-pair log
sudo orca-update
```

`host` tworzy URL pulpitu, `mobile` pokazuje QR, a `both` wykonuje oba kroki i kończy w HOST/RUNTIME. `orca-update` oraz każde ponowne uruchomienie usługi sprawdzają aktualizacje.

## Rozwiązywanie problemów

Sprawdź stan i log, jeżeli Orca nie startuje lub nie pojawia się URL Pairing. Polecenie czeka na URL do 60 sekund. Uruchom instalator ponownie, aby podać nowy adres. Udostępniaj URL-e Pairing tylko zaufanym osobom i urządzeniom.

```bash
sudo orca-pair status
sudo orca-pair log
sudo ./install_orca.sh
```
