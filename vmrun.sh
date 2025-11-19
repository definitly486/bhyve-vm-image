#!/usr/local/bin/bash
name=$1
dir=$(dirname "$(realpath $0)")


# Список дистрибутивов и операционных систем
distros=(
    alma
    alpine
    altlinux
    android-blissos
    antix19
    arch
    besgnulinux
    bodhi
    bunsen
    cbpp
    debian12
    devuan
    dockerbox
    elementaryos
    exegnu
    fedora
    lite
    lubuntu14.04
    lubuntu18.04
    manjaro
    mx
    openbsd7.7
    opensuse12
    opensuse13
    opensuse15
    openwrt
    puppy
    ravynOS
    sparky
    ubuntu-mate14.04
    ubuntu-mate14.10
    ubuntu-waydroid
    ubuntu12.04
    ubuntu12.10
    ubuntu14.04
    ubuntu16.04
    ubuntu18.04
    ubuntu25.10
    void
    win10
    win11
    win7
    win8
)







PCI_INTEL="pci0:0:2:0"
PCI_NVIDIA="pci0:1:0:0"

PCI_GPU=$PCI_NVIDIA

if ! pciconf -l $PCI_GPU | grep -q "ppt"; then
echo "$PCI_GPU is not attached to ppt,attaching..."
doas devctl detach $PCI_GPU > /dev/null 2>&1
doas devctl clear driver -f $PCI_GPU ppt > /dev/null 2>&1
doas devctl set driver -f $PCI_GPU ppt > /dev/null 2>&1
else
echo "$PCI_GPU already attached to ppt"
fi


if [ -z "$1" ]
then
     echo "введите название машины"
     echo "список доступных систем"
 for distro in "${distros[@]}"; do
    echo "$distro"
 done
     exit
fi

if [ -z "$2" ]
then
     echo "запуск без CD"
     CD=
else
     CD="-s 2,ahci-cd,/ntfs-2TB/vm/ISO/$2"
    echo $CD
fi

# pciconf -lv
#BHYVE=/home/definitly/2TB/obj/ntfs-2TB/src/amd64.amd64/usr.sbin/bhyve/bhyve
BHYVE=bhyve
HD=$dir/$1/$1.img
#GPU_INTEL="-s 7,passthru,$PCI_INTEL"
#GPU_NVIDIA="-s 2,passthru,$PCI_NVIDIA"
#UEFI=/usr/local/share/uefi-firmware/BHYVE_UEFI.fd
#USB="-s 30,xhci,passthru.0x0c45.0x7603,passthru.0x18f8.0x0f97"
UEFI=$dir/BHYVE_BHF_UEFI.fd
#UEFI=$dir/BHYVE.fd
VNC="-s 5,fbuf,tcp=0.0.0.0:5900,$DPY" 
#-l bootrom,$UEFI \
#-l bootrom,$UEFI,fwcfg=qemu \
MEM=4G
VM=$name
IF="tap0"
MAC="mac=00:A0:98:78:32:10"
DPY="w=1918,h=1058"
#-s 2,ahci-cd,$CD \
#truncate -s 15GB altlinux.img
doas  ifconfig $IF up

run_vm () {

while true
do
    doas  $BHYVE  \
      -c 1 \
      -s 0,hostbridge \
      -s 3,ahci-hd,$HD,sectorsize=512,bootindex=1 \
      $CD  \
      $GPU_INTEL \
	$GPU_NVIDIA \
     -s 10,virtio-net,$IF \
     -s 15,virtio-9p,sharename=/home/ \
     $VNC \
     $USB  \
      -s 31,lpc \
      -l bootrom,$UEFI,fwcfg=qemu \
      -m $MEM  -H -w -P -S \
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

}

run_vm