#cloud-config

package_update: true
package_upgrade: true
package_reboot_if_required: true

packages:
  - apt-transport-https
  - ca-certificates
  - curl
  - gnupg2
  - software-properties-common

runcmd:
  - curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
  - add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
  - apt-get update -y
  - apt-get -y install docker-ce docker-ce-cli containerd.io ntp htop tmux p7zip-full
  - systemctl start docker
  - systemctl enable docker
  - curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
  - chmod +x /usr/local/bin/docker-compose
  - ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
  - [ sh, -c, 'echo "deb http://deb.debian.org/debian/ unstable main" | tee /etc/apt/sources.list.d/unstable.list' ]
  - [ sh, -c, '/bin/echo -e "Package: *\nPin: release a=unstable\nPin-Priority: 150\n" | tee /etc/apt/preferences.d/limit-unstable' ]
  - apt update
%{ if additional_volume ~}
  - mkfs -t ext4 /dev/sda && mount /dev/sda /srv
  - echo "/dev/sda /srv ext4 rw,discard,errors=remount-ro 0 1" >> /etc/fstab
%{ endif ~}
%{ if enable_polkashots ~}
  - wget https://${chain.short}-rocksdb.polkashots.io/snapshot -O /srv/${chain.name}.RocksDb.7z
  - cd /srv && 7z x ${chain.name}.RocksDb.7z -o/srv/${chain.name}/chains/ksmcc3
  - rm -rf /srv/${chain.name}.RocksDb.7z
  - chown 1000:1000 /srv/${chain.name} -R
%{ endif ~}
