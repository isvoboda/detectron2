#!/bin/bash

: ${LOGIN:="developer"}
: ${USER_UID:=1000}
: ${USER_SHELL:="/bin/bash"}
: ${USER_HOME:="/home/$LOGIN"}

useradd --uid $USER_UID \
        --non-unique \
        --user-group \
        --shell $USER_SHELL \
        --create-home --home-dir \
        $USER_HOME $LOGIN

chown $LOGIN $USER_HOME -R

echo "$LOGIN ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/$LOGIN \
   && chmod 0440 /etc/sudoers.d/$LOGIN

exec gosu $LOGIN "$@"
