########################################################
# vim:smd:ar:si:noet:bg=dark:sts=0:ts=4:sw=4
# file: .zshrc
# author: Chris Olin - http://chrisolin.com
# purpose:
# created date: 03-18-2013
# last modified: Wed, Nov 27, 2013  3:20:31 PM
# license:
########################################################
autoload -U colors
autoload -U promptinit
autoload -U compinit
colors
promptinit
compinit

# source aliases
if [ -f "${HOME}/.aliases" ]; then
    source "${HOME}/.aliases"
fi
if [ -f "${HOME}/.secretaliases" ]; then
    source "${HOME}/.secretaliases"
fi

if [ -d "$HOME/.oh-my-zsh" ]; then
    ZSH=$HOME/.oh-my-zsh #leave this alone
    source ~/.oh-my-zsh/oh-my-zsh.sh
else
    git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
    ZSH=$HOME/.oh-my-zsh
    source ~/.oh-my-zsh/oh-my-zsh.sh
fi

# configure prompt colors
if [ $UID -eq 0 ]; then NCOLOR="red"; else NCOLOR="green"; fi
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
eval my_gray='$FG[237]'
eval my_orange='$FG[214]'

# git color settings
ZSH_THEME_GIT_PROMPT_PREFIX="$FG[075](branch:"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="$my_orange*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="$FG[075])%{$reset_color%}"

# set prompts
PROMPT='$FG[124][%y]%{$reset_color%}%  $FG[032]%~ \
$(git_prompt_info) \
$FG[105]%(!.#.»)%{$reset_color%} '
PROMPT2='%{$fg[red]%}\ %{$reset_color%}'
RPS1='${return_code}'

if [[ -n $EXTENDEDPROMPT ]]; then
	PROMPT='$FG[124][%y]%{$reset_color%}%  $FG[188]%n@%m%  \
$FG[032]%~ \
$(git_prompt_info) \
$FG[105]%(!.#.»)%{$reset_color%} '
fi

# autocompletion with arrow key interface
 zstyle ':completion:*' menu select

# autocompletion of command line switches for aliases
 setopt completealiases

# set display, needed for CygwinX/xclip
export DISPLAY=:0

# autoconfigure ssh-agent
SSH_ENV="$HOME/.ssh/environment"

function start_agent {
     echo "Initialising new SSH agent..."
     /usr/bin/ssh-agent | sed 's/^echo/#echo/' > "${SSH_ENV}"
     echo succeeded
     chmod 600 "${SSH_ENV}"
     . "${SSH_ENV}" > /dev/null
     /usr/bin/ssh-add;
     ssh-add $HOME/.ssh/keys/*[!.pub];
}

# source SSH settings, if applicable

if [ -f "${SSH_ENV}" ]; then
     . "${SSH_ENV}" > /dev/null
     #ps ${SSH_AGENT_PID} doesn't work under cywgin
     ps -ef | grep ${SSH_AGENT_PID} | grep ssh-agent$ > /dev/null || {
         start_agent;
     }
else
     start_agent;
fi

# other stuff
export PATH=$PATH:/usr/local/bin:$HOME/bin
export CYGWIN="mintty winsymlinks:nativeforce"
export TERM=xterm-256color
export SCREENDIR=/tmp/uscreens/S-$USERNAME
export EDITOR=vim
export JAVA_HOME="/cygdrive/c/ProgramFiles/Java/jdk1.8.0_25" #I set a symlink pointing ProgramFiles to Program Files under C: to fix an issue with the space in Program Files not being escaped
export CLASSPATH=$CLASSPATH:$HOME/bin
