#
# Profile script
#
# Load shell environment variables and other settings propagated to sub-shells
#

# Load includes
. "${SHELL_PROFILE_PATH}/vars"
. "${SHELL_PROFILE_PATH}/script_functions"

##
## Start of script
##

#
# Load local settings before doing anything
#
if [ -r "${SHELL_PROFILE_LOCAL_VAR_FILE}" ]; then
    . "${SHELL_PROFILE_LOCAL_VAR_FILE}"
    msgDebug "Loaded local variables from ${SHELL_PROFILE_LOCAL_VAR_FILE}"
    msgDebug "Debugging enabled"
fi

msgDebug "Running profile script"

#
# Get platform
#
SHELL_PROFILE_PLATFORM=$(getPlatform)

if [ "${SHELL_PROFILE_PLATFORM}" == "unknown" ]; then
    msgDebug "Unknown platform detected!"
else
    msgDebug "Detected platform ${SHELL_PROFILE_PLATFORM}"
fi
  
#
# Define pager
#
if [ -x /usr/bin/less ]; then
    export PAGER="/usr/bin/less -ins"
elif [ -x /usr/bin/more ]; then
    export PAGER="/usr/bin/more -s"
fi

#
# Set ls options
#
if [ "${TERM}" != "dumb" ]; then
    case "${SHELL_PROFILE_PLATFORM}" in
        "darwin")
            LS_OPTIONS="-G"
            export LSCOLORS="dxfxcxdxbxegedabagacad"
            ;;
        *)
            if [ -f ~/.dir_colors ]; then
                msgDebug "Found ~/.dir_colors, setting environment variables..."
                LS_OPTIONS="--color=auto"
                eval $(dircolors ~/.dir_colors)
            fi
            ;;
    esac
fi

#
# Check for and add common paths
# Add local paths from SHELL_PROFILE_LOCAL_PATH_FILE
#
msgDebug "Setting PATH..."
msgDebug "Current PATH=${PATH}"
SHELL_PROFILE_LOCAL_PATHS=$(cat <<_SHELL_PROFILE_LOCAL_PATHS_END
/usr/local/bin
/usr/local/sbin
/opt/local/bin
/opt/local/sbin
$HOME/bin
$([ -f "${SHELL_PROFILE_LOCAL_PATH_FILE}" ] && cat "${SHELL_PROFILE_LOCAL_PATH_FILE}")
_SHELL_PROFILE_LOCAL_PATHS_END
)

addPaths "${SHELL_PROFILE_LOCAL_PATHS}"

#
# Add paths from SHELL_PROFILE_LOCAL_PATH_PREPEND_FILE
#
if [ -f "${SHELL_PROFILE_LOCAL_PATH_PREPEND_FILE}" ]; then
    msgDebug "Prepending paths from ${SHELL_PROFILE_LOCAL_PATH_PREPEND_FILE}..."
    addPaths "$(cat "${SHELL_PROFILE_LOCAL_PATH_PREPEND_FILE}")"
fi

#
# Add paths from SHELL_PROFILE_LOCAL_PATH_APPEND_FILE
#
if [ -f "${SHELL_PROFILE_LOCAL_PATH_APPEND_FILE}" ]; then
    msgDebug "Appending paths from ${SHELL_PROFILE_LOCAL_PATH_APPEND_FILE}..."
    addPaths "$(cat "${SHELL_PROFILE_LOCAL_PATH_APPEND_FILE}")" after
fi

#
# Set shell options
#
case "${SHELL}" in
    *bash)
        export HISTSIZE=1000000
        export HISTFILESIZE=1000000
        export HISTTIMEFORMAT="%F %T "
        export HISTCONTROL=ignoreboth

        if [ -r "$HOME/.bashrc" ]; then
            . "$HOME/.bashrc"
        fi
        ;;
esac

msgDebug "Loading shell functions"
. "${SHELL_PROFILE_PATH}/shell_functions"

#
# Export vars
#
export PATH LS_OPTIONS OS_TYPE

#
# Clean up
#
cleanUp

# vim: syntax=sh:ts=4:sw=4
