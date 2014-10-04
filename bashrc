# Load includes

. "${SHELL_PROFILE_PATH}/vars"

if [ -z "${SHELL_PROFILE_DEF_SCRIPT_FUNCTIONS}" ]; then
    . "${SHELL_PROFILE_PATH}/script_functions"
    SHELL_PROFILE_DEF_SCRIPT_FUNCTIONS="bashrc"
fi

if [ -r "${SHELL_PROFILE_LOCAL_VAR_FILE}" ]; then
    . "${SHELL_PROFILE_LOCAL_VAR_FILE}"
    msgDebug "Loaded local variables from ${SHELL_PROFILE_LOCAL_VAR_FILE}"
    msgDebug "Debugging enabled"
fi

msgDebug "Running bashrc script"

#
# Include local settings
#
if [ -f "${HOME}/.shell/bashrc.local" ]; then
    . "${HOME}/.shell/bashrc.local"
fi

typeset +x PS1='[\t][\u@\h]\w\$ '
 
#
# Set ls aliases
#
alias ls='ls $LS_OPTIONS -F'
alias ll='ls $LS_OPTIONS -lF'

#
# Set aliases for root
#
if [[ $EUID -eq 0 ]]; then
    alias rm='rm -i'
    alias cp='cp -i'
    alias mv='mv -i'
fi

#
# Set OS specific aliases
#
if [ "${OS_TYPE}" = "darwin" ]; then
    alias bplist='plutil -convert xml1 -o /dev/stdout'
    alias flushdns='sudo killall -HUP mDNSResponder'
    alias kickstart='/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart'
fi

if [ "${SHELL_PROFILE_DEF_SCRIPT_FUNCTIONS}" == "bashrc" ]; then
    cleanUp
fi
