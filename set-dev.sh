#!/bin/bash
arg1="first arg must be usb install device (e.g. /dev/sdb)"

if [ -z "$1" ]; then
	echo "usage: $arg1"
	echo "error: missing"
	exit 1
elif [ ! -e $1 ]; then
	echo "usage: $arg1"
	echo "error: does not exist"
	exit 1
fi

if [ $(id -u) -ne 0 ]; then
	echo "error: run this script as root!"
	exit 1
fi

export DEV="$1"
export DM="${DEV##*/}"

echo "Device: ${DEV}"
echo "    DM: ${DM}"

