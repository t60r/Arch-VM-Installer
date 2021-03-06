#!/bin/sh
# Date: 4/26/14
# Author: t60r
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

packages() 
{
	printf " \033[1m ${red} Downloading and setting up vbox utils and modules. \n \033[0m "
	sleep 3
	pacman -S virtualbox-guest-utils virtualbox-guest-dkms virtualbox-guest-modules --noconfirm	
	sleep 5
}

vboxthings() 
{
	systemctl enable dkms.service
	systemctl start dkms.service
	sleep 3
	modprobe -a vboxguest vboxsf vboxvideo
}

networking() 
{
	printf " \033[1m ${red} Enabling dhcpcd.service ${white} \n \033[0m"
	systemctl enable dhcpcd.service
	printf " \033[1m ${green} Done ${white} \n \033[0m"
}

main () 
{
	packages
	vboxthings
	networking
}

main ${*}

#END
