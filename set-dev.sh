#!/bin/bash

function set-inst-dev() {
	local arg1="first arg must be usb install device (e.g. /dev/sdb)"
	if [ -z "$1" ]; then
		echo "usage: $arg1"
		echo "error: missing"
		return
	elif [ ! -e $1 ]; then
		echo "usage: $arg1"
		echo "error: does not exist"
		return
	fi
	if [ $(id -u) -ne 0 ]; then
		echo "error: run this script as root!"
		return
	fi

	export DEV="$1"
	export DM="${DEV##*/}"

	echo "Device: ${DEV}"
	echo "    DM: ${DM}"
}

