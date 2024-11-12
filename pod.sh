#!/bin/bash

set -e

# Güncellemeler ve Gerekli Paketlerin Kurulumu
echo "Updating system and installing dependencies..."
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y ca-certificates zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev tmux iptables curl nvme-cli git wget make jq libleveldb-dev build-essential pkg-config ncdu tar clang bsdmainutils lsb-release libssl-dev libreadline-dev libffi-dev jq gcc screen unzip lz4

# Podman ve Podman Compose Kurulumu
echo "Installing Podman and Podman Compose..."
sudo apt install -y podman

# SixGPT Dizini ve Çevresel Değişkenler Ayarları
echo "Setting up SixGPT directory and environment variables..."
mkdir -p sixgpt
cd sixgpt
export VANA_PRIVATE_KEY=your_private_key
export VANA_NETWORK=moksha

# docker-compose.yml Dosyası Oluşturma
echo "Creating docker-compose.yml file..."
cat <<EOL > docker-compose.yml
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
EOL

# Podman Compose ile SixGPT Başlatma
echo "Starting SixGPT services with Podman Compose..."
podman-compose up -d

# Logları Görüntüleme
echo "Displaying logs..."
podman-compose logs -fn 100
