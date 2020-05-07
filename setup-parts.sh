#!/bin/bash
# Install Ubuntu on USB drive, with full disk encryption (including /boot) and UEFI
#
# References:
# https://help.ubuntu.com/community/Full_Disk_Encryption_Howto_2019
# https://askubuntu.com/questions/1086309/how-to-make-bios-uefi-flash-drive-with-full-disk-encryption
# https://help.ubuntu.com/community/ManualFullSystemEncryption
#
set -e
source $(realpath $(dirname "${BASH_SOURCE[0]}"))/defines.sh

# Steps:
new_parts=1
new_luks=1
new_fs=1
add_swap=1

if [[ -z "$DEV" || -z "$DM" ]]; then
	echo "Run the other script to get DEV/DM set"
	exit 1
fi
if [ $(id -u) -ne 0 ]; then
	_echo_err "you missed the 'sudo -i' step in the README.md!"
	echo "You should stay in your superuser session the entire time while doing this!"
	return
fi

_echo_title "Setting up device:"
echo "Device: ${DEV}"
echo "    DM: ${DM}"

if [ ! -z "$new_parts" ]; then
	_echo_title "Setting up partitions"
	sgdisk --zap-all $DEV
	partprobe

	# Partition setup:
	# 1: 512M, fat16, ESP
	# 2: 512M, ext4, /boot
	# 5: remaining, LVM+LUKS

	sgdisk --new=1:0:+512M $DEV
	sgdisk --new=2:0:+512M $DEV
	sgdisk --new=5:0:0 $DEV

	sgdisk --typecode=1:ef00 --typecode=2:8301 --typecode=5:8300
	sgdisk --change-name=1:ESP --change-name=1:/boot --change-name=2:LVMLUKS $DEV
fi

_echo_info "Our current partitions:"
sgdisk --print $DEV

if [ ! -z "$new_luks" ]; then
	_echo_title "Creating LUKS parts"
	#cryptsetup luksFormat --type=luks1 ${DEV}2
	cryptsetup luksFormat ${DEV}5
fi

_echo_title "Unlocking LUKS"
#_echo_subtitle "/boot"
#cryptsetup open ${DEV}2 LUKS_BOOT

_echo_subtitle "/"
cryptsetup open ${DEV}5 ${DM}5_crypt

_echo_info "Current mappers:"
ls /dev/mapper/

if [ ! -z "$new_fs" ]; then
	_echo_title "Creating new filesystems"

	_echo_subtitle "ESP"
	mkfs.vfat -F 16 -n ESP ${DEV}1

	_echo_subtitle "/boot"
	#mkfs.ext4 -L boot /dev/mapper/LUKS_BOOT
	mkfs.ext4 -L boot ${DEV}2

	_echo_subtitle "LVM"
	pvcreate /dev/mapper/${DM}5_crypt
	vgcreate ubuntu-vg /dev/mapper/${DM}5_crypt

	if [ ! -z "$add_swap" ]; then
		_echo_subtitle "swap on LVM"
		lvcreate -L 4G -n swap_1 ubuntu-vg
	fi

	_echo_subtitle "/ on LVM"
	lvcreate -l 85%FREE -n root ubuntu-vg
fi

_echo_confirm "Done :)"

