#!/usr/bin/env bash

# Initialize conda (installed in $HOME/miniforge3 by Dockerfile)
__conda_setup="$($HOME/miniforge3/bin/conda shell.bash hook 2> /dev/null)" || true
if [[ -n "${__conda_setup}" ]]; then
    eval "${__conda_setup}"
elif [[ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]]; then
    # shellcheck disable=SC1090
    . "$HOME/miniforge3/etc/profile.d/conda.sh"
    conda activate base || true
else
    export PATH="$HOME/miniforge3/bin:$PATH"
fi
unset __conda_setup

# Forward all arguments safely (e.g. mamba install -y pkg)
eval "$@"

