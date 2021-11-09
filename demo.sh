#!/usr/bin/env bash

readonly BASH_LIB_NAME=DEMO
source ./bash-lib.sh

# Set `DEMO_DEBUG=1` to enable debug messages
# Set `DEMO_DEBUG=2` to enable trace messages

trace "this is a trace message" "with additional data"
debug "this is a debugging message" "with additional data"
info "this is an informational message" "with additional data"
warn "this is a warning message" "with additional data"
error "this is an error message" "with additional data"

# Like echo, but to stderr
echoe '------------------------------'

if is_debug; then
	info "Debugging messages:" on
else
	info "Debugging messages:" off
fi

if is_trace; then
	info "Trace messages:" on
else
	info "Trace messages:" off
fi

echoe '------------------------------'

# Use critical with `set +e` if you want to trap errors
(
	function handle_error() {
		info "handling error..."
	}

	set +e
	trap "handle_error" ERR

	critical "this is a critical error:" "this will allow some error recovery"
	info "but with 'set +e', the program continues its course"
)

echoe '------------------------------'

info "use 'fatal()' in either case if you want to quit with an error message"
fatal "some unrecoverable error occurred, exiting"
