###############  Variables  ######################

# Colors
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
LIME_YELLOW=$(tput setaf 190)
POWDER_BLUE=$(tput setaf 153)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
BRIGHT=$(tput bold)
NORMAL=$(tput sgr0)
BLINK=$(tput blink)
REVERSE=$(tput smso)
UNDERLINE=$(tput smul)

###############  P10K  ###########################

ZSH_THEME="powerlevel10k/powerlevel10k"
# To customize prompt, run `p10k configure` or edit $HOME/.p10k.zsh.
[[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


###############  OMZ  ############################

# Oh-My-Zsh updates
zstyle ':omz:update' mode auto      # update automatically without asking
zstyle ':omz:update' frequency 14

# Uncomment the following line if pasting URLs and other text is messed up.
DISABLE_MAGIC_FUNCTIONS="true"

# Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Command execution time shown in the history command output.
HIST_STAMPS="dd.mm.yyyy"

# Ugly, but pyenv needs to be loaded before loading the corresponding OMZ plugin
eval "$(pyenv init --path)"

# Plugins
plugins=(
  pass
  pip
  pyenv
  emoji
  dotenv
  pip
  pyenv
  git
  git-extras
  archlinux
  zsh-autosuggestions
  zsh-vi-mode
)

# Path to the oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

source $ZSH/oh-my-zsh.sh

###############  Path Extensions  ################

path+=("$HOME/.local/bin")

export PATH

###############  System Utils  ###################

###############  Bluetooth  ######################

alias blue="bluetoothctl connect"
alias blued="bluetoothctl disconnect"

function bluer {
  sudo systemctl restart bluetooth
  sleep 0.3
  blue $(history | grep '  blue [29CE]' | tail -1 | sed 's/.*  blue //')
}

###############  Beauty  #########################

alias rsyncp="rsync -ah --info=progress2 --no-i-r"

alias cat='bat --style header --style rules --style snip --style changes --style header'

alias ls='exa -l --color=always --group-directories-first --icons' # preferred listing
alias la='exa -la --color=always --group-directories-first --icons'  # all files and dirs
alias lt='exa -aT --color=always --group-directories-first --icons' # tree listing
alias l.="exa -a | egrep '^\.'"

export MANPAGER="sh -c 'col -bx | bat -l man -p'"

###############  VI MODE  ########################

# vi mode
bindkey -v
export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select {
if [[ ${KEYMAP} == vicmd ]] ||
  [[ $1 = 'block' ]]; then
  echo -ne '\e[2 q'
elif [[ ${KEYMAP} == main ]] ||
  [[ ${KEYMAP} == viins ]] ||
  [[ ${KEYMAP} = '' ]] ||
  [[ $1 = 'beam' ]]; then
  echo -ne '\e[6 q'
fi
}
zle -N zle-keymap-select
zle-line-init() {
zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
echo -ne "\e[6 q"
}
zle -N zle-line-init
echo -ne '\e[6 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[6 q' ;} # Use beam shape cursor for each new prompt.

###############  SPEED  ##########################

bindkey "^[[A" history-beginning-search-backward
bindkey "^[[B" history-beginning-search-forward
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

# Execute current suggestion with ctrl+j, accept with ctrl-l
bindkey "^l" autosuggest-accept
bindkey "^j" autosuggest-execute

# Open files easily
function o {
  mimeopen -n $@ >/dev/null 2>/dev/null &
  disown
}

# Sorted du
alias dus="du -hs $@ | sort -h"
alias dusl="du -hs * | sort -h"

# Translation
function tl {
  tmp="$@"; trans "$tmp"
}

# Enable z.lua fast cd
eval "$(lua $HOME/.local/share/z.lua/z.lua --init zsh)"

# Copying and pasting from command line
alias c="xclip -sel c <"
alias v="xclip -sel c -o >"

# Run vifm with image and video preview support
alias vifm="$HOME/.local/bin/vifmrun"

# Fast tree
alias t="tree -C -a --dirsfirst"

# ls after cd
function cl {
  new_directory="$*";
  if [ $# -eq 0 ]; then
    new_directory=${HOME};
  fi;
  builtin cd "${new_directory}" && t -L 2
}

# find things
function f {
  tmp="$@"; sudo find / -iname "*$tmp*" -exec ls --color -d {} \;
}

function fl {
  tmp="$@"; find . -iname "*$tmp*" -exec ls --color -d {} \;
}

alias i="ipython --no-confirm-exit"
alias v="nvim"

alias pc="pass -c"
alias poc="pass otp -c"

alias vime="nvim $HOME/.config/nvim/init.vim"
alias vimed="nvim $HOME/.config/nvim/"
alias vimep="nvim $HOME/.config/nvim/vim-plug/plugins.vim"
alias vimec="nvim $HOME/.config/nvim/coc-settings.json"

alias vifme="nvim $HOME/.config/vifm/vifmrc"

alias zshe="nvim $HOME/.zshrc; zsh"

alias xinite="sudo nvim $HOME/.xinitrc"

alias gu="git add -u; git commit -m \"$@\"; git push"
alias gul="git add -u; git commit-status; git push"
alias gcos="git commit-status"

function s {
  pathpattern="."
  for substr in "$@"
  do
    pathpattern+="/*$substr*"
  done
  pathres=$(find . -maxdepth $# -type d -ipath "$pathpattern" | head -n 1)
  if [[ $pathres != "" ]]; then
    cd "$pathres"
    t -L 2
  fi
}

###############  University  #####################

function clean_course {
  echo "$1" | sed 's/\[//g; s/\]//g'
}

function u {
  WORK_DIR=/home/matteo/Sync/University
  ISISDL_DIR=/home/matteo/Isis/Courses
  unset COURSE
  unset COURSE_CLEAN
  argc=${#1}
  course=${1:0:1}
  subdir=${1:1:1}

  if [[ $argc -ge 3 ]]; then
    exercise_num=${1:2:$(( $argc - 2 ))}
  else
    exercise_num=0
  fi


  case $course in
    c* )
      COURSE='CognitiveAlgorithms' ;;
    C* )
      COURSE='SoSe21CognitiveAlgorithms' ;;
    d* )
      COURSE='DigitalImageProcessingWS2122' ;;
    i* )
      COURSE='WS21InformationGovernance' ;;
    B* )
      COURSE='WS2021Betriebssystempraktikum' ;;
    b* )
      COURSE='WS2122Betriebssystempraktikum' ;;
    M* )
      COURSE='WiSe2021MachineLearning1' ;;
    m* )
      COURSE='WiSe2122MachineLearning1' ;;
  esac

  COURSE_CLEAN=$(clean_course $COURSE)

  case $argc in
    1 )
      cl "$ISISDL_DIR/$COURSE/" ;;
    2 )
      case $subdir in
        s )
          cl "$WORK_DIR/$COURSE_CLEAN/Solutions/" ;;
        v )
          cl "$ISISDL_DIR/$COURSE/Videos/" ;;
        *)
          cl "$ISISDL_DIR/$COURSE/"
      esac
      ;;
    [34] )
      cl $(find $WORK_DIR/$COURSE_CLEAN/Solutions -maxdepth 1 -type d -name "*$exercise_num" | head -n 1)
      ;;
    *)
      cl $ISISDL_DIR/$COURSE
      ;;
  esac
}

function jl {
  jupyter-lab $1
}

function jn {
  jupyter notebook $1
}

###############  VPN  ############################

# Connect to the VPN of Technische Universität Berlin
# alias vpnt='openconnect https://vpn.tu-berlin.de/ -b'
function vpnt {
  pnotify "Connecting to the VPN of Technische Universität Berlin ..."
  vpnnd >/dev/null
  sudo openconnect https://vpn.tu-berlin.de/ -q -b -u matteo
  updatei3bip
}

# Disconnect from the VPN of Technische Universität Berlin
function vpntd {
  sudo pkill openconnect
  updatei3bip
}

# Connect to the VPN of NordVPN
function vpnn {
  pnotify "Connecting to NordVPN ..."
  if [[ $(pidof openconnect >/dev/null && echo $?) == 0 ]]; then
    vpntd >/dev/null
  fi
  if [[ $(systemctl status nordvpnd) != *"active (running)"* ]]; then
    sudo systemctl enable nordvpnd
  fi
  if [[ $(nordvpn connect) == *"not logged in"* ]]; then
    nordvpn login
  fi
  nordvpn connect $@
  updatei3bip
}

# Disconnect from NordVPN
function vpnnd {
  nordvpn disconnect
  updatei3bip
}

###############  Raspberry  ######################

###############  Exports  ########################

# To enable importing gpg keys via qr codes
# See: https://wiki.archlinux.org/title/Paperkey
export EDITOR=nvim

# Make gpg work, check `man gpg-agent`
export GPG_TTY=$TTY

###############  R  ##############################

R_LIBS=$HOME/.local/share/R/lib/
export R_LIBS

###############  Python  #######################

alias activate="source *_env/bin/activate"

export PYENV_VIRTUALENV_DISABLE_PROMPT=1

###############  Deep Learning  ##################

function csv_to_unix {
  tr -d '"\15\32' < $1 > unix_$1
}

###############  Last minute  ####################

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
