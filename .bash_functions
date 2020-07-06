#!/bin/bash

alias-add() {
    echo "alias $1='$2'" >> ~/.bash_aliases
}

# print all 256 colours 
test-colour() {
    for((i=16; i<256; i++)); do
        printf "\e[48;5;${i}m%03d" $i;
        printf '\e[0m';
        [ ! $((($i - 15) % 6)) -eq 0 ] && printf ' ' || printf '\n'
    done
}

# cd command but lists contents aswell.
cl() {
    DIR="$*";
        # if no DIR given, go home
        if [ $# -lt 1 ]; then
                DIR=$HOME;
    fi;
    builtin cd "${DIR}" && \
    # use your preferred ls command
        ls -F --color=auto
}


# Call with a git sub command to apply to all sub folders.
gitd() {
    printf '\e[0m'
    listDir="$(ls)";
    for repo in $listDir; do
        repoName="   ${repo}   ";
        repoLength=${#repoName}
        fullWidthString=$(printf -- "-%.0s" $(seq $(tput cols)));
        let stringIndex=(${#fullWidthString}-repoLength)/2
        repoString=${fullWidthString:0:stringIndex-1}$repoName${fullWidthString:stringIndex:-repoLength}
        
        echo ;
        # To lowercase
        gitResult=$(git -C "${repo}" $1)
        if [ "${1,,}" = "status" ]; then
            if [ -z "${gitResult##*'Your branch is up to date with'*}" ]; then 
                printf "\e[38;2;153;255;153m${repoString}-\n"
            else
                printf "\e[38;2;255;153;153m${repoString}-\n"
            fi
        else
            printf "${repoString}"
        fi

        printf "${gitResult}\n${fullWidthString:-repoLength}\n\e[0m"
    done;
}
