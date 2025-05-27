doas bhyvectl --destroy --vm=opensuse12
doas /usr/local/sbin/grub-bhyve -r hd0 -m device.map -M 1024 opensuse12  < grub.cfg
doas bhyve -AI -H -P -s 0:0,hostbridge -s 1:0,lpc -s 10:0,virtio-net,tap0 -s 3:0,ahci-hd,/home/definitly/2TB/vm/opensuse12/opensuse12.img -s 4:0,ahci-cd,/home/definitly/downloads/ISO/openSUSE-12.1-DVD-x86_64.iso  -c 4 -m 1024M opensuse12
#doas bhyve -AI -H -P -s 0:0,hostbridge -s 1:0,lpc -s 10:0,virtio-net,tap0 -s 3:0,ahci-hd,/home/definitly/2TB/vm/opensuse12/opensuse12.img  -l com1,stdio -c 4 -m 1024M opensuse12