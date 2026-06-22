#!/bin/bash
set -e

#Installazione dipendenze
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y ffmpeg curl

#Download di Navidrome
mkdir -p /opt/navidrome /var/lib/navidrome/music
DOWNLOAD_URL=$(curl -s https://api.github.com/repos/navidrome/navidrome/releases/latest \
  | grep "browser_download_url" | grep "linux_amd64.tar.gz" | cut -d '"' -f 4)
curl -L "$DOWNLOAD_URL" -o /tmp/navidrome.tar.gz
tar -xzf /tmp/navidrome.tar.gz -C /opt/navidrome navidrome

#Copia della musica
cp /vagrant/music/* /var/lib/navidrome/music/ 2>/dev/null || true

#Configurazione del servizio
cat > /etc/systemd/system/navidrome.service <<'EOF'
[Unit]
Description=Navidrome Music Server
After=network.target

[Service]
ExecStart=/opt/navidrome/navidrome
WorkingDirectory=/var/lib/navidrome
Environment=ND_MUSICFOLDER=/var/lib/navidrome/music
Environment=ND_ADDRESS=0.0.0.0
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now navidrome

