#!/bin/bash
source $(realpath $(dirname "${BASH_SOURCE[0]}"))/defines.sh
function set-inst-dev() {
	local arg1="first arg must be usb install device (e.g. /dev/sdb)"
	if [ -z "$1" ]; then
		_echo_info "usage: $arg1"
		_echo_err "missing arg"
		return
	elif [ ! -e $1 ]; then
		_echo_info "usage: $arg1"
		_echo_err "does not exist!"
		return
	fi
	if [ $(id -u) -ne 0 ]; then
		_echo_err "you missed the 'sudo -i' step in the README.md!"
		return
	fi
	export DEV="$1"
	export DM="${DEV##*/}"

	_echo_title "Your selected device:"
	echo "Device: ${DEV}"
	echo "    DM: ${DM}"

	_echo_info "Please confirm this is the correct device:"

	fdisk -l ${DEV}

	_echo_warn "THIS DEVICE WILL BE COMPLETELY OVERWRITTEN!"

	_echo_confirm "If this is correct, continue with the next steps. If not, run this function again with the correct drive next time :)"
}


#[[ "$1" == "_test" ]] && shift && set-inst-dev $@
