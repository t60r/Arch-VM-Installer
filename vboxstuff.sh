#!/bin/sh
# Date: 4/26/14
# Author: merkinmaker
# Purpose: Vbox Modules for Much VM
#
# Depends: Arch Linux Live ISO, prechroot.sh, postchroot.sh
#
# **This entire project is a WIP
#####################################

red=$(tput setaf 1)
white=$(tput setaf 7)
green=$(tput setaf 2)
yellow=$(tput setaf 3)

packages() {
	printf " \033[1m ${red} Downloading and setting up vbox utils and modules. \n \033[0m "
	sleep 3
	pacman -S virtualbox-guest-utils virtualbox-guest-dkms virtualbox-guest-modules --noconfirm	
}
vboxthings() {
	systemctl enable dkms.service
	systemctl start dkms.service
	modprobe -a vboxguest vboxsf vboxvideo
}

main () {
	packages
	vboxthings
}

main ${*}

#END
