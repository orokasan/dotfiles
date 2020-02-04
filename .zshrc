export LANG=ja_JP.UTF-8

export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export TEXINPUTS='.//;'
[[ -d ~/.rbenv  ]] && \
  export PATH=${HOME}/.rbenv/bin:${PATH} && \
  eval "$(rbenv init -)"
autoload -Uz compinit
compinit
setopt share_history
HISTSIZE=10000
SAVEHIST=10000
# COLOR {{{
# color at completion
autoload colors
# remove file mark
unsetopt list_types
setopt auto_cd
setopt pushd_ignore_dups

# cdした際のディレクトリをディレクトリスタックへ自動追加
setopt auto_pushd
# ディレクトリスタックへの追加の際に重複させない
setopt pushd_ignore_dups
# 自動でpushdを実行
setopt auto_pushd
# pushdから重複を削除
setopt pushd_ignore_dups
# ALIAS {{{
# general
alias ls='ls -G'
alias ll='ls -l'        # 多用します
alias la='ls -A'        # 多用します
alias l='ls -CF'
alias du='du -sh *'     # ディレクトリごとにサブディレクトリ含む合計容量を出力します
alias caddy='ruby /opt/caddy/caddy/caddy.rb'
alias tm='terminal'     # tm ./ で現在いるディレクトリでターミナルを複製できます
alias reload='source ~/.zshrc' # .zshrc編集中は多用してます
alias ssh='TERM=xterm ssh'

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
alias dot='cd ~/dotfiles/'
alias zshconfig='nvim ~/.zshrc'
alias vimconfig='nvim ~/.vimrc'

# grep
alias g='grep --color=always'
alias jgrep='grep --include="*.java"'
alias jsgrep='grep --include="*.js"'
alias pygrep='grep --include="*.py"'
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

alias -g L='| less'
alias -g H='| head'
alias -g G='| grep'
alias -g GI='| grep -ri'
alias so='source'
alias c='cdr'
alias h='fc -lt '%F %T' 1'
alias cp='cp -iv'
alias rm='rm -iv'
alias mkdir='mkdir -pv'
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


# bindkey

# vi-like mapping
 bindkey -v
 bindkey -M viins '\er' history-incremental-pattern-search-forward
 bindkey -M viins '^?'  backward-delete-char
 bindkey -M viins '^A'  beginning-of-line
 bindkey -M viins '^B'  backward-char
 bindkey -M viins '^D'  delete-char-or-list
 bindkey -M viins '^E'  end-of-line
 bindkey -M viins '^F'  forward-char
 bindkey -M viins '^G'  send-break
 bindkey -M viins '^H'  backward-delete-char
 bindkey -M viins '^K'  kill-line
 bindkey -M viins '^N'  down-line-or-history
 bindkey -M viins '^P'  up-line-or-history
 bindkey -M viins '^R'  history-incremental-pattern-search-backward
 bindkey -M viins '^U'  backward-kill-line
 bindkey -M viins '^W'  backward-kill-word
 bindkey -M viins '^Y'  yank

cdpath=(.. ~)
autoload -Uz select-word-style
select-word-style default
zstyle ':zle:*' word-chars "_-./;@"
zstyle ':zle:*' word-style unspecified
zstyle ':completion:*:default' menu select=2
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion::complete:*' use-cache true
# bindkey '^r' history-incremental-pattern-search-backward
# bindkey '^s' history-incremental-pattern-search-forward
# # 例 ls まで打ってCtrl+pでlsコマンドをさかのぼる、Ctrl+bで逆順
# autoload -Uz history-search-end
# zle -N history-beginning-search-backward-end history-search-end
# zle -N history-beginning-search-forward-end history-search-end
# bindkey "^p" history-beginning-search-backward-end
# bindkey "^b" history-beginning-search-forward-end

# cdr タブでリストを表示
autoload -Uz add-zsh-hook
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs

#zplug
bindkey -e

source ~/.zplug/init.zsh
zplug "zsh-users/zsh-completions"
# zplug "zsh-users/zsh-autosuggestions"
zplug "mafredri/zsh-async", from:github
zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme
zplug "yukiycino-dotfiles/fancy-ctrl-z"
bindkey '^z' fancy-ctrl-z

if ! zplug check --verbose; then
    printf 'Install? [y/N]: '
    if read -q; then
        echo; zplug install
    fi
fi
zplug load
# zsh-syntax-highlighting
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fgコマンドの%を省略
fg() {
    if [[ $# -eq 1 && $1 = - ]]; then
        builtin fg %-
    else
        builtin fg %"$@"
    fi
}

# fzf
# Options to fzf command
export FZF_COMPLETION_TRIGGER=''
export FZF_DEFAULT_OPTS=' --height 40% --reverse --select-1 --exit-0 --multi'
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export FZF_CTRL_T_COMMAND='rg --files --hidden --glob "!.git/*"'
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
bindkey '^T' fzf-completion
bindkey '^I' $fzf_default_completion

# 一発でディレクトリ移動
fd() {
  local dir
  dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
  cd "$dir"
}

# fzf-cdr 
alias cdd='fzf-cdr'
function fzf-cdr() {
    target_dir=`cdr -l | sed 's/^[^ ][^ ]*  *//' | fzf`
    target_dir=`echo ${target_dir/\~/$HOME}`
    if [ -n "$target_dir" ]; then
        cd $target_dir
    fi
}
# 差分を確認しながらステージング
fga() {
  modified_files=$(git status --short | awk '{print $2}') &&
  selected_files=$(echo "$modified_files" | fzf -m --preview 'git diff {}') &&
  git add $selected_files
}

# プレビューしながらvimで開く
fvim() {
  files=$(git ls-files) &&
  selected_files=$(echo "$files" | fzf -m --preview 'head -100 {}') &&
  vim $selected_files
}

fh() {
  eval $( ([ -n "$ZSH_NAME" ] && fc -l 1 || history) | fzf +s --tac | sed 's/ *[0-9]*\*? *//' | sed 's/\\/\\\\/g')
}
# fkill - kill processes - list only the ones you can kill. Modified the earlier script.
fkill() {
    local pid 
    if [ "$UID" != "0" ]; then
        pid=$(ps -f -u $UID | sed 1d | fzf -m | awk '{print $2}')
    else
        pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}') fi  
    if [ "x$pid" != "x" ]
    then
        echo $pid | xargs kill -${1:-9}
    fi  
}

# fgをfzfで
alias fgg='_fgg'
function _fgg() {
    wc=$(jobs | wc -l | tr -d ' ')
    if [ $wc -ne 0 ]; then
        job=$(jobs | awk -F "suspended" "{print $1 $2}"|sed -e "s/\-//g" -e "s/\+//g" -e "s/\[//g" -e "s/\]//g" | grep -v pwd | fzf | awk "{print $1}")
        wc_grep=$(echo $job | grep -v grep | grep 'suspended')
        if [ "$wc_grep" != "" ]; then
            fg %$job
        fi
    fi
}

alias gg='_gg'
function _gg () {
open -a /Applications/Safari.app \
    "http://www.google.com/search?q= $1"
    echo "Now googling $1..."
}
