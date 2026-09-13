# Pemasang Orca Headless Linux

<!-- i18n: locale=id; source=README.md -->

[English (en)](../../../README.md) | **Bahasa Indonesia (id)** | [Semua bahasa](../README.md)

[Official Orca website](https://onorca.dev) · [Official GitHub repository](https://github.com/stablyai/orca)

Pemasang ini menjalankan Orca sebagai layanan `systemd` tanpa antarmuka grafis pada server Linux, lalu memasangkannya dengan Orca desktop atau seluler.

## Mulai cepat

Jalankan perintah ini di server. Saat instalasi, masukkan alamat Pairing yang dapat dijangkau klien.

```bash
curl -fLO https://raw.githubusercontent.com/garhidiba/linux-orca-installer/main/install_orca.sh
chmod +x install_orca.sh
sudo ./install_orca.sh
```

Skrip memasang dependensi dan AppImage terbaru, menampilkan QR untuk pairing seluler, lalu berakhir dalam mode HOST/RUNTIME.

## Lingkungan dan pairing

- Didukung: Debian, Ubuntu, Armbian, Orange Pi OS, dan sistem `apt-get` lain, `x86_64`/`amd64` atau `aarch64`/`arm64`, serta `systemd`.
- Server memerlukan akses ke GitHub; klien harus dapat menjangkau port `6768` dan alamat Pairing.
- Gunakan alamat LAN, DNS, overlay, atau `wss://` yang dapat dijangkau; jangan gunakan `0.0.0.0`, `*`, atau `::`.

Dependensi Electron/GTK, Xvfb, DBus, dan QR dipasang otomatis. Daftar lengkap tersedia di [dokumen bahasa Inggris](../../../README.md#dependencies).

## Perintah sehari-hari

```bash
sudo orca-pair host
sudo orca-pair mobile
sudo orca-pair both
sudo orca-pair show
sudo orca-pair status
sudo orca-pair log
sudo orca-update
```

`host` membuat URL desktop, `mobile` menampilkan QR, dan `both` melakukan keduanya; hasil akhir adalah HOST/RUNTIME. `orca-update` dan setiap restart layanan memeriksa pembaruan.

## Pemecahan masalah

Periksa status dan log bila Orca tidak mulai atau URL Pairing tidak muncul. Perintah menunggu URL hingga 60 detik. Jalankan kembali pemasang untuk memasukkan alamat baru. Bagikan URL Pairing hanya kepada pengguna dan perangkat tepercaya.

```bash
sudo orca-pair status
sudo orca-pair log
sudo ./install_orca.sh
```
