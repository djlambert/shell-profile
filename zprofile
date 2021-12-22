#!/usr/bin/env zsh
THIS_SCRIPT=$(basename "${0}")

# Load includes
. "${SHELL_PROFILE_PATH}/script_functions" "${THIS_SCRIPT}"

if hasFlag "${SHELL_PROFILE_FLAG_ZPROFILE_DONE}"; then
    msgDebug "Skipping ${THIS_SCRIPT}, already run.\n"
    return
fi

setFlag "${SHELL_PROFILE_FLAG_ZPROFILE_DONE}"
msgDebug "==> Running ${THIS_SCRIPT} script\n"

. "$HOME/.profile"

#
# Setup history
#
export HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
export SAVEHIST=1000000
export HISTSIZE=1000000

setopt EXTENDED_HISTORY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY

#
# Set ls aliases
#
alias ls='ls $LS_OPTIONS -F'
alias ll='ls $LS_OPTIONS -lF'

#
# Include local settings
#
if [ -f "${HOME}/.shell/${THIS_SCRIPT}.local" ]; then
    . "${HOME}/.shell/${THIS_SCRIPT}.local"
fi

msgDebug "==> Done in ${THIS_SCRIPT} script\n"

cleanUp ${THIS_SCRIPT}

# vim: syntax=sh:ts=4:sw=4
