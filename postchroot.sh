#!/bin/sh
# Date: 4/26/14
# Author: merkinmaker
# Purpose: Post Chroot Steps for Arch VM Installation
# 
# Depends: Arch Linux Live ISO
#
# **This entire project is a WIP
#####################################


red=$(tput setaf 1)
white=$(tput setaf 7)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
setfont Lat2-Terminus16 

environ() {
	echo en_US.UTF-8 UTF-8 > /etc/locale.gen
	locale-gen
	export LANG=en_US.UTF-8
	echo FONT=Lat2-Terminus16 > /etc/vconsole.conf
}

timezone() {
	ln -s /usr/share/zoneinfo/America/Chicago /etc/localtime
	hwclock --systohc --utc
}

hostname() {
	printf "Pick a hostname:\n"
	read i
	echo "$i" > /etc/hostname
	printf " \033[1m \n ${yellow} Enter your hostname after '127.0.0.1...localhost' in /etc/hosts ${white}\033[0m "
	nano /etc/hosts
}

networking() {
	systemctl enable dhcpcd.service
}

rootpass() {
	printf " \033[1m ${red}###########################${white} \n \033[0m"
	printf " \033[1m ${red}# Enter the Root password #${white} \n \033[0m"
	printf " \033[1m ${red}###########################${white} \n \033[0m"
	sleep 1
	passwd
}

packages() {
	pacman -S syslinux vim xterm xorg-xinit xorg-server xorg-server-utils i3 zsh wget --noconfirm
}

syslinux() {
	syslinux-install_update -i -a -m
	printf " \033[1m ${red} Edit APPEND root=/dev/sda3 to point to your / partition. ${white} \n \033[0m"
	printf "\033[1m ${green} Press Enter to Continue\033[0m"
	read Enter
	vim /boot/syslinux/syslinux.cfg
}

umountreboot() {
	printf " \033[1m ${red}  ###########################${white} \n \033[0m"
	printf " \033[1m ${red}# Base install complete   #${white} \n \033[0m"
	printf " \033[1m ${red}#${green} Enter the commands:     ${red}#${white}\n \033[0m"
	printf " \033[1m ${red}#${white} exit                    ${red}#${white}\n \033[0m"
	printf " \033[1m ${red}#${white} umrount -R /mnt         ${red}#${white}\n \033[0m"
	printf " \033[1m ${red}#${white} reboot                  ${red}#${white}\n \033[0m"
	printf " \033[1m ${red}###########################${white} \n \033[0m"
}
main() {
	environ			# sets the locale again as the environment has changed
	timezone		# very very default, also sets the hwclock
	hostname		# grabs a hostname, thanks i3-Arch!
	networking		# enables dhcpcd.service for much VM
	rootpass
	packages
	syslinux
	umountreboot
}

main ${*}
