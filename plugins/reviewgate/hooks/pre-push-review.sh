#!/usr/bin/env bash
# ReviewGate pre-push gate.
#
# Fail-open by design: if the reviewgate binary is not installed, do nothing —
# the plugin must never break a workflow it cannot serve. Once the binary is
# present, `reviewgate review --hook-stdin` takes over: it reads the hook
# payload from stdin, reacts only to `git push` commands, runs the same review
# and the same team rules that check the merge request, and is engineered not
# to break the session on its own failures.
set -uo pipefail
command -v reviewgate >/dev/null 2>&1 || exit 0
exec reviewgate review --hook-stdin
