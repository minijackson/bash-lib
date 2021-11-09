#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

shopt -s nullglob

tput() {
	# If tput fails, it just means less colors
	command tput "$@" 2> /dev/null || true
}

NORMAL="$(tput sgr0)"
readonly NORMAL
BOLD="$(tput bold)"
readonly BOLD

RED="$(tput setaf 1)"
readonly RED
GREEN="$(tput setaf 2)"
readonly GREEN
YELLOW="$(tput setaf 3)"
readonly YELLOW
BLUE="$(tput setaf 4)"
readonly BLUE
PURPLE="$(tput setaf 5)"
readonly PURPLE
CYAN="$(tput setaf 6)"
readonly CYAN
WHITE="$(tput setaf 7)"
readonly WHITE

readonly BASH_LIB_DEBUG_VAR="${BASH_LIB_NAME:-BASH}_DEBUG"

is_debug() {
	[ "${!BASH_LIB_DEBUG_VAR:-0}" -ge 1 ]
}

is_trace() {
	[ "${!BASH_LIB_DEBUG_VAR:-0}" -ge 2 ]
}

declare -a VERBOSE_ARG
if is_debug; then
	VERBOSE_ARG=("--verbose")
else
	VERBOSE_ARG=()
fi
readonly VERBOSE_ARG

echoe() {
	IFS=" " echo "$@" >&2
}

log() {
	local level="$1"
	local color="$2"
	local message="$3"
	shift 3
	local rest="$@"

	echoe "${BOLD}${color}${level} ${WHITE}${message}${NORMAL}" "${rest[@]}"
}

trace() {
	if is_trace; then
		log "Trace:  " "${PURPLE}" "$@"
	fi
}

debug() {
	if is_debug; then
		log "Debug:  " "${GREEN}" "$@"
	fi
}

info() {
	log "Info:   " "${CYAN}" "$@"
}

warn() {
	log "Warning:" "${YELLOW}" "$@"
}

error() {
	log "Error:  " "${RED}" "$@"
}

critical() {
	error "$@"
	# Useful for triggering the error trap system
	false
}

fatal() {
	error "$@"
	exit 1
}
