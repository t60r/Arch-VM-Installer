#!/bin/sh
# Date: 4/26/14
# Author: t60r
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

DOVISUDO="no" # for checkifvisudo()

setfont Lat2-Terminus16 #utf coverage

environ() #fisrt steps: Environment, locale, /etc
{
	echo en_US.UTF-8 UTF-8 > /etc/locale.gen
	locale-gen
	export LANG=en_US.UTF-8
	echo FONT=Lat2-Terminus16 > /etc/vconsole.conf
}

timezone() #locked in at the moment
{
	ln -s /usr/share/zoneinfo/America/Chicago /etc/localtime
	hwclock --systohc --utc
}

thehostname() #adds a hostname of your choice, add it at the end of the first 127.0.0.1 line
{
	printf "Pick a hostname:\n"
	read i
	echo "$i" > /etc/hostname
	printf " \033[1m \n ${yellow} Enter your hostname after '127.0.0.1...localhost' in /etc/hosts ${white}\033[0m "
	printf "\033[1m ${green} Press Enter to Continue \n\033[0m"
	read Enter
	nano /etc/hosts
}


rootpass() #sets the root pass
{
	printf " \033[1m ${red}###########################${white} \n \033[0m"
	printf " \033[1m ${red}# Enter the Root password #${white} \n \033[0m"
	printf " \033[1m ${red}###########################${white} \n \033[0m"
	printf "\033[1m ${green} Press Enter to Continue \n\033[0m"
	read Enter
	sleep 1
	passwd
}

packages() #grabs a few essentials, needs work.
{
	pacman -S syslinux vim xterm xorg-xinit xorg-server xorg-server-utils zsh wget --noconfirm
}

syslinux() # %s/3/1/g...pretty much
{
	syslinux-install_update -i -a -m
	printf " \033[1m ${red} Edit APPEND root=/dev/sda3 to point to your / partition. ${white} \n \033[0m"
	printf "\033[1m ${green} Press Enter to Continue \n\033[0m"
	read Enter
	vim /boot/syslinux/syslinux.cfg
}

addauser () # option to add a user
{
	printf "\033[1m ${yellow}Would you like to add a user? yes/no\n\033[0m"
	read yesno
	
 	# all to lower case
	yesno=$(echo $yesno | awk '{print tolower($0)}')
	
 	# check and act on given answer
 	case $yesno in
  		"yes")  addtheuser ;;
		"no")  umountreboot ;;
   		*)      echo "Please answer yes or no" ; addauser ;;
 	esac

}

addtheuser () 
{
		printf "\033[1m ${green}Enter the username: \n \033[0m"
		read $THEUSERNAME
		useradd -m -g users -G wheel -s /bin/bash $THEUSERNAME
		printf " \033[1m ${red}###########################${white} \n \033[0m"
		printf " \033[1m ${red}# Enter the Root password #${white} \n \033[0m"
		printf " \033[1m ${red}###########################${white} \n \033[0m"
		printf "\033[1m ${green} Press Enter to Continue \n\033[0m"
		read Enter
		sleep 1
		passwd $THEUSERNAME
}

checkifvisudo()
{
	case $DOVISUDO in
	  	"yes")  sudoers ;;
		"no")  	printf "\033[1m ${green} You did not add a user. :3 \n\033[0m"r ;;
   		*)      echo "All your base, are beong to us." ; sudoers ;;
	esac
}

sudoers () #visudo is the only recommended way to add a user to the sudoers group.  Sudo?  You do it.
{
	printf "\033[1m ${red}Do you want to add this user to the sudoers? yes/no\n\033[0m"
	read yesno
	yesno=$(echo $yesno | awk '{print tolower($0)}')
 	case $yesno in
  		"yes")  suyoudoit ;;
		"no")  umountreboot ;;
   		*)      echo "Please answer yes or no." ; sudoers ;;
 	esac	
}

suyoudoit () 
{
	visudo	#yep
}
umountreboot() #we're pretty much done here. Just read and type...
{
	printf " \033[1m ${red}###########################${white}\n \033[0m"
	printf " \033[1m ${red}# Base install complete   #${white}\n \033[0m"
	printf " \033[1m ${red}#${green} Enter the commands:     ${red}#${white}\n \033[0m"
	printf " \033[1m ${red}#${white} exit                    ${red}#${white}\n \033[0m"
	printf " \033[1m ${red}#${white} umount -R /mnt          ${red}#${white}\n \033[0m"
	printf " \033[1m ${red}#${white} reboot                  ${red}#${white}\n \033[0m"
	printf " \033[1m ${red}###########################${white}\n \033[0m"
}

main() 
{
	environ			# sets the locale again as the environment has changed
	timezone		# very very default, also sets the hwclock
	thehostname		# grabs a hostname, thanks i3-Arch!
	networking		# enables dhcpcd.service for much VM
	rootpass		# sets root pass
	packages		# basic packages
	syslinux		# a bootloader
	addauser		# add a user?
	checkifvisudo		# add this user to sudoers?
	umountreboot		# instructions to umount, and r'boot.
}

main ${*}
