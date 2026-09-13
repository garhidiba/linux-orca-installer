# مُثبِّت Orca لنظام Linux دون واجهة رسومية

<!-- i18n: locale=ar; source=README.md -->

[English (en)](../../../README.md) | **العربية (ar)** | [كل اللغات](../README.md)

يشغّل هذا المثبِّت Orca كخدمة `systemd` على خادم Linux دون واجهة رسومية، ثم يقرنه بتطبيق Orca على سطح المكتب أو الهاتف.

## التثبيت السريع

نفّذ الأوامر على الخادم. أثناء التثبيت، أدخل عنوان Pairing يستطيع العميل الوصول إليه.

```bash
curl -fLO https://raw.githubusercontent.com/garhidiba/linux-orca-installer/main/install_orca.sh
chmod +x install_orca.sh
sudo ./install_orca.sh
```

يثبّت البرنامج التبعيات وAppImage الأحدث، ويعرض رمز QR لاقتران الهاتف، ثم ينتهي في وضع HOST/RUNTIME.

## البيئة والاقتران

- مدعوم: Debian وUbuntu وArmbian وOrange Pi OS وأنظمة `apt-get`، ومعماريات `x86_64`/`amd64` و`aarch64`/`arm64` و`systemd`.
- يجب أن يصل الخادم إلى GitHub، وأن يتمكن العميل من الوصول إلى المنفذ `6768` وعنوان Pairing.
- استخدم عنوان LAN أو DNS أو شبكة overlay أو `wss://` الذي يصل إليه العميل؛ لا تستخدم `0.0.0.0` أو `*` أو `::`.

تُثبَّت تبعيات Electron/GTK وXvfb وDBus وQR تلقائياً. راجع [الوثيقة الإنجليزية](../../../README.md#dependencies) للقائمة الكاملة.

## الأوامر اليومية

```bash
sudo orca-pair host
sudo orca-pair mobile
sudo orca-pair both
sudo orca-pair show
sudo orca-pair status
sudo orca-pair log
sudo orca-update
```

`host` ينشئ رابط سطح المكتب، و`mobile` يعرض QR، و`both` ينفّذ الاثنين وينتهي بوضع HOST/RUNTIME. يفحص `orca-update`، وكذلك إعادة تشغيل الخدمة، إصداراً جديداً.

## حل المشكلات

تحقق من الحالة والسجل إذا لم يبدأ Orca أو لم يظهر رابط Pairing. ينتظر الأمر الرابط حتى 60 ثانية. أعد تشغيل المثبِّت لإدخال عنوان جديد. احتفظ بروابط Pairing للمستخدمين والأجهزة الموثوقة فقط.

```bash
sudo orca-pair status
sudo orca-pair log
sudo ./install_orca.sh
```
