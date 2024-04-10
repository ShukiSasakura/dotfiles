############
# Plugins
############

############
# Completion
############
autoload -U compinit && compinit


############
# Prompt
############
# 手書きプロンプト
PROMPT="%F{cyan}%n@%m %~ $ %f"
autoload -Uz vcs_info
precmd_vcs_info() { vcs_info }
precmd_functions+=( precmd_vcs_info )
setopt prompt_subst
RPROMPT="%F{cyan}\$vcs_info_msg_0_"
# PROMPT=\$vcs_info_msg_0_'%# '
zstyle ':vcs_info:git:*' formats '%b'

############
# alias
############

export LS_COLORS="di=32:ex=33"
alias ls="ls -F --color=auto"
alias la="ls -aF --color=auto"
alias rm="rm -i"
function mkcd() {
    mkdir $1 && cd $1
}

alias ga="git add"
alias gd="git diff"
alias gg="git log --graph --all --oneline"
alias gl="git log"
alias gs="git status"

alias v="nvim"
alias vi="nvim"
alias vim="nvim"


############
# env
############
export PATH="$HOME/.local/bin:$PATH"
export EDITOR=nvim

# cargo
. "$HOME/.cargo/env"

############
# sheldon
############
eval "$(sheldon source)"
########
# Change one of colors in zsh-syntax-highlighting default colors
########
ZSH_HIGHLIGHT_STYLES[globbing]=fg=white
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=white

############
# Install
############
export WASMTIME_HOME="$HOME/.wasmtime"

export PATH="$WASMTIME_HOME/bin:$PATH"

. "/home/sasakura/.wasmedge/env"

# Wasmer
export WASMER_DIR="/home/sasakura/.wasmer"
[ -s "$WASMER_DIR/wasmer.sh" ] && source "$WASMER_DIR/wasmer.sh"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
