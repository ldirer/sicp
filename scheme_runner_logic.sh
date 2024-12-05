#!/usr/bin/env bash

#scheme --load "ch4/4.2.2/repl.scm" < "$@"
# a nice trick ChatGPT gave me to keep the REPL open for more input. Useful to debug.
# It's limited though, rlwrap does not work on the piped input.
#(cat "$@"; cat) | rlwrap scheme --load "ch4/4.2.2/repl.scm"
scheme --load "ch4/4.4.logic/repl.scm" < "$@"
