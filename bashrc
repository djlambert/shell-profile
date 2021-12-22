#!/bin/bash
# Load includes
. "${SHELL_PROFILE_PATH}/script_functions" bashrc

if hasFlag "${SHELL_PROFILE_FLAG_BASHRC_DONE}"; then
    msgDebug "Skipping bashrc, already run.\n"
    return
fi

setFlag "${SHELL_PROFILE_FLAG_BASHRC_DONE}"
msgDebug "==> Running bashrc script\n"

if ! hasFlag "${SHELL_PROFILE_FLAG_PROFILE_DONE}"; then
    msgDebug "Starting profile script...\n"
    . "$HOME/.profile"
fi

#
# Setup history
#
msgDebug "Configuring history\n"
export HISTSIZE=1000000
export HISTFILESIZE=1000000
export HISTTIMEFORMAT="%F %T "
export HISTCONTROL=ignoreboth
export HISTIGNORE='ls:bg:fg:history'
shopt -s histappend
export PROMPT_COMMAND="history -a; history -c; history -r; settitle; ${PROMPT_COMMAND}"

#
# Set prompt
#
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
if [ "${SHELL_PROFILE_PLATFORM}" = "darwin" ]; then
    alias bplist='plutil -convert xml1 -o /dev/stdout'
    alias flushdns='sudo killall -HUP mDNSResponder'
    alias kickstart='/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart'
fi

#
# Include local settings
#
if [ -f "${HOME}/.shell/bashrc.local" ]; then
    . "${HOME}/.shell/bashrc.local"
fi

msgDebug "==> Done in bashrc script\n"

cleanUp bashrc

# vim: syntax=sh:ts=4:sw=4
