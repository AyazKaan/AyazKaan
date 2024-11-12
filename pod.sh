#!/bin/bash
set -e

# Sistem Güncelleme ve Gerekli Paketlerin Kurulumu
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y ca-certificates zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev tmux iptables curl nvme-cli git wget make jq libleveldb-dev build-essential pkg-config ncdu tar clang bsdmainutils lsb-release libssl-dev libreadline-dev libffi-dev jq gcc screen unzip lz4

# Python3 ve Pip3 Kurulumu
sudo apt install -y python3 python3-pip

# Podman ve Podman Compose Kurulumu
sudo apt-get install -y podman
pip3 install podman-compose


# SixGPT Kurulumu
mkdir -p sixgpt
cd sixgpt

# Değişkenleri Ayarlama (Özel anahtarı ve ağı kullanıcı değiştirebilir)
export VANA_PRIVATE_KEY=your_private_key
export VANA_NETWORK=moksha  # 'moksha' ya da 'satori' seçilebilir

# docker-compose.yml Dosyasını Otomatik Oluşturma
cat <<EOF > docker-compose.yml
version: '3.8'

services:
  ollama:
    image: ollama/ollama:0.3.12
    ports:
      - "11435:11434"
    volumes:
      - ollama:/root/.ollama
    restart: unless-stopped

  sixgpt3:
    image: sixgpt/miner:latest
    ports:
      - "3015:3000"
    depends_on:
      - ollama
    environment:
      - VANA_PRIVATE_KEY=\${VANA_PRIVATE_KEY}
      - VANA_NETWORK=\${VANA_NETWORK}
    restart: always

volumes:
  ollama:
EOF

# SixGPT’yi Başlatma
podman-compose up -d

# Başlangıç Logları
podman-compose logs -fn 100
