#!/bin/bash

# tmux ve nano kurulumu
sudo apt update
sudo apt install -y tmux nano

# VANA_PRIVATE_KEY bilgisini kullanıcıdan talep et
echo "Lütfen VANA_PRIVATE_KEY değerini girin:"
read VANA_PRIVATE_KEY  # Girdiyi görünür hale getirdik

# Yeni bir tmux oturumu başlat
tmux new-session -d -s my_session

# İlk panelde yapılacak işlemler
tmux send-keys -t my_session 'cd sixgpt' C-m
tmux send-keys -t my_session "export VANA_PRIVATE_KEY=$VANA_PRIVATE_KEY" C-m
tmux send-keys -t my_session 'export VANA_NETWORK=moksha' C-m
tmux send-keys -t my_session 'docker compose up -d' C-m
tmux send-keys -t my_session 'docker compose logs -fn 100' C-m

# Ekranı yatay olarak böl
tmux split-window -v  # Yatay bölme (-v dikey yerine -h vardı)

# Alt panelde yapılacak işlemler
tmux send-keys -t my_session.1 'cd sixgpt' C-m
tmux send-keys -t my_session.1 'bash six.sh' C-m

# Kullanıcıyı tmux oturumuna bağla
tmux attach -t my_session
