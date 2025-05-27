#!/bin/sh
dir=$(dirname "$(realpath $0)")
doas bhyvectl --destroy --vm=opensuse12
doas /usr/local/sbin/grub-bhyve -r cd0 -m device.map -M 1024 opensuse12  < grub_install.cfg
doas bhyve -A -H -P -s 0:0,hostbridge -s 1:0,lpc -s 10:0,virtio-net,tap0 -s 3:0,ahci-hd,$dir/opensuse12.img -s 4:0,ahci-cd,/home/definitly/downloads/ISO/openSUSE-12.1-DVD-x86_64.iso -l com1,stdio -c 4 -m 1024M opensuse12
