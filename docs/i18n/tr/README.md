# Orca Headless Linux Kurucusu

<!-- i18n: locale=tr; source=README.md -->

[English (en)](../../../README.md) | **Türkçe (tr)** | [Tüm diller](../README.md)

[Official Orca website](https://onorca.dev) · [Official GitHub repository](https://github.com/stablyai/orca)

Bu kurucu, Orca’yı Linux sunucusunda grafik arayüz olmadan bir `systemd` hizmeti olarak çalıştırır ve masaüstü veya mobil Orca ile eşleştirir.

## Hızlı başlangıç

Bu komutları sunucuda çalıştırın. Kurulum sırasında istemcinin erişebileceği bir Pairing adresi girin.

```bash
curl -fLO https://raw.githubusercontent.com/garhidiba/linux-orca-installer/main/install_orca.sh
chmod +x install_orca.sh
sudo ./install_orca.sh
```

Betik bağımlılıkları ve son AppImage’ı kurar, mobil eşleştirme için QR gösterir ve HOST/RUNTIME modunda tamamlanır.

## Ortam ve eşleştirme

- Debian, Ubuntu, Armbian, Orange Pi OS ve diğer `apt-get` sistemleri; `x86_64`/`amd64` veya `aarch64`/`arm64`; ayrıca `systemd` desteklenir.
- Sunucunun GitHub’a erişmesi, istemcinin de `6768` portuna ve Pairing adresine ulaşması gerekir.
- Erişilebilir bir LAN, DNS, overlay veya `wss://` adresi kullanın; `0.0.0.0`, `*` ya da `::` kullanmayın.

Electron/GTK, Xvfb, DBus ve QR bağımlılıkları otomatik kurulur. Tam liste için [İngilizce belgeye](../../../README.md#dependencies) bakın.

## Günlük komutlar

```bash
sudo orca-pair host
sudo orca-pair mobile
sudo orca-pair both
sudo orca-pair show
sudo orca-pair status
sudo orca-pair log
sudo orca-update
```

`host` masaüstü URL’sini oluşturur, `mobile` QR gösterir, `both` ikisini de yapar ve HOST/RUNTIME ile biter. `orca-update` ve her hizmet yeniden başlatması güncelleme denetler.

## Sorun giderme

Orca başlamazsa veya Pairing URL görünmezse durum ve günlükleri denetleyin. Komut URL için 60 saniyeye kadar bekler. Yeni adres girmek için kurucuyu yeniden çalıştırın. Pairing URL’lerini yalnızca güvenilir kişi ve cihazlarla paylaşın.

```bash
sudo orca-pair status
sudo orca-pair log
sudo ./install_orca.sh
```
