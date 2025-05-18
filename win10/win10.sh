#!/bin/sh
CD=/home/definitly/Downloads/virtio-win-0.1.140.iso
#CD=/home/definitly/downloads/Windows_10_Pro_22H2.iso
HD=/bhyve/win10/win10.img
HD2=/home/dwm/windows10.img
USB="5/0/0"
#UEFI=/home/dwm/BHYVE_BHF_UEFI.fd
#UEFI=/home/dwm/BHYVE_CODE.fd
#-s 2,ahci-cd,$CD \
UEFI=/usr/local/share/uefi-firmware/BHYVE_UEFI.fd 
MEM=6G
VM="win10"
IF="tap0"
MAC="mac=00:A0:98:78:32:10"
DPY="w=1920,h=1080"
#truncate -s 15GB windows2016.img

# Execution of virtual machines requires root previleges
if test "$(id -u)" -ne 0; then
	printf "%s must be run as root\n" "${0##*/}"
	exit 1
fi



detach() {
echo stop

 devctl detach  -f pci0:0:20:0
 devctl set driver   pci0:0:20:0 xhci
 devctl attach pci0:0:20:0
 
echo stop 2
}


attach() {
echo start
 devctl detach pci0:0:20:0
 devctl set driver pci0:0:20:0 ppt
  devctl attach pci0:0:20:0

}




  ifconfig $IF up
while true
do
echo start 2
      bhyve \
      -c 4,sockets=2,cores=2 -S -A  \
      -s 0,hostbridge \
     -s 3,ahci-hd,$HD,sectorsize=512 \
      -s 5,fbuf,tcp=0.0.0.0:5900,$DPY \
-s 2,ahci-cd,$CD \
-s 30,xhci,tablet \
-s 10,virtio-net,$IF \
-s 31,lpc \
      -s 20,hda,play=/dev/dsp,rec=/dev/dsp \
      -l bootrom,$UEFI,fwcfg=qemu  \
      -m $MEM -H -w \
      $VM

    RES=$?
      bhyvectl --destroy --vm=$VM
    if [ $RES -eq 1 ]
    then


        break
    fi
    echo sleeping for 5 sec...
    sleep 5
done
