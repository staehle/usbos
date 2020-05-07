#!/bin/bash
_usbos_path=$(realpath $(dirname "${BASH_SOURCE[0]}"))
CNORMAL="\033[1;0m"
CSTRONG="\033[1;1m"
CRED="\033[1;31m"
CGREEN="\033[1;32m"
CYELLOW="\033[1;33m"
CPURPLE="\033[1;35m"
CCYAN="\033[1;36m"

function _echo_title() {
	echo
	echo -e "$(date +%T)| ${CSTRONG}*** ${CYELLOW}$@${CNORMAL} ***"
}

function _echo_subtitle() {
	echo
	echo -e "$(date +%T)| ${CSTRONG}   > ${CYELLOW}$@${CNORMAL} ***"
}

function _echo_info() {
	echo
	echo -e "$(date +%T)| ${CSTRONG} ~ ${CCYAN}$@${CNORMAL} ~"
}

function _echo_warn() {
	echo
    echo -e "$(date +%T)| ${CSTRONG}${CRED}WARNING:${CNORMAL} ${CYELLOW}$@${CNORMAL}"
}

function _echo_err() {
	echo
    echo -e "$(date +%T)| ${CSTRONG}${CRED}ERROR:${CNORMAL} ${CSTRONG}$@${CNORMAL}"
}

function _echo_confirm() {
	echo
    echo -e "$(date +%T)| ${CSTRONG}>>> ${CGREEN}$@${CNORMAL} <<< <--"
}

