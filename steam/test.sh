#!/bin/bash
# http://wiki.bash-hackers.org/howto/mutex
# http://stackoverflow.com/questions/4381618/exit-a-script-on-error
# http://www.davidpashley.com/articles/writing-robust-shell-scripts/
set -e
set -o noclobber

trap 'rm -f $fpid' 0
trap 'echo "error $? by $BASH_COMMAND on line $LINENO"' ERR

echo $0
#echo $$ > ./$0.pid

PID_DIR="."

fpid="${PID_DIR}/$0.pid"
if [ ! -f "$fpid" ]; then
    echo "$$" > "$fpid"
else
    pid=$(< $fpid)
    echo "error: fpid (${fpid}) already exists."
    echo "created by pid:$pid name:$(< /proc/$pid/cmdline)"
    exit 1
fi

[ $UID -ne 0 ] && echo "call to root"; exit 1
