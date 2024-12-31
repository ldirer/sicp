#!/usr/bin/env bash
SICP_LOGIC_INTERPRETER_DELAYED_FILTERING=1 scheme --load "ch4/4.4.logic/repl.scm" < "$@"
