#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$(yarn global bin)"
export JAVA_HOME='/usr/lib/jvm/java-11-openjdk'

alias ls='ls --color=auto'
alias ll='ls --color=auto -l'
alias la='ls --color=auto -la'

alias vim='nvim'
alias luamake=/home/sneeky/aurinstalls/lua-language-server/3rd/luamake/luamake


PS1='[\u@\h \W]\$ '
