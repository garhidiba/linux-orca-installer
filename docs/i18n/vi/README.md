# Trình cài đặt Orca Linux không giao diện

<!-- i18n: locale=vi; source=README.md -->

[English (en)](../../../README.md) | **Tiếng Việt (vi)** | [Tất cả ngôn ngữ](../README.md)

[Official Orca website](https://onorca.dev) · [Official GitHub repository](https://github.com/stablyai/orca)

Trình cài đặt này chạy Orca như một dịch vụ `systemd` không có giao diện đồ họa trên máy chủ Linux và ghép cặp với Orca trên máy tính hoặc di động.

## Bắt đầu nhanh

Chạy các lệnh này trên máy chủ. Trong khi cài đặt, hãy nhập địa chỉ Pairing mà máy khách có thể truy cập.

```bash
curl -fLO https://raw.githubusercontent.com/garhidiba/linux-orca-installer/main/install_orca.sh
chmod +x install_orca.sh
sudo ./install_orca.sh
```

Tập lệnh cài đặt các phụ thuộc và AppImage mới nhất, hiển thị QR để ghép cặp di động, rồi kết thúc ở chế độ HOST/RUNTIME.

## Môi trường và ghép cặp

- Hỗ trợ Debian, Ubuntu, Armbian, Orange Pi OS và các hệ thống `apt-get` khác, `x86_64`/`amd64` hoặc `aarch64`/`arm64`, cùng `systemd`.
- Máy chủ cần truy cập GitHub; máy khách phải truy cập được cổng `6768` và địa chỉ Pairing.
- Dùng địa chỉ LAN, DNS, overlay hoặc `wss://` có thể truy cập; không dùng `0.0.0.0`, `*` hoặc `::`.

Các phụ thuộc Electron/GTK, Xvfb, DBus và QR được cài tự động. Xem danh sách đầy đủ trong [tài liệu tiếng Anh](../../../README.md#dependencies).

## Lệnh hằng ngày

```bash
sudo orca-pair host
sudo orca-pair mobile
sudo orca-pair both
sudo orca-pair show
sudo orca-pair status
sudo orca-pair log
sudo orca-update
```

`host` tạo URL máy tính, `mobile` hiện QR và `both` thực hiện cả hai; kết quả là HOST/RUNTIME. `orca-update` và mỗi lần khởi động lại dịch vụ đều kiểm tra cập nhật.

## Khắc phục sự cố

Kiểm tra trạng thái và log nếu Orca không khởi động hoặc không có URL Pairing. Lệnh chờ URL tối đa 60 giây. Chạy lại trình cài đặt để nhập địa chỉ mới. Chỉ chia sẻ URL Pairing với người và thiết bị đáng tin cậy.

```bash
sudo orca-pair status
sudo orca-pair log
sudo ./install_orca.sh
```
