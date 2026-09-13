# Programme d’installation Orca headless pour Linux

<!-- i18n: locale=fr; source=README.md -->

[English (en)](../../../README.md) | **Français (fr)** | [Toutes les langues](../README.md)

[Official Orca website](https://onorca.dev) · [Official GitHub repository](https://github.com/stablyai/orca)

Ce programme installe Orca comme service `systemd` sans interface graphique sur un serveur Linux et l’associe à Orca pour ordinateur ou mobile.

## Démarrage rapide

Exécutez ces commandes sur le serveur. L’installation demande une adresse de Pairing joignable par le client.

```bash
curl -fLO https://raw.githubusercontent.com/garhidiba/linux-orca-installer/main/install_orca.sh
chmod +x install_orca.sh
sudo ./install_orca.sh
```

Le script installe les dépendances et le dernier AppImage, affiche un QR code pour le mobile, puis termine en mode HOST/RUNTIME.

## Environnement et association

- Pris en charge : Debian, Ubuntu, Armbian, Orange Pi OS et autres systèmes `apt-get`, `x86_64`/`amd64` ou `aarch64`/`arm64`, avec `systemd`.
- Le serveur doit joindre GitHub ; le client doit joindre le port `6768` et l’adresse de Pairing.
- Utilisez une adresse LAN, DNS, overlay ou `wss://` accessible ; n’utilisez jamais `0.0.0.0`, `*` ou `::`.

Les dépendances Electron/GTK, Xvfb, DBus et QR sont installées automatiquement. Voir la liste complète dans le [document anglais](../../../README.md#dependencies).

## Commandes courantes

```bash
sudo orca-pair host
sudo orca-pair mobile
sudo orca-pair both
sudo orca-pair show
sudo orca-pair status
sudo orca-pair log
sudo orca-update
```

`host` crée l’URL ordinateur, `mobile` affiche le QR et `both` effectue les deux opérations ; le service finit en HOST/RUNTIME. `orca-update` et chaque redémarrage recherchent une mise à jour.

## Dépannage

Vérifiez l’état et les journaux si Orca ne démarre pas ou si aucune URL de Pairing n’apparaît. La commande attend jusqu’à 60 secondes. Relancez l’installateur pour saisir une autre adresse. Ne partagez les URL de Pairing qu’avec des personnes et appareils de confiance.

```bash
sudo orca-pair status
sudo orca-pair log
sudo ./install_orca.sh
```
