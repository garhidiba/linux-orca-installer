# Instalador Linux sem interface gráfica do Orca

<!-- i18n: locale=pt-BR; source=README.md -->

[English (en)](../../../README.md) | **Português (Brasil) (pt-BR)** | [Todos os idiomas](../README.md)

[Official Orca website](https://onorca.dev) · [Official GitHub repository](https://github.com/stablyai/orca)

Este instalador executa o Orca como serviço `systemd` sem interface gráfica em um servidor Linux e o emparelha com o Orca para desktop ou celular.

## Início rápido

Execute estes comandos no servidor. Durante a instalação, informe um endereço de Pairing que o cliente consiga acessar.

```bash
curl -fLO https://raw.githubusercontent.com/garhidiba/linux-orca-installer/main/install_orca.sh
chmod +x install_orca.sh
sudo ./install_orca.sh
```

O script instala dependências e o AppImage mais recente, mostra um QR para o emparelhamento móvel e termina no modo HOST/RUNTIME.

## Ambiente e emparelhamento

- Suportados: Debian, Ubuntu, Armbian, Orange Pi OS e outros sistemas `apt-get`, `x86_64`/`amd64` ou `aarch64`/`arm64`, com `systemd`.
- O servidor precisa acessar o GitHub; o cliente precisa alcançar a porta `6768` e o endereço de Pairing.
- Use um endereço LAN, DNS, overlay ou `wss://` acessível; não use `0.0.0.0`, `*` ou `::`.

As dependências Electron/GTK, Xvfb, DBus e QR são instaladas automaticamente. Consulte a lista completa no [documento em inglês](../../../README.md#dependencies).

## Comandos diários

```bash
sudo orca-pair host
sudo orca-pair mobile
sudo orca-pair both
sudo orca-pair show
sudo orca-pair status
sudo orca-pair log
sudo orca-update
```

`host` cria a URL de desktop, `mobile` mostra o QR e `both` executa ambos; o resultado final é HOST/RUNTIME. `orca-update` e cada reinício do serviço verificam atualizações.

## Solução de problemas

Verifique o estado e os logs se o Orca não iniciar ou se não aparecer uma URL de Pairing. O comando espera até 60 segundos. Execute o instalador novamente para inserir outro endereço. Compartilhe URLs de Pairing apenas com pessoas e dispositivos confiáveis.

```bash
sudo orca-pair status
sudo orca-pair log
sudo ./install_orca.sh
```
