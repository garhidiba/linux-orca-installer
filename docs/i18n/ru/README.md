# Установщик Orca для Linux без графического интерфейса

<!-- i18n: locale=ru; source=README.md -->

[English (en)](../../../README.md) | **Русский (ru)** | [Все языки](../README.md)

Этот установщик запускает Orca как службу `systemd` без графического интерфейса на сервере Linux и выполняет сопряжение с Orca для настольного компьютера или телефона.

## Быстрый запуск

Выполните команды на сервере. Во время установки укажите адрес Pairing, доступный клиенту.

```bash
curl -fLO https://raw.githubusercontent.com/garhidiba/linux-orca-installer/main/install_orca.sh
chmod +x install_orca.sh
sudo ./install_orca.sh
```

Скрипт устанавливает зависимости и последнюю версию AppImage, выводит QR-код для мобильного сопряжения и завершает работу в режиме HOST/RUNTIME.

## Среда и сопряжение

- Поддерживаются Debian, Ubuntu, Armbian, Orange Pi OS и другие системы с `apt-get`, `x86_64`/`amd64` или `aarch64`/`arm64`, а также `systemd`.
- Серверу нужен доступ к GitHub; клиент должен иметь доступ к порту `6768` и адресу Pairing.
- Используйте доступный адрес LAN, DNS, overlay или `wss://`; не используйте `0.0.0.0`, `*` или `::`.

Зависимости Electron/GTK, Xvfb, DBus и QR устанавливаются автоматически. Полный список приведён в [английском документе](../../../README.md#dependencies).

## Повседневные команды

```bash
sudo orca-pair host
sudo orca-pair mobile
sudo orca-pair both
sudo orca-pair show
sudo orca-pair status
sudo orca-pair log
sudo orca-update
```

`host` создаёт URL для компьютера, `mobile` показывает QR-код, а `both` выполняет оба шага и оставляет HOST/RUNTIME. `orca-update` и каждый перезапуск службы проверяют обновления.

## Устранение неполадок

Проверьте состояние и журнал, если Orca не запускается или не появляется URL Pairing. Команда ждёт URL до 60 секунд. Запустите установщик снова, чтобы ввести другой адрес. Передавайте URL Pairing только доверенным людям и устройствам.

```bash
sudo orca-pair status
sudo orca-pair log
sudo ./install_orca.sh
```
