# Orca 無圖形介面 Linux 安裝程式

<!-- i18n: locale=zh-Hant; source=README.md -->

[English (en)](../../../README.md) | **繁體中文 (zh-Hant)** | [所有語言](../README.md)

[Official Orca website](https://onorca.dev) · [Official GitHub repository](https://github.com/stablyai/orca)

此安裝程式會在 Linux 伺服器上將 Orca 以無圖形介面的 `systemd` 服務執行，並與桌面版或行動版 Orca 配對。

## 快速開始

在伺服器上執行以下命令。安裝期間請輸入用戶端可連線的 Pairing 位址。

```bash
curl -fLO https://raw.githubusercontent.com/garhidiba/linux-orca-installer/main/install_orca.sh
chmod +x install_orca.sh
sudo ./install_orca.sh
```

指令碼會安裝相依項目和最新 AppImage，顯示行動配對用 QR code，並以 HOST/RUNTIME 模式結束。

## 環境與配對

- 支援 Debian、Ubuntu、Armbian、Orange Pi OS 與其他 `apt-get` 系統，支援 `x86_64`/`amd64` 或 `aarch64`/`arm64`，並需要 `systemd`。
- 伺服器必須能存取 GitHub；用戶端必須能存取連接埠 `6768` 與 Pairing 位址。
- 請使用用戶端可連線的 LAN、DNS、overlay 或 `wss://` 位址；勿使用 `0.0.0.0`、`*` 或 `::`。

Electron/GTK、Xvfb、DBus 與 QR 相依項目會自動安裝。完整清單請參閱[英文文件](../../../README.md#dependencies)。

## 日常命令

```bash
sudo orca-pair host
sudo orca-pair mobile
sudo orca-pair both
sudo orca-pair show
sudo orca-pair status
sudo orca-pair log
sudo orca-update
```

`host` 會建立桌面 URL，`mobile` 顯示 QR code，`both` 會完成兩者並最後處於 HOST/RUNTIME。`orca-update` 和每次服務重新啟動都會檢查更新。

## 疑難排解

若 Orca 無法啟動或沒有顯示 Pairing URL，請檢查狀態和日誌。命令最多等待 60 秒。重新執行安裝程式即可輸入新位址。Pairing URL 只應提供給受信任的人員和裝置。

```bash
sudo orca-pair status
sudo orca-pair log
sudo ./install_orca.sh
```
