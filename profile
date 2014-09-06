#
# Profile script
#
# Load environment variables and other propagated settings
#

#
# Local functions - unset at end
#
pathmunge() {
    case ":${PATH}:" in
        *:"$1":*)
            ;;
        *)
            if [ "$2" = "after" ]; then
                PATH=$PATH:$1
            else
                PATH=$1:$PATH
            fi
    esac
}

# http://stackoverflow.com/a/8952274
uppers=ABCDEFGHIJKLMNOPQRSTUVWXYZ
lowers=abcdefghijklmnopqrstuvwxyz

lc() {
    i=0
    while ([ $i -lt ${#1} ]) do
        CUR=${1:$i:1}
        case $uppers in
            *$CUR*)CUR=${uppers%$CUR*};OUTPUT="${OUTPUT}${lowers:${#CUR}:1}";;
            *)OUTPUT="${OUTPUT}$CUR";;
        esac
        i=$((i+1))
    done
    echo "${OUTPUT}"
}

uc() {
    i=0
    while ([ $i -lt ${#1} ]) do
        CUR=${1:$i:1}
        case $lowers in
            *$CUR*)CUR=${lowers%$CUR*};OUTPUT="${OUTPUT}${uppers:${#CUR}:1}";;
            *)OUTPUT="${OUTPUT}$CUR";;
        esac
        i=$((i+1))
    done
    echo "${OUTPUT}"
}

#
# Try and determine OS
#
command -v uname >/dev/null 2>&1
RESULT=$?

if [ $RESULT ]; then
    OS_TYPE=$(uname -s)
    OS_TYPE=$(lc ${OS_TYPE})
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
# Define prompt
#
case "${SHELL}" in
    *bash)
        #typeset +x PS1="\u@\h:\w\\$ "
        typeset +x PS1='[\t][\u@\h]\w\$ '
        ;;
esac

#
# Set ls options
#
if [ "${TERM}" != "dumb" ]; then
    if [ "${OS_TYPE}" = "Darwin" ]; then
        LS_OPTIONS="-G"
        export LSCOLORS="dxfxcxdxbxegedabagacad"
    else
        if [ -f ~/.dir_colors ]; then
            case "${OS_TYPE}" in
                *)
                    LS_OPTIONS="--color=auto"
                    eval $(dircolors ~/.dir_colors)
                    ;;
            esac
        fi
    fi
fi

#
# Check for and add common paths
#
PATHS=$(cat <<_PATHS_END
/usr/local/bin
/usr/local/sbin
/opt/local/bin
/opt/local/sbin
$HOME/bin
_PATHS_END
)

for dir in $PATHS; do
    if [ -d "${dir}" ]; then
        pathmunge "${dir}"
    fi        
done

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

#
# Export local vars
#
export PATH LS_OPTIONS OS_TYPE

#
# Clean up
#
unset -f pathmunge lc uc

