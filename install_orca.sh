#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# Orca Headless Linux Installer
#
# 지원:
#   Debian / Ubuntu / Armbian / Orange Pi OS
#   x86_64 / arm64
#
# 설치 내용:
#   - Orca 최신 AppImage
#   - Electron/GTK 의존성
#   - Xvfb
#   - QR Code 출력용 qrencode
#   - systemd 서비스
#   - 서비스 재시작 시 Orca 업데이트 확인
#   - Host / Mobile pairing 전환
#
# 설치:
#   chmod +x install_orca.sh
#   sudo ./install_orca.sh
#
# 설치 후:
#   sudo orca-pair host
#   sudo orca-pair mobile
#   sudo orca-pair both
#   sudo orca-pair show
#   sudo orca-pair status
#   sudo orca-pair log
#   sudo orca-update
# ============================================================


# ============================================================
# ROOT
# ============================================================

if [ "$(id -u)" -ne 0 ]; then
    exec sudo -E bash "$0" "$@"
fi


# ============================================================
# 실행 사용자
# ============================================================

if [ -n "${SUDO_USER:-}" ] && [ "$SUDO_USER" != "root" ]; then
    RUN_USER="$SUDO_USER"
else
    RUN_USER="root"
fi


RUN_GROUP="$(id -gn "$RUN_USER")"

RUN_HOME="$(
    getent passwd "$RUN_USER" |
    cut -d: -f6
)"


if [ -z "$RUN_HOME" ]; then
    echo "[ERROR] 사용자 HOME 확인 실패: $RUN_USER"
    exit 1
fi


echo
echo "============================================================"
echo " Orca Headless Server Installer"
echo "============================================================"
echo
echo "실행 사용자 : $RUN_USER"
echo "HOME        : $RUN_HOME"
echo


# ============================================================
# Pairing 주소 입력
# ============================================================

DETECTED_IP="$(
    ip -4 route get 1.1.1.1 2>/dev/null |
    awk '{
        for (i=1; i<=NF; i++) {
            if ($i == "src") {
                print $(i+1)
                exit
            }
        }
    }'
)"


if [ -z "$DETECTED_IP" ]; then
    DETECTED_IP="$(
        hostname -I 2>/dev/null |
        awk '{print $1}'
    )"
fi


echo "Orca 클라이언트가 이 서버에 접근할 주소를 입력하세요."
echo
echo "예:"
echo "  192.168.50.121"
echo "  orangepi.local"
echo "  100.80.10.20"
echo "  wss://orca.example.com"
echo


if [ -n "$DETECTED_IP" ]; then

    read -r -p "Pairing 주소 [$DETECTED_IP]: " PAIRING_ADDRESS

    PAIRING_ADDRESS="${PAIRING_ADDRESS:-$DETECTED_IP}"

else

    read -r -p "Pairing 주소: " PAIRING_ADDRESS

fi


if [ -z "$PAIRING_ADDRESS" ]; then
    echo "[ERROR] Pairing 주소가 비어 있습니다."
    exit 1
fi


case "$PAIRING_ADDRESS" in

    0.0.0.0|\*|::)

        echo "[ERROR] $PAIRING_ADDRESS 는 Pairing 주소로 사용할 수 없습니다."

        exit 1
        ;;

esac


PORT=6768


echo
echo "Pairing Address : $PAIRING_ADDRESS"
echo "Port            : $PORT"
echo


# ============================================================
# CPU Architecture
# ============================================================

ARCH="$(uname -m)"


case "$ARCH" in

    x86_64|amd64)

        META_URL="https://github.com/stablyai/orca/releases/latest/download/latest-linux.yml"

        EXPECT_ARCH='x86-64|x86_64'
        ;;


    aarch64|arm64)

        META_URL="https://github.com/stablyai/orca/releases/latest/download/latest-linux-arm64.yml"

        EXPECT_ARCH='ARM aarch64|aarch64|ARM64'
        ;;


    *)

        echo "[ERROR] 지원하지 않는 아키텍처: $ARCH"

        exit 1
        ;;

esac


echo "[Orca] Architecture: $ARCH"


# ============================================================
# apt 확인
# ============================================================

if ! command -v apt-get >/dev/null 2>&1; then

    echo "[ERROR] 이 설치 스크립트는 apt 기반 Linux용입니다."
    echo "Debian / Ubuntu / Armbian / Orange Pi OS"

    exit 1

fi


# ============================================================
# 패키지 선택
#
# Debian 13: t64
# Debian 12 / Ubuntu: 기존 패키지
# ============================================================

choose_pkg() {

    local pkg

    for pkg in "$@"; do

        if apt-cache show "$pkg" >/dev/null 2>&1; then
            echo "$pkg"
            return 0
        fi

    done

    return 1
}


# ============================================================
# 의존성 설치
# ============================================================

echo
echo "============================================================"
echo " Orca 의존성 설치"
echo "============================================================"
echo


apt-get update


PACKAGES=(

    # installer
    curl
    file
    jq
    ca-certificates

    # QR Code
    qrencode

    # Headless display
    xvfb
    xauth

    # DBus
    dbus
    dbus-x11

    # Electron / Chromium
    libnss3
    libnspr4

    libx11-6
    libx11-xcb1
    libxcb1
    libxext6
    libxfixes3
    libxi6
    libxtst6
    libxss1

    libxcomposite1
    libxdamage1
    libxrandr2
    libxshmfence1

    libgbm1
    libdrm2
    libxkbcommon0

    libpango-1.0-0
    libcairo2

    zlib1g
)


# ------------------------------------------------------------
# t64 / legacy 자동 대응
# ------------------------------------------------------------

for candidates in \
    "libatk1.0-0t64 libatk1.0-0" \
    "libatk-bridge2.0-0t64 libatk-bridge2.0-0" \
    "libatspi2.0-0t64 libatspi2.0-0" \
    "libgtk-3-0t64 libgtk-3-0" \
    "libcups2t64 libcups2" \
    "libasound2t64 libasound2" \
    "libfuse2t64 libfuse2"
do

    # shellcheck disable=SC2086
    PKG="$(choose_pkg $candidates || true)"

    if [ -n "$PKG" ]; then
        PACKAGES+=("$PKG")
    fi

done


apt-get install -y "${PACKAGES[@]}"


echo
echo "[Orca] 의존성 설치 완료"


# ============================================================
# 디렉터리
# ============================================================

install -d -m 0755 /opt/orca
install -d -m 0755 /etc/orca
install -d -m 0700 /var/lib/orca-pairing


ORCA="/opt/orca/orca.AppImage"
VERSION_FILE="/opt/orca/.version"

CONFIG="/etc/orca/config.json"

PAIR_CACHE="/var/lib/orca-pairing"


# ============================================================
# CONFIG
# ============================================================

jq -n \
    --arg pairingAddress "$PAIRING_ADDRESS" \
    --argjson port "$PORT" \
    '{
        pairingAddress: $pairingAddress,
        port: $port,
        mode: "host"
    }' \
    > "$CONFIG"


chmod 0644 "$CONFIG"


# ============================================================
# UPDATE SCRIPT
# ============================================================

cat > /opt/orca/update.sh <<'UPDATE_EOF'
#!/usr/bin/env bash
set -euo pipefail


ORCA="/opt/orca/orca.AppImage"
VERSION_FILE="/opt/orca/.version"


ARCH="$(uname -m)"


case "$ARCH" in

    x86_64|amd64)

        META_URL="https://github.com/stablyai/orca/releases/latest/download/latest-linux.yml"

        EXPECT_ARCH='x86-64|x86_64'
        ;;


    aarch64|arm64)

        META_URL="https://github.com/stablyai/orca/releases/latest/download/latest-linux-arm64.yml"

        EXPECT_ARCH='ARM aarch64|aarch64|ARM64'
        ;;


    *)

        echo "[ERROR] 지원하지 않는 아키텍처: $ARCH"

        exit 1
        ;;

esac


echo "[Orca] 최신 버전 확인 중..."


# ------------------------------------------------------------
# metadata download
# ------------------------------------------------------------

if ! META="$(
    curl \
        -fsSL \
        --connect-timeout 10 \
        --max-time 30 \
        "$META_URL"
)"; then

    if [ -x "$ORCA" ]; then

        echo "[WARN] 최신 버전 조회 실패"
        echo "[Orca] 기존 설치본으로 계속 실행합니다."

        exit 0

    fi


    echo "[ERROR] Orca 메타데이터 다운로드 실패"

    exit 1

fi


# ------------------------------------------------------------
# version
# ------------------------------------------------------------

LATEST_VERSION="$(
    printf '%s\n' "$META" |
    awk '/^version:/ {
        gsub(/"/, "", $2)
        print $2
        exit
    }'
)"


# ------------------------------------------------------------
# asset
# ------------------------------------------------------------

ASSET="$(
    printf '%s\n' "$META" |
    awk '/^path:/ {
        sub(/^path:[[:space:]]*/, "")
        gsub(/"/, "")
        print
        exit
    }'
)"


if [ -z "$LATEST_VERSION" ] || [ -z "$ASSET" ]; then

    if [ -x "$ORCA" ]; then

        echo "[WARN] 최신 버전 정보 파싱 실패"
        echo "[Orca] 기존 설치본으로 계속 실행합니다."

        exit 0

    fi


    echo "[ERROR] 최신 Orca 정보를 확인할 수 없습니다."

    exit 1

fi


# ------------------------------------------------------------
# current version
# ------------------------------------------------------------

CURRENT_VERSION="unknown"


if [ -f "$VERSION_FILE" ]; then
    CURRENT_VERSION="$(cat "$VERSION_FILE")"
fi


echo "[Orca] 현재 버전 : $CURRENT_VERSION"
echo "[Orca] 최신 버전 : $LATEST_VERSION"


if [ -x "$ORCA" ] &&
   [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then

    echo "[Orca] 이미 최신 버전입니다."

    exit 0

fi


# ------------------------------------------------------------
# download
# ------------------------------------------------------------

DOWNLOAD_URL="https://github.com/stablyai/orca/releases/download/v${LATEST_VERSION}/${ASSET}"


TMP="$(mktemp /opt/orca/orca.AppImage.XXXXXX)"


cleanup() {
    rm -f "$TMP"
}


trap cleanup EXIT


echo "[Orca] 다운로드:"
echo "$DOWNLOAD_URL"


curl \
    -fL \
    --retry 3 \
    --retry-delay 2 \
    "$DOWNLOAD_URL" \
    -o "$TMP"


chmod +x "$TMP"


echo
echo "[Orca] 다운로드 파일 검증"


file "$TMP"


if ! file "$TMP" | grep -qiE "$EXPECT_ARCH"; then

    echo "[ERROR] CPU 아키텍처가 맞지 않는 AppImage입니다."

    exit 1

fi


install \
    -o root \
    -g root \
    -m 0755 \
    "$TMP" \
    "$ORCA"


printf '%s\n' "$LATEST_VERSION" > "$VERSION_FILE"

chmod 0644 "$VERSION_FILE"


echo "[Orca] 업데이트 완료: $LATEST_VERSION"

UPDATE_EOF


chmod 0755 /opt/orca/update.sh


# ============================================================
# ORCA RUNNER
# ============================================================

cat > /opt/orca/run.sh <<'RUN_EOF'
#!/usr/bin/env bash
set -euo pipefail


ORCA="/opt/orca/orca.AppImage"
CONFIG="/etc/orca/config.json"


PAIRING_ADDRESS="$(jq -r '.pairingAddress' "$CONFIG")"

PORT="$(jq -r '.port' "$CONFIG")"

MODE="$(jq -r '.mode' "$CONFIG")"


ARGS=(

    serve

    --port "$PORT"

    --pairing-address "$PAIRING_ADDRESS"

)


case "$MODE" in

    host|runtime)

        echo "[Orca] Pairing Mode: HOST / RUNTIME"
        ;;


    mobile)

        echo "[Orca] Pairing Mode: MOBILE"

        ARGS+=(--mobile-pairing)
        ;;


    *)

        echo "[ERROR] 알 수 없는 Pairing mode: $MODE"

        exit 1
        ;;

esac


echo "[Orca] 서버 시작"
echo "[Orca] Pairing Address: $PAIRING_ADDRESS"
echo "[Orca] Port: $PORT"


# ------------------------------------------------------------
# root일 경우 Electron sandbox 해제
# ------------------------------------------------------------

if [ "$(id -u)" -eq 0 ]; then

    ORCA_COMMAND=(

        "$ORCA"

        --no-sandbox

        "${ARGS[@]}"

    )

else

    ORCA_COMMAND=(

        "$ORCA"

        "${ARGS[@]}"

    )

fi


# ------------------------------------------------------------
# Xvfb + DBus session
# ------------------------------------------------------------

if command -v dbus-run-session >/dev/null 2>&1; then

    exec dbus-run-session -- \
        xvfb-run \
        -a \
        -s "-screen 0 1280x1024x24 -nolisten tcp" \
        env \
            LIBGL_ALWAYS_SOFTWARE=1 \
            "${ORCA_COMMAND[@]}"

else

    exec xvfb-run \
        -a \
        -s "-screen 0 1280x1024x24 -nolisten tcp" \
        env \
            LIBGL_ALWAYS_SOFTWARE=1 \
            "${ORCA_COMMAND[@]}"

fi

RUN_EOF


chmod 0755 /opt/orca/run.sh


# ============================================================
# SYSTEMD
# ============================================================

cat > /etc/systemd/system/orca.service <<EOF
[Unit]
Description=Orca Headless Server
After=network-online.target
Wants=network-online.target

[Service]
Type=simple

User=$RUN_USER
Group=$RUN_GROUP

WorkingDirectory=$RUN_HOME

Environment="HOME=$RUN_HOME"
Environment="LIBGL_ALWAYS_SOFTWARE=1"

RuntimeDirectory=orca
RuntimeDirectoryMode=0700
Environment="XDG_RUNTIME_DIR=/run/orca"

# ------------------------------------------------------------
# 서비스 시작할 때마다 최신 Orca 확인
#
# + prefix:
# User= 설정과 관계 없이 update.sh만 root 실행
# ------------------------------------------------------------

ExecStartPre=+/opt/orca/update.sh

ExecStart=/opt/orca/run.sh

Restart=on-failure
RestartSec=5

TimeoutStopSec=30

StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF


# ============================================================
# ORCA PAIR COMMAND
# ============================================================

cat > /usr/local/sbin/orca-pair <<'PAIR_EOF'
#!/usr/bin/env bash
set -euo pipefail


CONFIG="/etc/orca/config.json"

SERVICE="orca.service"

CACHE_DIR="/var/lib/orca-pairing"


# ============================================================
# ROOT
# ============================================================

if [ "$(id -u)" -ne 0 ]; then
    exec sudo "$0" "$@"
fi


# ============================================================
# MODE 변경
# ============================================================

set_mode() {

    local mode="$1"
    local tmp


    tmp="$(mktemp)"


    jq \
        --arg mode "$mode" \
        '.mode = $mode' \
        "$CONFIG" \
        > "$tmp"


    install \
        -o root \
        -g root \
        -m 0644 \
        "$tmp" \
        "$CONFIG"


    rm -f "$tmp"
}


# ============================================================
# 현재 상태
# ============================================================

show_status() {

    local address
    local port
    local mode


    address="$(jq -r '.pairingAddress' "$CONFIG")"

    port="$(jq -r '.port' "$CONFIG")"

    mode="$(jq -r '.mode' "$CONFIG")"


    echo
    echo "============================================================"
    echo " Orca Status"
    echo "============================================================"
    echo

    echo "Mode            : $mode"
    echo "Pairing Address : $address"
    echo "Port            : $port"

    echo


    systemctl \
        --no-pager \
        --full \
        status "$SERVICE" || true
}


# ============================================================
# 저장된 Pairing URL
# ============================================================

show_saved() {

    echo
    echo "============================================================"
    echo " Orca Pairing URLs"
    echo "============================================================"
    echo


    echo "[HOST / DESKTOP / RUNTIME]"

    if [ -s "$CACHE_DIR/host.url" ]; then

        cat "$CACHE_DIR/host.url"

    else

        echo "아직 생성되지 않음"

    fi


    echo
    echo


    echo "[MOBILE]"

    if [ -s "$CACHE_DIR/mobile.url" ]; then

        cat "$CACHE_DIR/mobile.url"

    else

        echo "아직 생성되지 않음"

    fi


    echo
}


# ============================================================
# 서비스 재시작 + Pairing URL 추출
# ============================================================

start_and_get_pairing() {

    local mode="$1"


    set_mode "$mode"


    echo
    echo "[Orca] Pairing mode: $mode"
    echo "[Orca] 서비스 재시작"
    echo


    systemctl restart "$SERVICE"


    # --------------------------------------------------------
    # 현재 service invocation
    # --------------------------------------------------------

    local invocation_id


    invocation_id="$(
        systemctl show \
            -p InvocationID \
            --value \
            "$SERVICE"
    )"


    if [ -z "$invocation_id" ]; then

        echo "[ERROR] systemd InvocationID를 가져올 수 없습니다."

        exit 1

    fi


    echo "[Orca] Pairing 정보 생성 대기 중..."


    local logs=""
    local pair_url=""


    # 최대 60초
    for _ in $(seq 1 60); do

        logs="$(
            journalctl \
                "_SYSTEMD_INVOCATION_ID=$invocation_id" \
                -o cat \
                --no-pager \
                2>/dev/null || true
        )"


        pair_url="$(
            printf '%s\n' "$logs" |
            sed -n \
                's/^Pairing URL:[[:space:]]*//p' |
            tail -n 1
        )"


        if [ -n "$pair_url" ]; then
            break
        fi


        if ! systemctl is-active --quiet "$SERVICE"; then

            echo
            echo "[ERROR] Orca 서비스가 종료되었습니다."
            echo

            printf '%s\n' "$logs"

            exit 1

        fi


        sleep 1

    done


    if [ -z "$pair_url" ]; then

        echo
        echo "[ERROR] Pairing URL 생성 시간 초과"
        echo
        echo "Orca 로그:"
        echo

        printf '%s\n' "$logs"

        exit 1

    fi


    PAIR_URL="$pair_url"


    ADVERTISED_ENDPOINT="$(
        printf '%s\n' "$logs" |
        sed -n \
            's/^Advertised endpoint:[[:space:]]*//p' |
        tail -n 1
    )"


    WEB_URL="$(
        printf '%s\n' "$logs" |
        sed -n \
            's/^Web client URL:[[:space:]]*//p' |
        tail -n 1
    )"
}


# ============================================================
# URL 저장
# ============================================================

save_url() {

    local name="$1"
    local url="$2"


    install -d \
        -o root \
        -g root \
        -m 0700 \
        "$CACHE_DIR"


    printf '%s\n' "$url" \
        > "$CACHE_DIR/$name.url"


    chmod 0600 \
        "$CACHE_DIR/$name.url"
}


# ============================================================
# HOST PAIR
# ============================================================

host_pair() {

    start_and_get_pairing "host"


    save_url \
        "host" \
        "$PAIR_URL"


    echo
    echo
    echo "============================================================"
    echo " HOST / DESKTOP PAIRING"
    echo "============================================================"
    echo


    if [ -n "${ADVERTISED_ENDPOINT:-}" ]; then

        echo "Endpoint:"
        echo "$ADVERTISED_ENDPOINT"

        echo

    fi


    echo "Pairing URL:"
    echo "$PAIR_URL"

    echo


    if [ -n "${WEB_URL:-}" ]; then

        echo "Web Client:"
        echo "$WEB_URL"

        echo

    fi


    echo "현재 Orca는 HOST / RUNTIME 모드로 실행 중입니다."
    echo
}


# ============================================================
# MOBILE PAIR
# ============================================================

mobile_pair() {

    start_and_get_pairing "mobile"


    save_url \
        "mobile" \
        "$PAIR_URL"


    echo
    echo
    echo "============================================================"
    echo " MOBILE PAIRING"
    echo "============================================================"
    echo


    if [ -n "${ADVERTISED_ENDPOINT:-}" ]; then

        echo "Endpoint:"
        echo "$ADVERTISED_ENDPOINT"

        echo

    fi


    echo "QR Code:"
    echo


    # --------------------------------------------------------
    # Orca가 발급한 MOBILE Pairing URL로 QR 생성
    # --------------------------------------------------------

    qrencode \
        -t ANSIUTF8 \
        "$PAIR_URL"


    echo
    echo


    echo "Mobile Pairing URL:"
    echo "$PAIR_URL"


    echo
    echo "휴대폰 Orca에서 위 QR Code를 스캔하세요."
    echo
}


# ============================================================
# MOBILE → HOST
# ============================================================

both_pair() {

    # --------------------------------------------------------
    # Mobile
    # --------------------------------------------------------

    mobile_pair


    echo
    echo "============================================================"
    echo


    read -r -p \
        "모바일 페어링을 완료했으면 Enter를 누르세요: " _


    # --------------------------------------------------------
    # Host
    # --------------------------------------------------------

    host_pair


    echo
    echo "============================================================"
    echo " Pairing 완료"
    echo "============================================================"
    echo

    echo "최종 서비스 모드: HOST / RUNTIME"
    echo


    show_saved
}


# ============================================================
# COMMAND
# ============================================================

COMMAND="${1:-status}"


case "$COMMAND" in

    host|runtime)

        host_pair
        ;;


    mobile)

        mobile_pair
        ;;


    both)

        both_pair
        ;;


    show)

        show_saved
        ;;


    status)

        show_status
        ;;


    log)

        journalctl \
            -u "$SERVICE" \
            -f \
            -o cat
        ;;


    *)

        echo
        echo "사용법:"
        echo
        echo "  orca-pair host"
        echo "  orca-pair mobile"
        echo "  orca-pair both"
        echo "  orca-pair show"
        echo "  orca-pair status"
        echo "  orca-pair log"
        echo

        exit 1
        ;;

esac

PAIR_EOF


chmod 0755 /usr/local/sbin/orca-pair


# ============================================================
# MANUAL UPDATE COMMAND
# ============================================================

cat > /usr/local/sbin/orca-update <<'MANUAL_UPDATE_EOF'
#!/usr/bin/env bash
set -euo pipefail


if [ "$(id -u)" -ne 0 ]; then
    exec sudo "$0" "$@"
fi


/opt/orca/update.sh


echo
echo "[Orca] 서비스 재시작"


systemctl restart orca.service


echo


systemctl \
    --no-pager \
    --full \
    status orca.service

MANUAL_UPDATE_EOF


chmod 0755 /usr/local/sbin/orca-update


# ============================================================
# 최초 Orca 다운로드
# ============================================================

echo
echo "============================================================"
echo " Orca 최신 AppImage 설치"
echo "============================================================"
echo


/opt/orca/update.sh


# ============================================================
# systemd 등록
# ============================================================

echo
echo "============================================================"
echo " systemd 등록"
echo "============================================================"
echo


systemctl daemon-reload

systemctl enable orca.service


# ============================================================
# 설치 후 Pairing
#
# 1. Mobile mode
# 2. 실제 mobile Pairing URL 확인
# 3. QR Code 출력
# 4. 사용자가 스캔
# 5. Enter
# 6. Host/runtime mode
# 7. Host URL 출력
# ============================================================

echo
echo "============================================================"
echo " Orca Pairing 설정"
echo "============================================================"
echo

echo "먼저 모바일 Pairing을 시작합니다."
echo "잠시 후 QR Code가 표시됩니다."
echo


/usr/local/sbin/orca-pair both


# ============================================================
# 완료
# ============================================================

echo
echo
echo "============================================================"
echo " Orca 설치 완료"
echo "============================================================"
echo


echo "사용자          : $RUN_USER"
echo "Architecture    : $ARCH"
echo "Pairing Address : $PAIRING_ADDRESS"
echo "Port            : $PORT"


echo
echo "------------------------------------------------------------"
echo "마지막으로 생성한 Pairing 주소"
echo "------------------------------------------------------------"


/usr/local/sbin/orca-pair show


echo
echo "------------------------------------------------------------"
echo "Pairing 명령"
echo "------------------------------------------------------------"
echo

echo "Host / Desktop:"
echo "  sudo orca-pair host"

echo

echo "Mobile + QR Code:"
echo "  sudo orca-pair mobile"

echo

echo "Mobile QR → Host 연속:"
echo "  sudo orca-pair both"

echo

echo "저장된 두 Pairing URL:"
echo "  sudo orca-pair show"


echo
echo "------------------------------------------------------------"
echo "Service"
echo "------------------------------------------------------------"
echo

echo "상태:"
echo "  systemctl status orca"

echo

echo "재시작:"
echo "  sudo systemctl restart orca"

echo

echo "로그:"
echo "  journalctl -u orca -f -o cat"


echo
echo "------------------------------------------------------------"
echo "Update"
echo "------------------------------------------------------------"
echo

echo "수동 업데이트:"
echo "  sudo orca-update"

echo

echo "서비스 restart도 최신 버전을 확인합니다:"
echo "  sudo systemctl restart orca"


echo
echo "============================================================"
echo " 최종 실행 모드: HOST / RUNTIME"
echo "============================================================"
echo