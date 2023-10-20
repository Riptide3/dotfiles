# Zinit
source "$HOMEBREW_PREFIX/opt/zinit/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# PATH
export PATH=$PATH:~/.local/bin

# JAVA
export JAVA_HOME=$(/usr/libexec/java_home)

# llvm
export PATH="$HOMEBREW_PREFIX/opt/llvm/bin:$PATH"
export LDFLAGS="-L$HOMEBREW_PREFIX/opt/llvm/lib"
export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/llvm/include"

# proxy
alias proxy='export https_proxy=http://127.0.0.1:7890;export http_proxy=http://127.0.0.1:7890;export all_proxy=socks5://127.0.0.1:7890'
alias unproxy='unset https_proxy http_proxy all_proxy'

# 常用命令替代品
alias top='htop'
alias vim='lvim'
DISABLE_LS_COLORS=true
alias ls='exa'
alias grep='rg'
alias cat='bat'
alias ping='prettyping --nolegend'

# 加载 OMZ 框架及部分插件
zi snippet OMZ::lib/completion.zsh
zi snippet OMZ::lib/history.zsh
zi snippet OMZ::lib/key-bindings.zsh
zi snippet OMZ::lib/theme-and-appearance.zsh
zi snippet OMZ::plugins/colored-man-pages/colored-man-pages.plugin.zsh
zi snippet OMZ::plugins/sudo/sudo.plugin.zsh

zi ice svn lucid wait"2"
zi snippet OMZ::plugins/extract

zi ice lucid wait"1"
zi snippet OMZ::plugins/git/git.plugin.zsh

# 加载命令的补全等
zi ice mv="*.zsh -> _fzf" as="completion"
zi snippet 'https://github.com/junegunn/fzf/blob/master/shell/completion.zsh'
zi snippet 'https://github.com/junegunn/fzf/blob/master/shell/key-bindings.zsh'
zi ice as="completion"
zi snippet 'https://github.com/robbyrussell/oh-my-zsh/blob/master/plugins/fd/_fd'
zi ice as="completion"
zi snippet 'https://github.com/ogham/exa/blob/master/completions/zsh/_exa'
zi ice lucid wait"0" depth"1" blockf
zi light zsh-users/zsh-completions
zi fpath -f "$HOMEBREW_PREFIX/share/zsh/site-functions"

zpcompinit; zpcdreplay

# 配置 fzf 使用 fd
export FZF_DEFAULT_COMMAND='fd --type f'

# fzf-tab
zi ice lucid wait"1" depth"1"
zi light Aloxaf/fzf-tab
zstyle ':fzf-tab:complete:_zlua:*' query-string input
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-preview 'ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:kill:argument-rest' fzf-flags '--preview-window=down:3:wrap'
zstyle ':fzf-tab:complete:kill:*' popup-pad 0 3
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:complete:cd:*' popup-pad 30 0
zstyle ":fzf-tab:*" fzf-flags --color=bg+:23
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' file-sort modification
zstyle ':completion:*:exa' sort false
zstyle ':completion:files' sort false
zstyle ':fzf-tab:*:*argument-rest*' popup-pad 100 0
zstyle ':fzf-tab:*' switch-group ',' '.'

# fasd
fasd_cache="$HOME/.fasd-init-zsh"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache
alias a='fasd -a'        # any
alias s='fasd -si'       # show / search / select
alias d='fasd -d'        # directory
alias f='fasd -f'        # file
alias sd='fasd -sid'     # interactive directory selection
alias sf='fasd -sif'     # interactive file selection
alias v='f -e lvim'      # quick opening files with vim

# fzf-fasd
zi ice lucid wait"1" depth"1"
zi light wookayin/fzf-fasd

# 语法高亮，自动建议
zi light-mode for \
    zdharma-continuum/fast-syntax-highlighting \
    zsh-users/zsh-autosuggestions

# 加载 pure 主题
zi ice depth"1" pick"async.zsh" src"pure.zsh"
zi light sindresorhus/pure

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$HOMEBREW_PREFIX/Caskroom/miniforge/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOMEBREW_PREFIX/Caskroom/miniforge/base/etc/profile.d/conda.sh" ]; then
        . "$HOMEBREW_PREFIX/Caskroom/miniforge/base/etc/profile.d/conda.sh"
    else
        export PATH="$HOMEBREW_PREFIX/Caskroom/miniforge/base/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# 延迟加载nvm
export NVM_DIR="$HOME/.nvm"
# This lazy loads nvm
nvm() {
  unset -f nvm
  # This loads nvm
  [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" --no-use
  nvm $@
}
# This loads nvm bash_completion
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"
# This resolves the default node version
DEFAULT_NODE_VER="$( (< "$NVM_DIR/alias/default" || < ~/.nvmrc) 2> /dev/null)"
while [ -s "$NVM_DIR/alias/$DEFAULT_NODE_VER" ] && [ ! -z "$DEFAULT_NODE_VER" ]; do
  DEFAULT_NODE_VER="$(<"$NVM_DIR/alias/$DEFAULT_NODE_VER")"
done
# This resolves the path to the default node version
DEFAULT_NODE_VER_PATH="$(find $NVM_DIR/versions/node -maxdepth 1 -name "v${DEFAULT_NODE_VER#v}*" | sort -rV | head -n 1)"
# This adds the default node version path to PATH
if [ ! -z "$DEFAULT_NODE_VER_PATH" ]; then
  export PATH="$DEFAULT_NODE_VER_PATH/bin:$PATH"
fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
