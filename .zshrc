export LANG=ja_JP.UTF-8

export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export MDPDF_STYLES=$HOME/dotfiles/mdpdf/style.css

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
bindkey '^r' history-incremental-pattern-search-backward
bindkey '^s' history-incremental-pattern-search-forward
# # 例 ls まで打ってCtrl+pでlsコマンドをさかのぼる、Ctrl+bで逆順
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^p" history-beginning-search-backward-end
bindkey "^b" history-beginning-search-forward-end

# cdr タブでリストを表示
autoload -Uz add-zsh-hook
autoload -Uz chpwd_recent_dirs cdr
add-zsh-hook chpwd chpwd_recent_dirs

alias gg='_gg'
function _gg () {
open -a /Applications/Firefox\ Nightly.app \
    "http://www.google.com/search?q= $1"
    echo "Now googling $1..."
}

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export PATH=$PATH:/home/linuxbrew/.linuxbrew/bin

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

# A glance at the new for-syntax – load all of the above
# plugins with a single command. For more information see:
# https://zdharma.github.io/zinit/wiki/For-Syntax/
zinit for \
    light-mode  zsh-users/zsh-autosuggestions \
    light-mode  zdharma/fast-syntax-highlighting \
                zdharma/history-search-multi-word \
    light-mode pick"async.zsh" src"pure.zsh" \
                sindresorhus/pure

### End of Zinit's installer chunk
