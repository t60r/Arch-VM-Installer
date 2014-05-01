#!/bin/sh
#	Date: 4/26/14
#	Author: t60r
#	Purpose: Basic steps for setting up an 
#		Arch linux VM on VirtualBox
#	Depends: Arch Linux Live ISO
#	
#	**This entire project is a WIP
#####################################


red=$(tput setaf 1)
white=$(tput setaf 7)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
setfont Lat2-Terminus16	

update() {
	pacman -Syyu --noconfirm
}

locale() {
	echo en_US.UTF-8 UTF-8 > /etc/locale.gen
	locale-gen
	export LANG=en_US.UTF-8
	echo LANG=en_US.UTF-8 > /etc/locale.conf
}

pingnet() {
	ping -c 3 8.8.8.8
	sleep 1
}

partition() {
	clear
	printf "\033[1m ${red} Make Two Partitions \n\033[0m"
	printf "\033[1m ${yellow} /dev/sda1 = / \n\033[0m"
	printf "\033[1m ${yellow} /dev/sda2 = /home \n\033[0m"
	printf "\033[1m ${green} Press Enter to Continue \n\033[0m"
	read Enter
	fdisk /dev/sda
}

formatdrives() {
	clear
	mkfs.ext4 /dev/sda1
	mkfs.ext4 /dev/sda2
} 

mountparts() {
	clear
	mount /dev/sda1 /mnt
	mkdir /mnt/home
	mount /dev/sda2 /mnt/home
}

confirmMount() {
	clear
	printf " \033[1m ${red} HEY!${green} You!!!${white} confirm everything is mounted correctly!\n \033[0m "
	lsblk -f
	printf "\033[1m ${green} Press Enter to Continue \n\033[0m"
	read Enter
}

mirrors(){
	clear
	printf " \033[1m ${green} Pick your mirrors! ${white}\n \033[0m "
	printf " \033[1m ${red} Bring your favorites to the top! ;) ${white}\n \033[0m "
	printf " \033[1m ${yellow} Hint: alt+6 = copy ${white}\n \033[0m "
	printf " \033[1m ${yellow} and ctrl+U = paste. ${white}\n \033[0m "
	printf "\033[1m ${green} Press Enter to Continue \n\033[0m"
	read Enter
	nano /etc/pacman.d/mirrorlist
}

installbase() {
	pacstrap -i /mnt base base-devel --noconfirm
}

fstabulation(){
	genfstab -L -p /mnt >> /mnt/etc/fstab
	printf " \033[1m ${red} HEY!${green} LOOK!\n${white} Make sure this looks correct!\n \033[0m "
	cat /mnt/etc/fstab
	sleep 7
}

nextsteps() {
	wget https://raw.githubusercontent.com/t60r/Arch-VM-Installer/master/postchroot.sh
	cp postroot.sh /mnt
	printf " \033[1m ${green}You will now be placed${white}\n \033[0m "
	printf " \033[1m ${red}into a chroot environment${white}\n \033[0m "
	printf " \033[1m ${yellow}You will be prompted for${white}\n \033[0m "
	printf " \033[1m ${yellow}a few things along the way${white}\n \033[0m "
	printf " \033[1m ${green} Press Enter to Continue \n\033[0m"
	read Enter
	arch-chroot /mnt /bin/bash postchroot.sh
}

main() {
	update			# updates system in case of stale ISO
	locale			# sets locale unnecessarily for fun
	pingnet			# pings the interwebs
	partition		# tells you what to do and opens up fdisk
	formatdrives	# formats fdisk
	mountparts		# mounts your partitions
	confirmMount	# shows you exactly what you just mounted
	mirrors			# echos a few US mirrors into the mirrorlist
	installbase		# installs base and base-devel package groups
	fstabulation	# generates fstab and shows the user the file
	nextsteps		# informs the user what to do next
}

main ${*}
