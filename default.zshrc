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
plugins=(git)

source $ZSH/oh-my-zsh.sh
echo "Oh my zsh'd"

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

# Prefer local bin to /usr/bin
export PATH=/usr/local/bin:$PATH
# Adds FZF to path from Vim plugins
export PATH=$PATH:~/.vim/plugged/fzf/bin
export PATH=~/Code/wellcar/bin:$PATH
export PATH="~/.deno/bin:$PATH"

# Ruby concerns
export GEM_HOME="$HOME/.gem"

# End ruby concerns

# Sets up homebrew, including PATH for things like ripgrep and neovim
eval "$(/opt/homebrew/bin/brew shellenv)"
echo "Set up homebrew"

# As per homebrew opnessl instructions (disabled as this broke my `rbenv install` attempt)
#   For compilers to find openssl@1.1 you may need to set:
# export LDFLAGS="-L/opt/homebrew/openssl@1.1/lib"
# export CPPFLAGS="-I/opt/homebrew/openssl@1.1/include"

#source $HOME/.rvm/scripts/rvm
if command -v rbenv &> /dev/null; then
  eval "$(rbenv init -)"
else
  echo "rbenv unavailable"
fi

export PYENV_ROOT="$HOME/.pyenv"

# Because git started displaying in French, ...
alias git='LANG=en_GB git'


# Setup for nvm, node version manager
export NVM_DIR="$HOME/.nvm"
  [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

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

# Project-specific set up
if [ -f "./.projectsrc" ]; then
  source "./.projectsrc"
  echo "Loaded private commands and things for your projects"
else
  echo "No projects file to source"
fi

alias dprune="docker image prune -f && docker container prune -f && docker network prune -f"
alias dpruneall="dprune && docker volume prune -f"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Code/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/Code/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/Code/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/Code/google-cloud-sdk/completion.zsh.inc"; fi

# Prefer nvim to vim, if present
if type nvim > /dev/null 2>&1; then
  echo 'vim mapped to neovim. The future is here.'
  alias vim='nvim'
else
  local NVIM_TYPE=`type nvim`
  echo "Unable to find nvim...${NVIM_TYPE}"
fi

PATH="$(bash --norc -ec 'IFS=:; paths=($PATH); 

for i in ${!paths[@]}; do 
if [[ ${paths[i]} == "''/Users/neill/.pyenv/shims''" ]]; then unset '\''paths[i]'\''; 
fi; done; 
echo "${paths[*]}"')"
export PATH="/Users/neill/.pyenv/shims:${PATH}"
export PYENV_SHELL=zsh
export PYENV_ENV_VERSION=$(pyenv --version | awk '{print $2}')
echo "Pyenv version ${PYENV_ENV_VERSION}"
source "/opt/homebrew/Cellar/pyenv/${PYENV_ENV_VERSION}/completions/pyenv.zsh"
command pyenv rehash 2>/dev/null
pyenv() {
  local command
  command="${1:-}"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(pyenv "sh-$command" "$@")"
    ;;
  *)
    command pyenv "$command" "$@"
    ;;
  esac
}
