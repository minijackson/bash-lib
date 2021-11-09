# Bash-Lib

A simple bash library for your scripting needs

## Usage

Just `source` it at the start of your script.

It will provide you with some useful logging functions, and make your script
use [Bash's unofficial strict mode][strict-mode].

[strict-mode]: <http://redsymbol.net/articles/unofficial-bash-strict-mode/>

If you want your bash script to continue even in the event of errors, you can
put `set +e` after sourcing bash-lib.

## Logging

Bash-lib provides the usual `trace`, `debug`, `info`, `warn`, and `error`
logging functions. By default, `trace` and `debug` messages are not shown, set
the `BASH_LOG` variable to `1` or `2` to increase the verbosity.

You can also set the `BASH_LIB_NAME` variable to influence the verbosity
variable name. For example, `BASH_LIB_NAME=DEMO` will make bash-lib look for
the `DEMO_LOG` variable for logging verbosity.

The `fatal` functions is like `error`, but will `exit` the program with status
1.

The `critical` functions is like `error`, but will actually return with an
error. This is useful if you want to handle your errors with traps. See the
[demo](./demo.sh) for an example usage.

## Provided functions

- `echoe`: like `echo` but redirected to `stderr`
- `trace`: log a trace message
- `debug`: log a debugging message
- `info`: log an information message
- `warn`: log a warning message
- `error`: log an error message
- `fatal`: log an error message and `exit 1`
- `critical`: log an error message and return with an error
- `is_debug`: succeeds if debugging messages are enabled
- `is_trace`: succeeds if trace messages are enabled

## Provided variables

- `${VERBOSE_ARG}`: an array variable which is `("--verbose")` when debug
	messages are enabled, `()` otherwise. Use it by adding `"${VERBOSE_ARG[@]}"`
	in programs supporting the `--verbose` flag.

### Escape codes

- `${NORMAL}`: reset the styling
- `${BOLD}`

Foreground colors:

- `${RED}`
- `${GREEN}`
- `${YELLOW}`
- `${BLUE}`
- `${PURPLE}`
- `${CYAN}`
- `${WHITE}`
