case $- in
    *i*) ;;
      *) return;;
esac

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s checkwinsize

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
[ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ] && debian_chroot=$(cat /etc/debian_chroot)

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

#begin aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias untar='tar -zxf'
alias st='git status'
alias view_disks='sudo fdisk -l'
alias watch_interrupts='watch -n 1 -d cat /proc/interrupts'
[ $(which git) ] && alias st='git status'
[ $(which xfce4-terminal) ] && alias terminal='xfce4-terminal' || [ $(which xterm) ] && alias terminal='xterm' || [ $(which gnome-terminal) ] && alias terminal='gnome-terminal' || alias terminal='x-terminal-emulator'
#endof aliases

function list() {
  find . | grep $1
}; alias list='list';

function o() {
  list $1 | while read filepath; do
    echo "opening: $filepath"
    terminal --tab --title="$filepath" --command="vim $filepath"
  done
}; alias o='o';

function background() {
  $@ > /dev/null 2>&1 &
}; alias background='background';

function keyword() {
  grep -rnw "$1" --include=*.{cpp,c,hpp,h,GNU,bash} --exclude=*.{svn-base,a} ./
}; alias keyword='keyword';

function slink() {
  if [ "" != "$1" ] && [ "as" == "$2" ] && [ "" != "$3" ] ; then
    path="$1"
    alias="$3"
  else
    echo "[path] as [alias]" && exit 1
  fi
  ln -sf $path $alias
}; alias slink='slink';

function find_process() {
  ps aux | grep -i "$1"
}; alias find_process='find_process';

function linecount() {
  wc -l < "$1"
}; alias linecount='linecount';

export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

mkdir -p ~/.state
[ ! -f ~/.state/PS1 ] && touch ~/.state/PS1 && echo "time_and_path" > ~/.state/PS1
function PS1_update_prompt() {
 local PS1state=$(<~/.state/PS1)
 [ path == $PS1state ] && PS1='${debian_chroot:+}[\[\033[01;34m\]\w\[\033[00m\]] ' 
 [ time_and_path == $PS1state ] && PS1='${debian_chroot:+}[\t] [\[\033[01;34m\]\w\[\033[00m\]] ' 
 [ all == $PS1state ] && PS1='${debian_chroot:+}[\t] \[\033[01;32m\]\u@\h\[\033[00m\] [\[\033[01;34m\]\w\[\033[00m\]] '
};
function _more_() {
  local PS1state=$(<~/.state/PS1)
  [ path == $PS1state ] && echo "time_and_path" > ~/.state/PS1
  [ time_and_path == $PS1state ] && echo "all" > ~/.state/PS1
  PS1_update_prompt
}; alias _more_='_more_';
function _less_() {
  local PS1state=$(<~/.state/PS1)
  [ all == $PS1state ] && echo "time_and_path" > ~/.state/PS1
  [ time_and_path == $PS1state ] && echo "path" > ~/.state/PS1
  PS1_update_prompt
}; alias _less_='_less_';
PS1_update_prompt
