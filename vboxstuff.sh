#!/bin/sh
# Date: 4/26/14
# Author: merkinmaker
# Purpose: Vbox Modules for Much VM
#
# Depends: Arch Linux Live ISO, prechroot.sh, postchroot.sh
#
# **This entire project is a WIP
#####################################

vboxthings() {
	pacman -S virtualbox-guest-utils virtualbox-guest-dkms --noconfirm
	modprobe vboxguest vboxsf vboxvideo
	systemctl enable dkms.service
}

main () {
 vboxthings
}

main

#END
