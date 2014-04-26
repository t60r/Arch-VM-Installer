#!/bin/sh
#	Date: 4/26/14
#	Author: merkinmaker
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

setfont() {
	printf " \033[1m ${yellow}Setting Font to Lat2-Terminus16${white}\033[0m"
	setfont Lat2-Terminus16	
	printf " \033[1m ${yellow}Dat Unicode Coverage!${white}\033[0m"
	sleep 2
}

locale() {
	echo en_US.UTF-8 UTF-8 > /etc/locale.gen
	locale-gen
	export LANG=en_US.UTF-8 UTF-8
}

pingnet() {
	ping -c 3 8.8.8.8
}

partition() {
	fdisk /dev/sda
}

formatdrives() {
	mkfs.ext4 /dev/sda1
	mkfs.ext4 /dev/sda2
} 

mountparts() { 
	mount /dev/sda1 /mnt
	mkdir /mnt/home
	mount /dev/sda2 /mnt/home
}

confirmMount() {
	printf " \033[1m ${red} HEY!${green}/dev/sda${white} confirm everything is mounted correctly!\n \033[0m "
	lsblk -f
	sleep 5
}

mirrors(){
	echo "Server = http://lug.mtu.edu/archlinux/$repo/os/$arch" > /etc/pacman.d/mirrorlist
	echo "Server = http://mirror.rit.edu/archlinux/$repo/os/$arch" >> /etc/pacman.d/mirrorlist
	echo "Server = http://mirror.us.leaseweb.net/archlinux/$repo/os/$arch" >> /etc/pacman.d/mirrorlist
	echo "Server = http://mirror.rit.edu/archlinux/$repo/os/$arch" >> /etc/pacman.d/mirrorlist
}

installbase() {
	pacstrap -i /mnt base base-devel
}

fstabulation(){
	genfstab -U -p /mnt >> /mnt/etc/fstab
	printf " \033[1m ${red} HEY!${green} LOOK!\n${white} Make sure this looks correct!\n \033[0m "
	cat /mnt/etc/fstab
	sleep 7
}

nextsteps() {
	printf " \033[1m ${red} HEY!${green}Type 'arch chroot /mnt /bin/bash to complete installation${white}\n \033[0m "
}

main() {
	setfont			# sets font to Lat2-Terminus16 for excellent unicode coverage
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

main
