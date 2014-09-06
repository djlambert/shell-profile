#
# Include local settings
#
if [ -f "${HOME}/.shell/bashrc.local" ]; then
    . "${HOME}/.shell/bashrc.local"
fi

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

