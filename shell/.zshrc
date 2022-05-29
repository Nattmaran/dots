# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob
bindkey -v
bindkey '^R' history-incremental-pattern-search-backward
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/sneeky/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
#
export PATH="$PATH:$HOME/.local/bin"
export PATH="$PATH:$(yarn global bin)"
export PATH="$PATH:$HOME/go/bin"
#export JAVA_HOME='/usr/lib/jvm/java-11-openjdk'
export _JAVA_AWT_WM_NONREPARENTING=1

alias ls='ls --color=auto'
alias ll='ls --color=auto -l'
alias la='ls --color=auto -la'

alias vim='nvim'
alias luamake=/home/sneeky/aurinstalls/lua-language-server/3rd/luamake/luamake
alias cn='cargo new'
alias cr='cargo run'
alias cb='cargo build'

# git promt stuff, learn it later
autoload -U colors && colors
setopt prompt_subst
autoload -Uz vcs_info
zstyle ':vcs_info:*' actionformats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{3}|%F{1}%a%F{5}]%f '
zstyle ':vcs_info:*' formats '%F{5}(%f%s%F{5})%F{3}-%F{5}[%F{2}%b%F{5}]%f '
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{3}%r'

zstyle ':vcs_info:*' enable git cvs svn

# or use pre_cmd, see man zshcontrib
vcs_info_wrapper() {
  vcs_info
  if [ -n "$vcs_info_msg_0_" ]; then
    echo "%{$fg[grey]%}${vcs_info_msg_0_}%{$reset_color%}$del"
  fi
}
precmd(){print -rP "$bg[black]$fg[white]%m: %/ $(vcs_info_wrapper)"}
ROMPT='> '
