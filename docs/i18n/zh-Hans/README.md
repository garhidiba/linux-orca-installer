# Orca 无图形界面 Linux 安装程序

<!-- i18n: locale=zh-Hans; source=README.md -->

[English (en)](../../../README.md) | **简体中文 (zh-Hans)** | [所有语言](../README.md)

此安装程序将 Orca 作为无图形界面的 `systemd` 服务运行在 Linux 服务器上，并与桌面版或移动版 Orca 配对。

## 快速开始

在服务器上运行以下命令。安装过程中请输入客户端可以访问的 Pairing 地址。

```bash
curl -fLO https://raw.githubusercontent.com/garhidiba/linux-orca-installer/main/install_orca.sh
chmod +x install_orca.sh
sudo ./install_orca.sh
```

脚本会安装依赖项和最新 AppImage，显示用于移动配对的二维码，并以 HOST/RUNTIME 模式结束。

## 环境与配对

- 支持 Debian、Ubuntu、Armbian、Orange Pi OS 和其他 `apt-get` 系统，支持 `x86_64`/`amd64` 或 `aarch64`/`arm64`，并需要 `systemd`。
- 服务器必须能访问 GitHub；客户端必须能访问端口 `6768` 和 Pairing 地址。
- 使用客户端可访问的 LAN、DNS、overlay 或 `wss://` 地址；不要使用 `0.0.0.0`、`*` 或 `::`。

Electron/GTK、Xvfb、DBus 和 QR 依赖项会自动安装。完整列表请参阅[英文文档](../../../README.md#dependencies)。

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

`host` 创建桌面 URL，`mobile` 显示二维码，`both` 完成两者并最终处于 HOST/RUNTIME。`orca-update` 和每次服务重启都会检查更新。

## 故障排除

如果 Orca 无法启动或未显示 Pairing URL，请检查状态和日志。命令最多等待 60 秒。重新运行安装程序可输入新地址。Pairing URL 仅应分享给可信人员和设备。

```bash
sudo orca-pair status
sudo orca-pair log
sudo ./install_orca.sh
```
