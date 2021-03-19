#cloud-config

package_update: true
package_upgrade: true
package_reboot_if_required: true

apt:
  sources:
    docker.list:
      source: deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable
      keyid: 9DC858229FC7DD38854AE2D88D81803C0EBFCD88

packages:
  - apt-transport-https
  - software-properties-common
  - p7zip-full
  - ntp
  - docker-ce
  - docker-ce-cli
  - docker-compose

ntp:
  enabled: true

%{ if additional_volume ~}
fs_setup:
  - label: srv
    filesystem: 'ext4'
    device: '/dev/sda'

mounts:
 - [ sda, /srv ]
%{ endif ~}

write_files:
- encoding: b64
  content: ${docker_compose}
  owner: root:root
  path: /root/generate-docker-compose.sh
  permissions: '755'
- encoding: b64
  content: ${nginx_config}
  owner: root:root
  path: /root/nginx.conf
  permissions: '0644'

runcmd:
%{ if enable_polkashots ~}
  - wget https://${chain.short}-rocksdb.polkashots.io/snapshot -O /srv/${chain.name}.RocksDb.7z
  - cd /srv && 7z x ${chain.name}.RocksDb.7z -o/srv/${chain.name}/chains/ksmcc3
  - rm -rf /srv/${chain.name}.RocksDb.7z
%{ else ~}
  - mkdir /srv/${chain.name} 
%{ endif ~}
  - chown 1000:1000 /srv/${chain.name} -R
  - bash /root/generate-docker-compose.sh scaleway && rm -rf /root/generate-docker-compose.sh
  - mv /root/nginx.conf /srv
