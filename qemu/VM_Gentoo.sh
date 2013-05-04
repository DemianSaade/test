#!/bin/sh
# TODO
#  networking 
/usr/bin/qemu-kvm	-monitor stdio \
                        -name "Gentoo.box" \
                        -boot once=c,menu=on \
                        -enable-kvm \
                        -no-fd-bootchk \
                        -no-acpi \
                        -cpu SandyBridge \
                        -smp 2 \
                        -m 512 \
                        -k es \
                        -vga std \
                        -hda /home/demian/GentooBox.qcow2 \
                        
                        #-net nic,vlan=0,macaddr=00:00:00:00:00:01,model=rtl8139 \
                        #-net tap,vlan=0,ifname=tap0,script=no \
                        #-net nic,vlan=0,macaddr=00:00:00:00:00:02,model=rtl8139 \
                        #-net tap,vlan=0,ifname=tap1,script=no
