#cloud-config
autoinstall:
  apt:
    geoip: true
    preserve_sources_list: false
    primary:
    - arches: [amd64, i386]
      uri: http://mirrors.aliyun.com/ubuntu
    - arches: [default]
      uri: http://ports.ubuntu.com/ubuntu-ports
  identity: {hostname: king, password: $6$TtU/NoGjGoYuES5X$3.u15RJ4OzRcK05HeOZJD.ntFJZHpmNJfCf0138rJahLxYAugmj2B4YlIl4KqLAuacbOzD3QnzQmr1hYmlasF.,
    realname: king, username: king}
  keyboard: {layout: us, toggle: null, variant: ''}
  locale: en_US
  network:
    ethernets: {}
    version: 2
  ssh:
    allow-pw: true
    authorized-keys: []
    install-server: true
  storage:    config:
    - {ptable: gpt,path: /dev/sdb, wipe: superblock-recursive, preserve: false, name: '', grub_device: false,
      type: disk, id: disk-sdb}
    - {device: disk-sdb, size: 536870912, wipe: superblock, flag: boot, number: 1,
      preserve: false, grub_device: true, type: partition, id: partition-2}
    - {fstype: fat32, volume: partition-2, preserve: false, type: format, id: format-2}
    - {device: disk-sdb, size: 524288000, wipe: superblock, flag: '', number: 2, preserve: false,
      type: partition, id: partition-3}
    - {fstype: ext4, volume: partition-3, preserve: false, type: format, id: format-4}
    - {device: disk-sdb, size: 479039848448, wipe: superblock, flag: '', number: 3,
      preserve: false, type: partition, id: partition-4}
    - {fstype: ext4, volume: partition-4, preserve: false, type: format, id: format-5}
    - {device: format-5, path: /, type: mount, id: mount-5}
    - {device: format-4, path: /boot, type: mount, id: mount-4}
    - {device: format-2, path: /boot/efi, type: mount, id: mount-2}
