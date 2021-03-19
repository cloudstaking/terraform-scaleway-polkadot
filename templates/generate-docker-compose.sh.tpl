#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset

arg="$${1:-}"
IP=""

case $arg in
  scaleway)
    IP=$(scw-metadata PUBLIC_IP_ADDRESS)
    ;;

  aws)
    IP="aws"
    ;;

  gcp)
    IP="gcp"
    ;;

  digitalocean)
    IP=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)
    ;;

  *)
    echo "Error, you must indicate cloud-provider"
    ;;
esac

cat <<- EOF > /srv/docker-compose.yml
version: "3.3"

services:
  validator:
    image: parity/polkadot:${latest_version}
    container_name: validator
    restart: unless-stopped
    ports:
      - 30333:30333
      - 9933:9933
      - 9944:9944
      - 9615:9615
    volumes:
      - /srv/${chain}/:/polkadot/.local/share/polkadot
    command: --validator --chain ${chain} --rpc-methods=Unsafe %{ if enable_polkashots ~} --database=RocksDb --unsafe-pruning --pruning=1000 %{ endif ~} --public-addr=/ip4/$${IP}/tcp/80 ${additional_common_flags}
    networks:
      - default

  nginx:
    container_name: nginx
    image: nginx:1.19-alpine
    ports:
      - 80:80
      - 9100:9100
    volumes:
      - /srv/nginx.conf:/etc/nginx/nginx.conf
    networks:
      - default

networks:
  default:
EOF
