# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git deno)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#

# # # # # # # # # # # # # # # # # # # # # # # # # # # #
#
# All my ZSH customization
#
# # # # # # # # # # # # # # # # # # # # # # # # # # # #

# Adds FZF to path from Vim plugins
export PATH=$PATH:~/.vim/plugged/fzf/bin
export PATH=~/Code/wellcar/bin:$PATH
export PATH="~/.deno/bin:$PATH"

# As per homebrew opnessl instructions:
#   For compilers to find openssl@1.1 you may need to set:
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"

#source $HOME/.rvm/scripts/rvm
if command -v rbenv &> /dev/null; then
  eval "$(rbenv init -)"
else
  echo "rbenv unavailable"
fi

# Because git started displaying in French, ...
alias git='LANG=en_GB git'

# Prefer nvim to vim, if present
if type nvim > /dev/null 2>&1; then
  echo 'vim mapped to neovim. The future is here.'
  alias vim='nvim'
fi

# Setup for nvm, node version manager
export NVM_DIR="$HOME/.nvm"
  [ -s "/usr/local/opt/nvm/nvm.sh" ] && \. "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Ensure my github SSH key is loaded
if [[ `ssh-add -L` != (*`cat ~/.ssh/github_rsa.pub`*) ]]
then
  echo "Adding missing github SSH key to keychain"
  ssh-add --apple-use-keychain ~/.ssh/github_rsa
fi

# Customize FZF default command, particularly to ignore
export FZF_DEFAULT_COMMAND="rg "\
"--files "\
"--follow "\
"--no-ignore-vcs "\
"--hidden "\
"-g \"!{**/node_modules/*,**/.git/*}\""

### Git Aliases

# Interactive rebase of all commits since branching
function ggra() {
  if [[ -n $(git branch | grep master | xargs) ]]
  then
    echo "Rebasing to master"
    git rebase -i $(git merge-base master HEAD)
  elif [[ -n $(git branch | grep main | xargs) ]]
  then
    echo "Rebasing to main"
    git rebase -i $(git merge-base main HEAD)
  else
    echo "Could not find master or main"
    return 1
  fi
}

# Checkout the repo trunk if it's either main or master
# I'm not sure if redirecting STDERR in this way is bad or
# not idiomatic, but it means that error messages are
# suppressed from the checkout commands.
function ggcm() {
  if ! (git checkout master 2>/dev/null)
  then
    if ! (git checkout main 2>/dev/null)
    then
      echo "\n*** No master or main branches. Use `git branch` to find the repo trunk. ***\n"
    fi
  fi
}

function ggpm() {
  local branch=`git branch --show-current`

  if [[ ${branch} == "master" ||  ${branch} == "main" ]]
  then
    git pull origin ${branch}
  else
    echo "Not on main/master branch"
    return 1
  fi
}

# Short form git pull origin <current branch>
alias ggpo="git pull origin \$(git branch --show-current)"

### JS aliases

# Yarn-based silent jest

alias yjs="yarn jest --silent"

### Kernel concerns

export KNL_HOME=$HOME/Code/kernel
export KNL_API=$KNL_HOME/liquid/api

function knldb() {
  cd $KNL_API

  docker compose -f docker-compose.yml up
  # To include pgadmin: -f ~/Code/my-system-settings/pg-admin.docker-compose.yml
}

function knldbdown() {
  cd $KNL_API

  docker compose -f docker-compose.yml down
  # To include pgadmin: -f ~/Code/my-system-settings/pg-admin.docker-compose.yml
}
### End Kernel concerns

alias dprune="docker image prune -f && docker container prune -f && docker network prune -f"
alias dpruneall="dprune && docker volume prune -f"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Code/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/Code/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/Code/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/Code/google-cloud-sdk/completion.zsh.inc"; fi
