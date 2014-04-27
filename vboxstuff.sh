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
	pacman -S virtualbox-guest-utils virtualbox-guest-dkms virtualbox-guest-modules --noconfirm
	systemctl enable dkms.service
	systemctl start dkms.service
	modprobe -a vboxguest vboxsf vboxvideo
}

main () {
	vboxthings
}

main

#END
