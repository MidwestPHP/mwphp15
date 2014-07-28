#!/bin/sh

source ~/.git-prompt.sh;

# Set some environment variables
export PROJECT_DATABASE='ottist001'

# Set text colors
black=$(tput -Txterm setaf 0)
red=$(tput -Txterm setaf 1)
green=$(tput -Txterm setaf 2)
yellow=$(tput -Txterm setaf 3)
dk_blue=$(tput -Txterm setaf 4)
pink=$(tput -Txterm setaf 5)
lt_blue=$(tput -Txterm setaf 6)

# Set background colors
bg_black=$(tput -Txterm setab 0)
bg_red=$(tput -Txterm setab 1)
bg_green=$(tput -Txterm setab 2)
bg_yellow=$(tput -Txterm setab 3)
bg_blue=$(tput -Txterm setab 4)
bg_ping=$(tput -Txterm setab 5)
bg_lt_blue=$(tput -Txterm setab 6)

bold=$(tput -Txterm bold)
reset=$(tput -Txterm sgr0)

__has_parent_dir () {
    # Utility function so we can test for things like .git/.hg without firing up a
    # separate process
    test -d "$1" && return 0;

    current="."
    while [ ! "$current" -ef "$current/.." ]; do
        if [ -d "$current/$1" ]; then
            return 0;
        fi
        current="$current/..";
    done

    return 1;
}

__vcs_name() {
    if [ -d .svn ]; then
        echo "-[svn]";
    elif __has_parent_dir ".git"; then
        echo "-[$(__git_ps1 'git %s')]";
    elif __has_parent_dir ".hg"; then
        echo "-[hg $(hg branch)]"
    fi
}

command_notation () {
    echo "## ${bg_black}* ${lt_blue}${1}${reset}${bg_black} == ${2}${reset}"
    return 0

}

# Nicely formatted terminal prompt
export PS1='\n$bg_yellow\[$bold\]\[$black\][\[$red\]\@\[$black\]]-[\[$dk_blue\]\u\[$yellow\]@\[$dk_blue\]\h\[$black\]]-[\[$pink\]\w\[$black\]]\[$(__vcs_name)\]\[$reset\]\n\[$reset\]\$ '

# Alias useful commands
alias nano='nano -Kw'

# reboot / halt / poweroff
alias reboot='sudo /sbin/reboot'
alias poweroff='sudo /sbin/poweroff'
alias halt='sudo /sbin/halt'
alias shutdown='sudo /sbin/shutdown'

echo ""
echo "############################################################################"
echo "## Commands available for this VM"
echo "##"

CWD=`pwd`
for f in `find ${CWD}/.command-files -name *commands`
do
    source $f
done

echo "##"
echo "############################################################################"

# Ubuntu Specific Aliases
source ./.distro-file

# move to the available web directory
cd /var/www