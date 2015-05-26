# Created by newuser for 5.0.7
# 少し凝った zshrc
# License : MIT
# http://mollifier.mit-license.org/

#PATH設定
#~/Dropbox/config/zshを読み込ませる

##~/.zshenv
##export ZDOTDIR=$HOME/Dropbox/config/zsh

########################################
# 環境変数
export LANG=ja_JP.UTF-8

# 色を使用出来るようにする
autoload -Uz colors
colors

# emacs 風キーバインドにする
bindkey -e

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# プロンプト
# 1行表示
# PROMPT="%~ %# "
# 2行表示
PROMPT="%{${fg[green]}%}[%n@%m]%{${reset_color}%} %~
$ "


# 単語の区切り文字を指定する
autoload -Uz select-word-style
select-word-style default
# ここで指定した文字は単語区切りとみなされる
# / も区切りと扱うので、^W でディレクトリ１つ分を削除できる
zstyle ':zle:*' word-chars " /=;@:{},|"
zstyle ':zle:*' word-style unspecified

########################################
# 補完
# 補完機能を有効にする
autoload -Uz compinit
compinit

# 補完で小文字でも大文字にマッチさせる
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# ../ の後は今いるディレクトリを補完しない
zstyle ':completion:*' ignore-parents parent pwd ..

# sudo の後ろでコマンド名を補完する
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
	   /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin

# ps コマンドのプロセス名補完
zstyle ':completion:*:processes' command 'ps x -o pid,s,args'


########################################
# vcs_info
autoload -Uz vcs_info
autoload -Uz add-zsh-hook

zstyle ':vcs_info:*' formats '%F{green}(%s)-[%b]%f'
zstyle ':vcs_info:*' actionformats '%F{red}(%s)-[%b|%a]%f'

function _update_vcs_info_msg() {
	LANG=en_US.UTF-8 vcs_info
	RPROMPT="${vcs_info_msg_0_}"
}
add-zsh-hook precmd _update_vcs_info_msg


########################################
# オプション
# 日本語ファイル名を表示可能にする
setopt print_eight_bit

# beep を無効にする
setopt no_beep

# フローコントロールを無効にする
setopt no_flow_control

# Ctrl+Dでzshを終了しない
setopt ignore_eof

# '#' 以降をコメントとして扱う
setopt interactive_comments

# ディレクトリ名だけでcdする
setopt auto_cd

# cd したら自動的にpushdする
setopt auto_pushd
# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンド行はヒストリに残さない
setopt hist_ignore_space

# ヒストリに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob

################################################

# C で標準出力をクリップボードにコピーする
# mollifier delta blog : http://mollifier.hatenablog.com/entry/20100317/p1
if which pbcopy >/dev/null 2>&1 ; then
	# Mac
	alias -g C='| pbcopy'
elif which xsel >/dev/null 2>&1 ; then
	# Linux
	alias -g C='| xsel --input --clipboard'
elif which putclip >/dev/null 2>&1 ; then
	# Cygwin
	alias -g C='| putclip'
fi



########################################
# OS 別の設定
case ${OSTYPE} in
	darwin*)
		#Mac用の設定
		export CLICOLOR=1
		alias ls='ls -G -F'
		;;
	linux*)
		#Linux用の設定
		alias ls='ls -F --color=auto'
		;;
esac

# Shift-Tabで補完候補を逆順する（"\e[Z"でも動作する）
bindkey "^[[Z" reverse-menu-complete

autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end

# C-p C-n で検索に
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end

#背景画像表示
set_bg_image() {
  /usr/bin/osascript <<EOF
  tell application "iTerm"
    tell the current terminal
      tell the current session
        set background image path to "$1"
      end tell
    end tell
  end tell
EOF
}

#set_bg_image ~/Pictures/なべすたー.png
# load .zshrc_*
[ -f $ZDOTDIR/.zshrc_Drawin     ] && . $ZDOTDIR/.zshrc_Drawin
[ -f $ZDOTDIR/.zshrc_external    ] && . $ZDOTDIR/.zshrc_external
[ -f $ZDOTDIR/.zshrc_alias       ] && . $ZDOTDIR/.zshrc_alias
[ -f $ZDOTDIR/.zshrc_misc        ] && . $ZDOTDIR/.zshrc_misc
[ -f $ZDOTDIR/.zshrc_local       ] && . $ZDOTDIR/.zshrc_local
[ -f $ZDOTDIR/.zshrc_function    ] && . $ZDOTDIR/.zshrc_function
# vim:set ft=zsh:
