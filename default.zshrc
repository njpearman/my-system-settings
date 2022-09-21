# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/neill/.oh-my-zsh"

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
export PATH=/Users/neill/Code/wellcar/bin:$PATH
export PATH="/Users/neill/.deno/bin:$PATH"

# As per homebrew opnessl instructions:
#   For compilers to find openssl@1.1 you may need to set:
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"

#source $HOME/.rvm/scripts/rvm
eval "$(rbenv init -)"

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

# Short form git pull origin <current branch>
alias ggpo="git pull origin \$(git branch --show-current)"

### Skiller Whale concerns

export SW_HOME=$HOME/Code/skillerwhale
export SW_APP=$SW_HOME/app
export SW_CURR=$SW_APP/curriculum
export SW_EXER=$SW_HOME/learner-exercises


function swgsu() {
  # In Xsh scripts, whitespace is not understood between an assignment
  local PULL="git pull"
  local UPDATE_SUBMODULES="git submodule update --remote --rebase"

  moveAndExecute "${PULL} && ${UPDATE_SUBMODULES}"
}

function swfmt() {
  local COMMAND="docker-compose run curriculum python scripts/standardise_all_markdown.py"

  moveAndExecute ${COMMAND}
}

function swvmm() {
  local COMMAND='docker-compose run curriculum pytest tests/teaching_content/test_module_content_validity.py'

  moveAndExecute ${COMMAND}
}

function swgmm() {
  local COMMAND='docker-compose exec curriculum python3 scripts/generate_module.py'

  if [[ -z $1 ]]
  then
    echo "A technology name is needed"
    return 1
  fi

  if [[ -z $2 ]]
  then
    echo "A curriculum name is needed"
    return 2
  fi

  if [[ -z $3 ]]
  then
    echo "A module name is needed"
    return 3
  fi

  moveAndExecute "${COMMAND} ${1} ${2} ${3}"
}

function moveAndExecute() {
  echo "Running '$1'\n...."
  if [[ `pwd` == $SW_APP ]]
  then
    eval $1
  else
    pushd $SW_APP
    eval $1
    popd
  fi
}

alias dprune="docker image prune -f && docker container prune -f && docker network prune -f"
alias dpruneall="dprune && docker volume prune -f"
