#!/bin/sh
dir=$(dirname "$(realpath $0)")
CD=/home/definitly/Downloads/ubuntu-16.04.7-server-amd64.iso
HD=$dir/ubuntu16.04.img
USB="5/0/0"
#UEFI=/usr/local/share/uefi-firmware/BHYVE_UEFI.fd
UEFI=$dir/BHYVE_BHF_UEFI.fd
MEM=1G
VM="ubuntu"
IF="tap0"
MAC="mac=00:A0:98:78:32:10"
DPY="w=1918,h=1058"
#-s 2,ahci-cd,$CD \
doas  ifconfig $IF up
while true
do
    doas  bhyve \
      -c 1 \
      -s 0,hostbridge \
      -s 3,ahci-hd,$HD,sectorsize=512 \
-s 5,fbuf,tcp=0.0.0.0:5900,$DPY \
      -s 6,xhci,tablet \
      -s 10,virtio-net,$IF \
      -s 20,hda,play=/dev/dsp,rec=/dev/dsp \
      -s 31,lpc \
      -l bootrom,$UEFI \
      -m $MEM -H -w -A \
      $VM

    RES=$?
    doas  bhyvectl --destroy --vm=$VM
    if [ $RES -eq 1 ]
    then
        exit 1
    fi
    echo sleeping for 5 sec...
    sleep 5
done