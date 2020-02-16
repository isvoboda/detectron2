#!/bin/bash

: "${LOGIN:="developer"}"
: "${USER_UID:=1000}"
: "${USER_SHELL:="/bin/bash"}"
: "${USER_HOME:="/home/$LOGIN"}"

useradd --uid $USER_UID \
        --non-unique \
        --user-group \
        --shell $USER_SHELL \
        --create-home --home-dir \
        $USER_HOME $LOGIN

chown $LOGIN $USER_HOME -R

echo "$LOGIN ALL=(ALL:ALL) NOPASSWD: ALL" >/etc/sudoers.d/$LOGIN &&
        chmod 0440 /etc/sudoers.d/$LOGIN

# Temporary fixed due to vscode docker remote based on docker image.
# This should be dropped when --gpus get supported in docker-compose.yml
# Now the --gpus can be forwarded vie run-args only, see devcontainer.json.
parameters=("$@")
((${#parameters[@]})) && COMMAND=("$@") || COMMAND=("/bin/sh" "-c" "sleep infinity")

exec gosu $LOGIN "${COMMAND[@]}"
