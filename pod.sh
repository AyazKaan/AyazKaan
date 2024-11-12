#!/bin/bash

set -e

# Güncellemeler ve Gerekli Paketlerin Kurulumu
echo "Updating system and installing dependencies..."
sudo apt update -y && sudo apt upgrade -y
sudo apt install -y ca-certificates zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev tmux iptables curl nvme-cli git wget make jq libleveldb-dev build-essential pkg-config ncdu tar clang bsdmainutils lsb-release libssl-dev libreadline-dev libffi-dev jq gcc screen unzip lz4

# Podman Kurulumu
echo "Installing Podman..."
sudo apt install -y podman

# Podman için Kullanıcı İzni Ayarlama
echo "Configuring user permissions for Podman..."
sudo groupadd -f podman
sudo usermod -aG podman $USER
newgrp podman

# Çevresel Değişkenler Ayarları
echo "Setting environment variables..."
export VANA_PRIVATE_KEY=your_private_key
export VANA_NETWORK=moksha

# Podman Pod ve Konteynerleri Başlatma
echo "Creating Pod and starting containers..."

# Pod Oluşturma
podman pod create --name sixgpt-pod -p 11435:11434 -p 3015:3000

# Ollama Servisini Başlatma
podman run -d --name ollama --pod sixgpt-pod --restart=always \
    -v ollama:/root/.ollama \
    ollama/ollama:0.3.12

# SixGPT3 Servisini Başlatma
podman run -d --name sixgpt3 --pod sixgpt-pod --restart=always \
    -e VANA_PRIVATE_KEY="$VANA_PRIVATE_KEY" \
    -e VANA_NETWORK="$VANA_NETWORK" \
    sixgpt/miner:latest

# Logları Görüntüleme
echo "Displaying logs..."
podman logs -f sixgpt3
