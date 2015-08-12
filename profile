#!/bin/sh
#
# Profile script
#
# Load shell environment variables and other settings propagated to sub-shells
#

# Load includes
. "${SHELL_PROFILE_PATH}/script_functions"

if [ $? -eq 0 ]; then
    msgDebug "Loaded script_functions in profile"
    SHELL_PROFILE_DEF_SCRIPT_FUNCTIONS=profile
fi

msgDebug "==> Running profile script\n"

#
# Get platform
#
SHELL_PROFILE_PLATFORM=$(getPlatform)

if [ "${SHELL_PROFILE_PLATFORM}" == "unknown" ]; then
    msgDebug "Unknown platform detected!\n"
else
    msgDebug "Detected platform ${SHELL_PROFILE_PLATFORM}\n"
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
                msgDebug "Found ~/.dir_colors, setting ls environment variables...\n"
                LS_OPTIONS="--color=auto"
                eval $(dircolors ~/.dir_colors)
            fi
            ;;
    esac
fi

#
# Check for and add common paths
#
msgDebug "Setting PATH...\n"
msgDebug "Current PATH=${PATH}\n"
if [ $((${SHELL_PROFILE_ADD_COMMON_PATHS:-1})) -eq 1 ]; then
    msgDebug "Adding common paths...\n"
    SHELL_PROFILE_COMMON_PATHS=$(cat <<_SHELL_PROFILE_COMMON_PATHS_END
/bin
/sbin
/usr/bin
/usr/sbin
/usr/local/bin
/usr/local/sbin
/opt/local/bin
/opt/local/sbin
$HOME/bin
_SHELL_PROFILE_COMMON_PATHS_END
)
    addPaths "${SHELL_PROFILE_COMMON_PATHS}"
fi

#
# Add paths from SHELL_PROFILE_LOCAL_PATH_PREPEND_FILE
#
if [ -f "${SHELL_PROFILE_LOCAL_PATH_PREPEND_FILE}" ]; then
    msgDebug "Prepending paths from ${SHELL_PROFILE_LOCAL_PATH_PREPEND_FILE}...\n"
    addPaths "$(cat "${SHELL_PROFILE_LOCAL_PATH_PREPEND_FILE}")"
fi

#
# Add paths from SHELL_PROFILE_LOCAL_PATH_APPEND_FILE
#
if [ -f "${SHELL_PROFILE_LOCAL_PATH_APPEND_FILE}" ]; then
    msgDebug "Appending paths from ${SHELL_PROFILE_LOCAL_PATH_APPEND_FILE}...\n"
    addPaths "$(cat "${SHELL_PROFILE_LOCAL_PATH_APPEND_FILE}")" after
fi

#
# Set shell options
#
case "${SHELL}" in
    *bash)
        if [ -r "$HOME/.bashrc" ]; then
            msgDebug "Starting bashrc script...\n"
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

msgDebug "==> Done in profile script\n"

#
# Clean up
#
cleanUp profile

# vim: syntax=sh:ts=4:sw=4
