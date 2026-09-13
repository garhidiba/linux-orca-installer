# ตัวติดตั้ง Orca แบบไม่มีหน้าจอสำหรับ Linux

<!-- i18n: locale=th; source=README.md -->

[English (en)](../../../README.md) | **ไทย (th)** | [ทุกภาษา](../README.md)

[Official Orca website](https://onorca.dev) · [Official GitHub repository](https://github.com/stablyai/orca)

ตัวติดตั้งนี้รัน Orca เป็นบริการ `systemd` แบบไม่มี GUI บนเซิร์ฟเวอร์ Linux และจับคู่กับ Orca บนเดสก์ท็อปหรือมือถือ

## เริ่มต้นอย่างรวดเร็ว

รันคำสั่งเหล่านี้บนเซิร์ฟเวอร์ ระหว่างการติดตั้ง ให้ระบุ Pairing address ที่ไคลเอนต์เข้าถึงได้

```bash
curl -fLO https://raw.githubusercontent.com/garhidiba/linux-orca-installer/main/install_orca.sh
chmod +x install_orca.sh
sudo ./install_orca.sh
```

สคริปต์ติดตั้ง dependencies และ AppImage รุ่นล่าสุด แสดง QR สำหรับการจับคู่มือถือ และจบในโหมด HOST/RUNTIME

## สภาพแวดล้อมและการจับคู่

- รองรับ Debian, Ubuntu, Armbian, Orange Pi OS และระบบ `apt-get` อื่น ๆ, `x86_64`/`amd64` หรือ `aarch64`/`arm64` และ `systemd`
- เซิร์ฟเวอร์ต้องเข้าถึง GitHub ได้ และไคลเอนต์ต้องเข้าถึงพอร์ต `6768` กับ Pairing address ได้
- ใช้ LAN, DNS, overlay หรือ `wss://` ที่เข้าถึงได้ ห้ามใช้ `0.0.0.0`, `*` หรือ `::`

dependencies ของ Electron/GTK, Xvfb, DBus และ QR จะติดตั้งอัตโนมัติ ดูรายการทั้งหมดใน[เอกสารภาษาอังกฤษ](../../../README.md#dependencies)

## คำสั่งประจำวัน

```bash
sudo orca-pair host
sudo orca-pair mobile
sudo orca-pair both
sudo orca-pair show
sudo orca-pair status
sudo orca-pair log
sudo orca-update
```

`host` สร้าง URL สำหรับเดสก์ท็อป, `mobile` แสดง QR และ `both` ทำทั้งสองอย่าง โดยลงท้ายใน HOST/RUNTIME `orca-update` และทุกการรีสตาร์ตบริการจะตรวจสอบอัปเดต

## การแก้ปัญหา

ตรวจสอบสถานะและ log หาก Orca ไม่เริ่มหรือไม่มี Pairing URL คำสั่งจะรอ URL สูงสุด 60 วินาที รันตัวติดตั้งอีกครั้งเพื่อป้อนที่อยู่ใหม่ แชร์ Pairing URL เฉพาะกับบุคคลและอุปกรณ์ที่เชื่อถือได้

```bash
sudo orca-pair status
sudo orca-pair log
sudo ./install_orca.sh
```
