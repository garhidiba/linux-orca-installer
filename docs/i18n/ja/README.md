# Orca ヘッドレス Linux インストーラー

<!-- i18n: locale=ja; source=README.md -->

[English (en)](../../../README.md) | **日本語 (ja)** | [すべての言語](../README.md)

[Official Orca website](https://onorca.dev) · [Official GitHub repository](https://github.com/stablyai/orca)

このインストーラーは Linux サーバーで Orca を GUI なしの `systemd` サービスとして実行し、デスクトップまたはモバイルの Orca とペアリングします。

## クイックスタート

サーバーで次のコマンドを実行します。インストール中に、クライアントから到達できる Pairing アドレスを入力します。

```bash
curl -fLO https://raw.githubusercontent.com/garhidiba/linux-orca-installer/main/install_orca.sh
chmod +x install_orca.sh
sudo ./install_orca.sh
```

スクリプトは依存関係と最新 AppImage をインストールし、モバイル Pairing 用 QR コードを表示して、HOST/RUNTIME モードで終了します。

## 対応環境と Pairing

- Debian、Ubuntu、Armbian、Orange Pi OS などの `apt-get` 環境、`x86_64`/`amd64` または `aarch64`/`arm64`、`systemd` に対応します。
- サーバーは GitHub に接続でき、クライアントはポート `6768` と Pairing アドレスに接続できる必要があります。
- 到達可能な LAN、DNS、overlay、または `wss://` アドレスを使用し、`0.0.0.0`、`*`、`::` は使用しないでください。

Electron/GTK、Xvfb、DBus、QR の依存関係は自動でインストールされます。完全な一覧は[英語版](../../../README.md#dependencies)を参照してください。

## 日常のコマンド

```bash
sudo orca-pair host
sudo orca-pair mobile
sudo orca-pair both
sudo orca-pair show
sudo orca-pair status
sudo orca-pair log
sudo orca-update
```

`host` はデスクトップ URL を作成し、`mobile` は QR を表示、`both` は両方を実行して HOST/RUNTIME で終了します。`orca-update` とサービス再起動は更新を確認します。

## トラブルシューティング

Orca が起動しない、または Pairing URL が出ない場合は状態とログを確認してください。コマンドは最大 60 秒待機します。別のアドレスを入力するにはインストーラーを再実行します。Pairing URL は信頼できる人と端末だけに共有してください。

```bash
sudo orca-pair status
sudo orca-pair log
sudo ./install_orca.sh
```
