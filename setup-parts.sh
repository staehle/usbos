#!/bin/bash
# Install Ubuntu on USB drive, with full disk encryption (including /boot) and UEFI
#
# References:
# https://help.ubuntu.com/community/Full_Disk_Encryption_Howto_2019
# https://askubuntu.com/questions/1086309/how-to-make-bios-uefi-flash-drive-with-full-disk-encryption
# https://help.ubuntu.com/community/ManualFullSystemEncryption
#
set -e

# Steps:
# new_parts=1
# new_luks=1
# new_fs=1

if [[ -z "$DEV" || -z "$DM" ]]; then
	echo "Run the other script to get DEV/DM set"
	exit 1
fi

echo "Device: ${DEV}"
echo "    DM: ${DM}"

if [ ! -z "$new_parts" ]; then
	echo
	echo "*** Setting up partitions"
	sgdisk --print $DEV

	sgdisk --zap-all $DEV
	sgdisk --new=1:0:+577M $DEV
	sgdisk --new=2:0:+577M $DEV
	sgdisk --new=5:0:0 $DEV
	#sgdisk --typecode=1:8301 --typecode=2:ef02 --typecode=3:ef00 --typecode=5:8301 $DEV
	#sgdisk --change-name=1:/boot --change-name=2:GRUB --change-name=3:ESP --change-name=5:rootfs $DEV
	sgdisk --typecode=1:ef00 --typecode=1:8301 --typecode=5:8301 $DEV
	sgdisk --change-name=1:ESP --change-name=2:LVMLUKS $DEV
	#sgdisk --hybrid 1:2:3 $DEV
fi

echo
echo "*** Our current partitions:"
sgdisk --print $DEV

if [ ! -z "$new_luks" ]; then
	echo
	echo "*** Creating LUKS parts"
	#cryptsetup luksFormat --type=luks1 ${DEV}1
	#cryptsetup luksFormat ${DEV}5
	cryptsetup luksFormat ${DEV}2
fi

echo
echo "*** Unlocking LUKS"
echo
#echo "    > /boot"
#cryptsetup open ${DEV}1 LUKS_BOOT
echo
echo "    > /"
#cryptsetup open ${DEV}5 ${DM}5_crypt
cryptsetup open ${DEV}2 ${DM}2_crypt

echo
echo "*** Current mappers:"
ls /dev/mapper/

if [ ! -z "$new_fs" ]; then
	echo
	echo "*** Creating new filesystems"
	#echo "    > /boot"
	#mkfs.ext4 -L boot /dev/mapper/LUKS_BOOT

	echo
	echo "    > EFI"
	mkfs.vfat -F 16 -n ESP ${DEV}3

	echo
	echo "    > LVM"
	pvcreate /dev/mapper/${DM}_crypt
	vgcreate ubuntu-vg /dev/mapper/${DM}_crypt

	echo "    > swap on LVM"
	lvcreate -L 4G -n swap_1 ubuntu-vg

	echo "    > / on LVM"
	lvcreate -l 80%FREE -n root ubuntu-vg
fi

echo "Done :)"

