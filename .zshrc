export LANG=ja_JP.UTF-8
export PATH="$HOME/bin:$PATH"
autoload -Uz compinit
compinit
setopt share_history
HISTFILE=$HOME/.zsh-history
HISTSIZE=10000
SAVEHIST=10000

# COLOR {{{
# color at completion
autoload colors
zstyle ':completion:*' verbose yes
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# remove file mark
unsetopt list_types
setopt auto_cd
setopt pushd_ignore_dups

#PROMPT
autoload -U promptinit; promptinit
prompt pure
# ALIAS {{{
# general
alias ls='ls -G'
alias ll='ls -l'        # 多用します
alias la='ls -A'        # 多用します
alias l='ls -CF'
alias du='du -sh *'     # ディレクトリごとにサブディレクトリ含む合計容量を出力します
alias open='gnome-open' # htmlファイルをopenすればブラウザで開くことができます
alias caddy='ruby /opt/caddy/caddy/caddy.rb'
alias terminal='gnome-terminal --hide-menubar'
alias tm='terminal'     # tm ./ で現在いるディレクトリでターミナルを複製できます
alias reload='source ~/.zshrc' # .zshrc編集中は多用してます
alias ssh='TERM=xterm ssh'
alias ctags='/usr/local/Cellar/ctags/5.8_1/bin/ctags'

# cd
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'

# vim
alias v='nvim'
alias vi='nvim'
alias nvi='nvim'
alias vimdiff='nvim -d'

# dotfiles
alias dot='cd ~/dev/src/github.com/reireias/dotfiles'
alias zshconfig='nvim ~/.zshrc'
alias vimconfig='nvim ~/.vimrc'

# grep
alias g='grep --color=always'
alias grep='grep --color=always'
alias jgrep='grep --include="*.java"'
alias jsgrep='grep --include="*.js"'
alias fgrep='find ./ | grep'
alias ngrep='grep --exclude-dir={node_modules,.nuxt}'

# git
# gitはよく使うのでいろいろ設定しています。
# カラー設定込みでaliasに登録しているものもあります
# git
alias g="git"
alias gl="git l"
alias gla="git la"
alias gg="git la"
alias ge="gg --color | emojify | less -r"
alias push="git push origin HEAD"
alias push-f="git push --force-with-lease origin HEAD"
alias pull="git fetch -p && git pull"
alias gd="git diff"
# indexにaddしていないファイルを全て元に戻す
alias wipe="git checkout . && git clean -fd"

# tig
alias t="tig"
alias ta="tig --all"
alias g='git'

alias -g L='| less'
alias -g H='| head'
alias -g G='| grep'
alias -g GI='| grep -ri'
alias so='source'
alias c='cdr'
alias h='fc -lt '%F %T' 1'
alias cp='cp -i'
alias rm='rm -i'
alias mkdir='mkdir -p'
alias ..='c ../'
alias back='pushd'
alias diff='diff -U1'
bindkey "^[[3~" delete-char
chpwd() {
    ls_abbrev
}
ls_abbrev() {
    if [[ ! -r $PWD ]]; then
        return
    fi
    # -a : Do not ignore entries starting with ..
    # -C : Force multi-column output.
    # -F : Append indicator (one of */=>@|) to entries.
    local cmd_ls='ls'
    local -a opt_ls
    opt_ls=('-aCF' '--color=always')
    case "${OSTYPE}" in
        freebsd*|darwin*)
            if type gls > /dev/null 2>&1; then
                cmd_ls='gls'
            else
                # -G : Enable colorized output.
                opt_ls=('-aCFG')
            fi
            ;;
    esac

    local ls_result
    ls_result=$(CLICOLOR_FORCE=1 COLUMNS=$COLUMNS command $cmd_ls ${opt_ls[@]} | sed $'/^\e\[[0-9;]*m$/d')

    local ls_lines=$(echo "$ls_result" | wc -l | tr -d ' ')

    if [ $ls_lines -gt 10 ]; then
        echo "$ls_result" | head -n 5
        echo '...'
        echo "$ls_result" | tail -n 5
        echo "$(command ls -1 -A | wc -l | tr -d ' ') files exist"
    else
        echo "$ls_result"
    fi
}
cdpath=(.. ~)
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars "_-./;@"
zstyle ':zle:*' word-style unspecified
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
bindkey '^r' history-incremental-pattern-search-backward
bindkey '^s' history-incremental-pattern-search-forward
# 例 ls まで打ってCtrl+pでlsコマンドをさかのぼる、Ctrl+bで逆順
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^b" history-beginning-search-forward-end
# cdr タブでリストを表示
autoload -Uz add-zsh-hook
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs
# cdrコマンドで履歴にないディレクトリにも移動可能に
zstyle ":chpwd:*" recent-dirs-default true
autoload -Uz zmv
alias zmv='noglob zmv -W'
function mkcd() {
  if [[ -d $1 ]]; then
    echo "$1 already exists!"
    cd $1
  else
    mkdir -p $1 && cd $1
  fi
}
# zsh-syntax-highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#zplug
bindkey -e

source ~/.zplug/init.zsh
zplug "zsh-users/zsh-autosuggestions"

if ! zplug check --verbose; then
    printf 'Install? [y/N]: '
    if read -q; then
        echo; zplug install
    fi
fi
zplug load
