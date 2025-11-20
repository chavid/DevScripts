#!/usr/bin/env bash
#
# Entrypoint for JupyterCpp container
# Handles arbitrary UIDs (docker --user, OpenShift, etc.)
# Sets up HOME, USER, conda environment, and execs the command
#

# Detect current UID/GID
CURRENT_UID=$(id -u)
CURRENT_GID=$(id -g)

# Configuration
DEFAULT_USER="dev"
DEFAULT_HOME="/home/${DEFAULT_USER}"
CONDA_DIR="${CONDA_DIR:-/opt/conda}"

# Function to setup user environment
setup_user() {
    # Check if user entry exists in /etc/passwd
    if ! getent passwd "${CURRENT_UID}" &>/dev/null; then
        echo "⚙️  Setting up environment for UID ${CURRENT_UID} (no passwd entry)..."
        
        # Try to create user entry if we have write permissions (running as root)
        if [[ -w /etc/passwd ]] && [[ -w /etc/group ]]; then
            echo "   Creating user entry in /etc/passwd..."
            
            # Create group if it doesn't exist
            if ! getent group "${CURRENT_GID}" &>/dev/null; then
                echo "${DEFAULT_USER}:x:${CURRENT_GID}:" >> /etc/group
            fi
            
            # Add user entry
            echo "${DEFAULT_USER}:x:${CURRENT_UID}:${CURRENT_GID}:Dynamic User:${DEFAULT_HOME}:/bin/bash" >> /etc/passwd
            
            # Create home directory if it doesn't exist
            if [[ ! -d "${DEFAULT_HOME}" ]]; then
                mkdir -p "${DEFAULT_HOME}" 2>/dev/null || true
                chown "${CURRENT_UID}:${CURRENT_GID}" "${DEFAULT_HOME}" 2>/dev/null || true
            fi
        else
            echo "   No write permission to /etc/passwd (running with --user). Using environment variables only."
        fi
    fi
}

# Function to setup environment variables
setup_environment() {
    # Get username (either from passwd or default)
    if USERNAME=$(getent passwd "${CURRENT_UID}" 2>/dev/null | cut -d: -f1); then
        export USER="${USERNAME}"
    else
        export USER="${DEFAULT_USER}"
    fi
    
    # Set HOME if not already set or if it's root (/)
    if [[ -z "${HOME:-}" ]] || [[ "${HOME}" == "/" ]]; then
        if HOME_DIR=$(getent passwd "${CURRENT_UID}" 2>/dev/null | cut -d: -f6); then
            export HOME="${HOME_DIR}"
        else
            export HOME="${DEFAULT_HOME}"
        fi
    fi
    
    # Ensure HOME directory exists with proper permissions
    # If we can't create it (no permissions), use /tmp as fallback
    if [[ ! -d "${HOME}" ]]; then
        if mkdir -p "${HOME}" 2>/dev/null; then
            echo "   Created HOME directory: ${HOME}"
        else
            echo "   ⚠️  Cannot create ${HOME}, using /tmp/home-${CURRENT_UID} as HOME"
            export HOME="/tmp/home-${CURRENT_UID}"
            mkdir -p "${HOME}" 2>/dev/null || export HOME="/tmp"
        fi
    fi
    
    # Test if HOME is writable, fallback to /tmp if not
    if [[ ! -w "${HOME}" ]]; then
        echo "   ⚠️  HOME ${HOME} is not writable, using /tmp/home-${CURRENT_UID}"
        export HOME="/tmp/home-${CURRENT_UID}"
        mkdir -p "${HOME}" 2>/dev/null || export HOME="/tmp"
    fi
    
    # Set conda paths (already in PATH via Dockerfile ENV, but ensure)
    export CONDA_DIR="${CONDA_DIR}"
    export PATH="${CONDA_DIR}/bin:${PATH}"
    
    # Configure Jupyter paths to use writable locations
    # This prevents Jupyter from trying to write to /.local or other non-writable paths
    export JUPYTER_DATA_DIR="${HOME}/.local/share/jupyter"
    export JUPYTER_CONFIG_DIR="${HOME}/.jupyter"
    export JUPYTER_RUNTIME_DIR="${HOME}/.local/share/jupyter/runtime"
    export IPYTHONDIR="${HOME}/.ipython"
    
    # Create Jupyter directories if they don't exist
    mkdir -p "${JUPYTER_DATA_DIR}" "${JUPYTER_CONFIG_DIR}" "${JUPYTER_RUNTIME_DIR}" "${IPYTHONDIR}" 2>/dev/null || true
    
    # Also set matplotlib cache to avoid warnings
    export MPLCONFIGDIR="${HOME}/.config/matplotlib"
    mkdir -p "${MPLCONFIGDIR}" 2>/dev/null || true
    
    echo "✓ Environment setup complete:"
    echo "  USER=${USER}"
    echo "  HOME=${HOME}"
    echo "  UID=${CURRENT_UID}, GID=${CURRENT_GID}"
    echo "  CONDA_DIR=${CONDA_DIR}"
    echo "  JUPYTER_DATA_DIR=${JUPYTER_DATA_DIR}"
}

# Function to initialize conda for current shell
init_conda() {
    if [[ -f "${CONDA_DIR}/etc/profile.d/conda.sh" ]]; then
        # Source conda.sh to enable conda activate/deactivate
        # shellcheck disable=SC1090,SC1091
        . "${CONDA_DIR}/etc/profile.d/conda.sh" || return 0
        
        # Activate base environment if not already active
        # Use || true to avoid script failure if already activated or if activation fails
        if [[ "${CONDA_DEFAULT_ENV:-}" != "base" ]]; then
            conda activate base 2>/dev/null || true
        fi
    fi
}

# Main execution
main() {
    # Only setup user if running as non-root arbitrary UID
    if [[ "${CURRENT_UID}" -ne 0 ]]; then
        setup_user
    fi
    
    # Always setup environment
    setup_environment
        
    # Initialize conda if running interactive/login shell
    if [[ -t 0 ]] || [[ "${1:-}" == "bash" ]] || [[ "${1:-}" == "sh" ]]; then
        init_conda
    fi
    
    # If no command provided, use default from Dockerfile CMD
    if [[ $# -eq 0 ]]; then
        echo "🚀 Starting default command: jupyter lab"
        exec jupyter lab --port=8888 --ip=0.0.0.0 --no-browser --allow-root
    else
        echo "🚀 Executing: $*"
        exec "$@"
    fi
}

# Run main with all arguments
main "$@"
