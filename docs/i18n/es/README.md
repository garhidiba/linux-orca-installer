# Instalador de Orca Headless para Linux

<!-- i18n: locale=es; source=README.md -->

[English (en)](../../../README.md) | **Español (es)** | [Todos los idiomas](../README.md)

[Official Orca website](https://onorca.dev) · [Official GitHub repository](https://github.com/stablyai/orca)

Este instalador ejecuta Orca como servicio `systemd` sin interfaz gráfica en un servidor Linux y lo empareja con Orca de escritorio o móvil.

## Inicio rápido

Ejecuta estos comandos en el servidor. Durante la instalación se solicita una dirección de Pairing accesible para el cliente.

```bash
curl -fLO https://raw.githubusercontent.com/garhidiba/linux-orca-installer/main/install_orca.sh
chmod +x install_orca.sh
sudo ./install_orca.sh
```

El script instala dependencias y el AppImage más reciente, muestra un QR para el emparejamiento móvil y termina en modo HOST/RUNTIME.

## Entorno y emparejamiento

- Compatible con Debian, Ubuntu, Armbian, Orange Pi OS y otros sistemas `apt-get`, `x86_64`/`amd64` o `aarch64`/`arm64`, y `systemd`.
- El servidor necesita acceso a GitHub; el cliente debe poder alcanzar el puerto `6768` y la dirección de Pairing.
- Usa una dirección LAN, DNS, overlay o `wss://` accesible; no uses `0.0.0.0`, `*` ni `::`.

Las dependencias de Electron/GTK, Xvfb, DBus y QR se instalan automáticamente. Consulta la lista completa en el [original en inglés](../../../README.md#dependencies).

## Comandos diarios

```bash
sudo orca-pair host
sudo orca-pair mobile
sudo orca-pair both
sudo orca-pair show
sudo orca-pair status
sudo orca-pair log
sudo orca-update
```

`host` crea la URL de escritorio, `mobile` muestra el QR y `both` realiza ambos pasos; termina en HOST/RUNTIME. `orca-update` y cada reinicio del servicio buscan actualizaciones.

## Solución de problemas

Consulta estado y registros si Orca no inicia o no aparece una URL de Pairing. El comando espera hasta 60 segundos. Ejecuta de nuevo el instalador para introducir otra dirección. Comparte las URL de Pairing solo con personas y dispositivos de confianza.

```bash
sudo orca-pair status
sudo orca-pair log
sudo ./install_orca.sh
```
