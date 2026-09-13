# Інсталятор Orca без графічного інтерфейсу для Linux

<!-- i18n: locale=uk; source=README.md -->

[English (en)](../../../README.md) | **Українська (uk)** | [Усі мови](../README.md)

Цей інсталятор запускає Orca як службу `systemd` без графічного інтерфейсу на сервері Linux і виконує сполучення з Orca для комп’ютера або мобільного пристрою.

## Швидкий старт

Виконайте ці команди на сервері. Під час встановлення вкажіть адресу Pairing, доступну для клієнта.

```bash
curl -fLO https://raw.githubusercontent.com/garhidiba/linux-orca-installer/main/install_orca.sh
chmod +x install_orca.sh
sudo ./install_orca.sh
```

Скрипт установлює залежності й останній AppImage, показує QR-код для мобільного сполучення та завершується в режимі HOST/RUNTIME.

## Середовище та сполучення

- Підтримуються Debian, Ubuntu, Armbian, Orange Pi OS та інші системи з `apt-get`, `x86_64`/`amd64` або `aarch64`/`arm64`, а також `systemd`.
- Серверу потрібен доступ до GitHub; клієнт має отримувати доступ до порту `6768` та адреси Pairing.
- Використовуйте доступну LAN-, DNS-, overlay- або `wss://`-адресу; не використовуйте `0.0.0.0`, `*` або `::`.

Залежності Electron/GTK, Xvfb, DBus і QR встановлюються автоматично. Повний список є в [англійському документі](../../../README.md#dependencies).

## Щоденні команди

```bash
sudo orca-pair host
sudo orca-pair mobile
sudo orca-pair both
sudo orca-pair show
sudo orca-pair status
sudo orca-pair log
sudo orca-update
```

`host` створює URL для комп’ютера, `mobile` показує QR-код, а `both` виконує обидва кроки й залишає HOST/RUNTIME. `orca-update` і кожен перезапуск служби перевіряють оновлення.

## Усунення несправностей

Перевірте стан і журнал, якщо Orca не запускається або URL Pairing не з’являється. Команда чекає URL до 60 секунд. Запустіть інсталятор повторно, щоб ввести іншу адресу. Передавайте URL Pairing лише довіреним людям і пристроям.

```bash
sudo orca-pair status
sudo orca-pair log
sudo ./install_orca.sh
```
