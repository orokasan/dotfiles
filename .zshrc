export LANG=ja_JP.UTF-8

export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin

export TEXINPUTS='.//;'
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

# ヒストリに追加されるコマンド行が古いものと同じなら古いものを削除
setopt hist_ignore_all_dups

# スペースで始まるコマンド行はヒストリリストから削除
setopt hist_ignore_space

# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify

# 余分な空白は詰めて記録
setopt hist_reduce_blanks  

# 古いコマンドと同じものは無視 
setopt hist_save_no_dups

# historyコマンドは履歴に登録しない
setopt hist_no_store

# 補完時にヒストリを自動的に展開         
setopt hist_expand

# 履歴をインクリメンタルに追加
setopt inc_append_history

# インクリメンタルからの検索
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward

# history search
bindkey '^P' history-beginning-search-backward
bindkey '^N' history-beginning-search-forward

autoload -U compinit
compinit

fpath+=("$(brew --prefix)/share/zsh/site-functions")
autoload -U promptinit; promptinit
prompt pure

### End of Zinit's installer chunk
