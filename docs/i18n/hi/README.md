# Orca हेडलेस Linux इंस्टॉलर

<!-- i18n: locale=hi; source=README.md -->

[English (en)](../../../README.md) | **हिन्दी (hi)** | [सभी भाषाएँ](../README.md)

[Official Orca website](https://onorca.dev) · [Official GitHub repository](https://github.com/stablyai/orca)

यह इंस्टॉलर Linux सर्वर पर Orca को बिना GUI वाले `systemd` सेवा के रूप में चलाता है और उसे डेस्कटॉप या मोबाइल Orca से पेयर करता है।

## त्वरित स्थापना

सर्वर पर ये कमांड चलाएँ। स्थापना के दौरान ऐसा Pairing पता दें जिस तक क्लाइंट पहुँच सके।

```bash
curl -fLO https://raw.githubusercontent.com/garhidiba/linux-orca-installer/main/install_orca.sh
chmod +x install_orca.sh
sudo ./install_orca.sh
```

स्क्रिप्ट निर्भरताएँ और नवीनतम AppImage स्थापित करती है, मोबाइल पेयरिंग के लिए QR दिखाती है और HOST/RUNTIME मोड में समाप्त होती है।

## परिवेश और पेयरिंग

- Debian, Ubuntu, Armbian, Orange Pi OS तथा अन्य `apt-get` सिस्टम, `x86_64`/`amd64` या `aarch64`/`arm64`, और `systemd` समर्थित हैं।
- सर्वर को GitHub तक पहुँच चाहिए; क्लाइंट को पोर्ट `6768` और Pairing पते तक पहुँचना चाहिए।
- पहुँच योग्य LAN, DNS, overlay या `wss://` पता दें; `0.0.0.0`, `*` या `::` न दें।

Electron/GTK, Xvfb, DBus और QR निर्भरताएँ स्वतः स्थापित होती हैं। पूरी सूची [अंग्रेज़ी मूल](../../../README.md#dependencies) में है।

## दैनिक कमांड

```bash
sudo orca-pair host
sudo orca-pair mobile
sudo orca-pair both
sudo orca-pair show
sudo orca-pair status
sudo orca-pair log
sudo orca-update
```

`host` डेस्कटॉप URL बनाता है, `mobile` QR दिखाता है और `both` दोनों करता है; अंत में HOST/RUNTIME रहता है। `orca-update` और हर सेवा पुनरारंभ अपडेट जाँचते हैं।

## समस्या निवारण

Orca शुरू न हो या Pairing URL न दिखे तो स्थिति और लॉग जाँचें। कमांड URL के लिए 60 सेकंड तक प्रतीक्षा करती है। नया पता दर्ज करने के लिए इंस्टॉलर फिर चलाएँ। Pairing URL केवल विश्वसनीय लोगों और उपकरणों के साथ साझा करें।

```bash
sudo orca-pair status
sudo orca-pair log
sudo ./install_orca.sh
```
