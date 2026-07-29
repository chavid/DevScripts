
# establish the script directory absolute path

ORIGINAL_DIR=${PWD}
DEV_DOCKER_ENV_FILE=${BASH_SOURCE[0]}
DEV_DOCKER_DIR=`dirname ${DEV_DOCKER_ENV_FILE}`
cd ${DEV_DOCKER_DIR}
DEV_DOCKER_DIR=`pwd`
cd ${ORIGINAL_DIR}

# aliases for the host only

alias drecipe=${DEV_DOCKER_DIR}/bin/recipe.sh
alias dbuild=${DEV_DOCKER_DIR}/bin/build.sh
alias drun=${DEV_DOCKER_DIR}/bin/run.sh
alias dpush=${DEV_DOCKER_DIR}/bin/push.sh
alias dpull=${DEV_DOCKER_DIR}/bin/pull.sh

# setup for the host and the containers

source ${DEV_DOCKER_DIR}/home/.bashrc

