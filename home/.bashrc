
# establish the script directory absolute path

ORIGINAL_DIR=${PWD}
MY_HOME_ENV_FILE=${BASH_SOURCE[0]}
MY_HOME_DIR=`dirname ${MY_HOME_ENV_FILE}`
cd ${MY_HOME_DIR}
MY_HOME_DIR=`pwd`
cd ${ORIGINAL_DIR}

# aliases

alias count=${MY_HOME_DIR}/bin/count.sh
alias oval=${MY_HOME_DIR}/bin/oval.py

# prompt

if [ -n "${DTAG+x}" ]; then
    export PS1="${DTAG#*/}:\w> "
fi

