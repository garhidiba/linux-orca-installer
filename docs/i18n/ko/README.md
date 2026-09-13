# Orca Headless Linux Installer

<!-- i18n: locale=ko; source=README.md -->

[English (en)](../../../README.md) | **한국어 (ko)** | [다른 언어](../README.md)

[Orca 공식 웹사이트](https://onorca.dev) · [공식 GitHub 저장소](https://github.com/stablyai/orca)

## 문서

- [언어 선택 및 번역 가이드](../README.md)
- [영문 원문 (en)](../../../README.md)

화면이 없는 Linux 서버에서 Orca를 `systemd` 서비스로 실행하고, 데스크톱 또는 모바일 Orca와 페어링할 수 있게 해 주는 설치 스크립트입니다.

설치 스크립트는 최신 Orca AppImage와 필요한 Electron/GTK 런타임, 가상 디스플레이, QR 코드 도구를 설치합니다. 설치가 끝나면 서버가 재부팅되어도 Orca 서비스가 자동으로 시작되며, 서비스를 시작할 때마다 최신 버전을 확인합니다.

## 빠른 설치

설치할 서버에서 아래 명령을 실행합니다. 실행 중에는 Orca 클라이언트가 실제로 접근할 수 있는 **Pairing 주소**를 입력해야 합니다.

```bash
curl -fLO https://raw.githubusercontent.com/garhidiba/linux-orca-installer/main/install_orca.sh
chmod +x install_orca.sh
sudo ./install_orca.sh
```

스크립트를 파일로 남기지 않고 바로 실행하려면 다음 한 줄 명령을 사용할 수 있습니다. 운영 서버에서는 위의 내려받기 방식으로 내용을 확인한 뒤 실행하는 것을 권장합니다.

```bash
curl -fsSL https://raw.githubusercontent.com/garhidiba/linux-orca-installer/main/install_orca.sh | sudo -E bash
```

설치 과정은 다음 순서로 진행됩니다.

1. apt 패키지와 Orca 최신 AppImage를 설치합니다.
2. 모바일 페어링 QR 코드를 출력합니다. 모바일에서 스캔한 뒤 터미널에서 Enter를 누릅니다.
3. 데스크톱/런타임용 Pairing URL을 출력하고, 서비스는 최종적으로 HOST/RUNTIME 모드로 실행됩니다.

> 위 `raw.githubusercontent.com` 주소는 `main` 브랜치에 `install_orca.sh`가 커밋되고 push된 뒤 사용할 수 있습니다.

## 지원 환경

| 항목 | 지원 범위 |
| --- | --- |
| 배포판 | Debian, Ubuntu, Armbian, Orange Pi OS 등 `apt-get` 기반 Linux |
| CPU | `x86_64`/`amd64`, `aarch64`/`arm64` |
| 서비스 관리자 | `systemd` |
| 실행 방식 | GUI 없이 Xvfb 가상 디스플레이에서 Orca를 실행하는 headless 서버 |

다음 환경은 현재 스크립트의 지원 대상이 아닙니다.

- Fedora/RHEL, Arch, Alpine 등 `apt-get`을 사용하지 않는 배포판
- 32비트 ARM, `armv7`, x86 32비트 등 `x86_64`·`arm64` 이외의 CPU
- `systemd`가 없는 컨테이너 또는 최소 환경

### 설치 전 확인할 것

- 서버에서 `sudo`를 사용할 수 있어야 합니다.
- 서버가 GitHub 릴리스와 `raw.githubusercontent.com`에 연결할 수 있어야 합니다.
- TCP 포트 `6768`과 입력한 Pairing 주소는 사용할 Orca 클라이언트에서 접근 가능해야 합니다.
- 방화벽, NAT, 리버스 프록시, DNS는 이 스크립트가 설정하지 않습니다. 외부 네트워크에서 연결한다면 해당 환경에 맞게 별도로 구성하세요.

## Pairing 주소 선택

설치 중 주소를 입력하지 않으면 스크립트가 감지한 IPv4 주소를 기본값으로 제안합니다. 클라이언트가 서버에 도달할 때 쓰는 주소를 선택하세요.

| 사용 위치 | 입력 예시 |
| --- | --- |
| 같은 LAN | `192.168.50.121` |
| 로컬 DNS | `orangepi.local` |
| 오버레이 네트워크 | `100.80.10.20` |
| 준비된 외부 WebSocket 주소 | `wss://orca.example.com` |

`0.0.0.0`, `*`, `::`는 Pairing 주소로 허용되지 않습니다.

## 의존성 설치

별도로 패키지를 설치할 필요는 없습니다. 설치 스크립트가 `apt-get update` 후 아래 구성 요소를 자동 설치합니다.

| 용도 | 설치 패키지 |
| --- | --- |
| 설치 및 다운로드 | `curl`, `file`, `jq`, `ca-certificates` |
| 모바일 QR 및 headless 화면 | `qrencode`, `xvfb`, `xauth` |
| 세션 버스 | `dbus`, `dbus-x11` |
| Electron/Chromium 런타임 | `libnss3`, `libnspr4`, X11/XCB, GTK/AT-SPI, Pango/Cairo, GBM/DRM, 오디오 및 FUSE 라이브러리 |

Debian 13 계열의 `t64` 전환도 처리합니다. 아래 호환 패키지는 배포판에서 제공하는 이름을 자동으로 고릅니다.

```text
libatk1.0-0t64        또는 libatk1.0-0
libatk-bridge2.0-0t64 또는 libatk-bridge2.0-0
libatspi2.0-0t64      또는 libatspi2.0-0
libgtk-3-0t64         또는 libgtk-3-0
libcups2t64           또는 libcups2
libasound2t64         또는 libasound2
libfuse2t64           또는 libfuse2
```

의존성만 다시 설치하거나 복구해야 한다면 설치 스크립트를 다시 실행하세요. 배포판별 `t64` 패키지명을 수동으로 고를 필요가 없습니다.

```bash
sudo ./install_orca.sh
```

## 설치되는 구성

| 위치 | 내용 |
| --- | --- |
| `/opt/orca/orca.AppImage` | 다운로드한 Orca AppImage |
| `/opt/orca/update.sh` | 최신 버전 조회·다운로드 스크립트 |
| `/opt/orca/run.sh` | Xvfb/DBus 세션에서 Orca를 실행하는 래퍼 |
| `/opt/orca/.version` | 설치된 Orca 버전 |
| `/etc/orca/config.json` | Pairing 주소, 포트, 현재 모드 |
| `/etc/systemd/system/orca.service` | 자동 시작 서비스 |
| `/usr/local/sbin/orca-pair` | 페어링 및 상태 확인 명령 |
| `/usr/local/sbin/orca-update` | 수동 업데이트 명령 |
| `/var/lib/orca-pairing/` | 최근 생성한 Host·Mobile Pairing URL |

서비스는 설치를 `sudo`로 실행한 사용자의 계정으로 동작합니다. `root`로 직접 설치하면 `root` 계정으로 동작합니다.

## 일상 명령

### 페어링

| 명령 | 하는 일 |
| --- | --- |
| `sudo orca-pair host` | HOST/RUNTIME 모드로 재시작하고 데스크톱용 Pairing URL을 출력·저장합니다. |
| `sudo orca-pair mobile` | MOBILE 모드로 재시작하고 터미널에 QR 코드와 모바일 Pairing URL을 출력·저장합니다. |
| `sudo orca-pair both` | 모바일 QR 페어링을 마친 뒤 HOST/RUNTIME Pairing URL까지 연속으로 만듭니다. |
| `sudo orca-pair show` | 마지막으로 저장된 Host·Mobile Pairing URL을 표시합니다. |

`both`는 모바일 QR을 스캔한 뒤 Enter를 기다립니다. 마지막에는 HOST/RUNTIME 모드가 됩니다.

### 상태, 로그, 서비스

```bash
# Orca 설정과 systemd 서비스 상태
sudo orca-pair status

# 로그를 계속 표시
sudo orca-pair log

# systemd 상태 확인
systemctl status orca

# 서비스 재시작
sudo systemctl restart orca

# journal 로그를 계속 표시
journalctl -u orca -f -o cat
```

### 업데이트

```bash
# 최신 AppImage를 확인하고, 필요하면 내려받은 뒤 서비스를 재시작
sudo orca-update

# 서비스 재시작 시에도 업데이트 확인이 자동 실행됨
sudo systemctl restart orca
```

업데이트 확인에 실패하더라도 기존 AppImage가 설치되어 있다면 기존 버전으로 서비스를 계속 실행합니다. 처음 설치 중에는 AppImage를 내려받아야 하므로 네트워크 연결이 필요합니다.

## 문제 해결

### 지원하지 않는 아키텍처 오류

아래 명령의 결과가 `x86_64` 또는 `aarch64`인지 확인하세요.

```bash
uname -m
```

### 서비스가 시작되지 않음 또는 Pairing URL이 나오지 않음

현재 설정과 서비스 상태를 확인한 뒤, 로그를 열어 오류를 확인합니다.

```bash
sudo orca-pair status
sudo orca-pair log
```

Pairing URL 생성은 서비스 재시작 후 최대 60초간 기다립니다. 주소·포트·네트워크 접근 경로가 올바른지 확인하세요.

### 주소를 잘못 입력했음

설치 스크립트를 다시 실행해 새 Pairing 주소를 입력하면 `/etc/orca/config.json`과 서비스를 다시 구성합니다.

```bash
sudo ./install_orca.sh
```

### QR 코드가 보이지 않음

`sudo orca-pair mobile`은 QR 코드와 함께 모바일 Pairing URL도 텍스트로 출력합니다. QR을 읽기 어려운 터미널에서는 이 URL을 사용하세요.

## 운영 시 유의 사항

- Pairing URL은 신뢰하는 사용자와 기기에만 전달하세요. 터미널 기록, 화면 공유, 공개 이슈에 URL을 남기지 않는 편이 안전합니다.
- 새 Pairing URL이 필요하면 해당 대상에 맞춰 `sudo orca-pair host` 또는 `sudo orca-pair mobile`을 다시 실행하세요.
- 이 저장소의 스크립트에는 전용 제거 명령이 없습니다. 제거가 필요하다면 위의 설치 위치와 `orca.service`를 기준으로 운영 환경의 변경 절차를 수립한 뒤 진행하세요.
