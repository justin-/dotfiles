# rvm
PATH=$PATH:$HOME/.rvm/bin
source ~/.rvm/scripts/rvm

# aliases
alias z="zeus"
alias shutdown="sudo shutdown -P now"
alias reboot="sudo shutdown -r now"
alias fresh="sudo apt-get update && sudo apt-get -y upgrade"

# Git and RVM prompting (https://gist.github.com/todb/2555109)
function git-current-branch {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1) /'
}
export PS1="[\$(~/.rvm/bin/rvm-prompt v p g)] \$(git-current-branch)$PS1"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
