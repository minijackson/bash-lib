#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

shopt -s nullglob

tput() {
	# If tput fails, it just means less colors
	command tput "$@" 2> /dev/null || true
}

NORMAL="$(tput sgr0)"
# shellcheck disable=SC2034
readonly NORMAL
BOLD="$(tput bold)"
# shellcheck disable=SC2034
readonly BOLD

RED="$(tput setaf 1)"
# shellcheck disable=SC2034
readonly RED
GREEN="$(tput setaf 2)"
# shellcheck disable=SC2034
readonly GREEN
YELLOW="$(tput setaf 3)"
# shellcheck disable=SC2034
readonly YELLOW
BLUE="$(tput setaf 4)"
# shellcheck disable=SC2034
readonly BLUE
PURPLE="$(tput setaf 5)"
# shellcheck disable=SC2034
readonly PURPLE
CYAN="$(tput setaf 6)"
# shellcheck disable=SC2034
readonly CYAN
WHITE="$(tput setaf 7)"
# shellcheck disable=SC2034
readonly WHITE

readonly BASH_LIB_LOG_VAR="${BASH_LIB_NAME:-BASH}_LOG"

is_debug() {
	[ "${!BASH_LIB_LOG_VAR:-0}" -ge 1 ]
}

is_trace() {
	[ "${!BASH_LIB_LOG_VAR:-0}" -ge 2 ]
}

declare -a VERBOSE_ARG
if is_debug; then
	VERBOSE_ARG=("--verbose")
else
	VERBOSE_ARG=()
fi
# shellcheck disable=SC2034
readonly VERBOSE_ARG

echoe() {
	IFS=" " echo "$@" >&2
}

log() {
	local level="$1"
	local color="$2"
	local message="$3"
	shift 3
	local -a rest=("$@")

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
	return 1
}

fatal() {
	error "$@"
	exit 1
}
