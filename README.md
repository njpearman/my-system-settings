# my-system-settings
A repo containing files I use to configure my systems

## Installing Vim plug-ins

Note that I map neovim to `vim`, hence the vim-ish refs below.

The documentation in the junegunn/vim-plug repo is either incomplete, out of date or incompatible with how I use Vim.

In order to fully set up Neovim to use vim-plug:

1. Run the install instructions in the repo Readme:
```
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```
2. Create a symlink of `default.vimrc` to `.config/nvim/init.vim`
```
mkdir -p ~/.config/nvim
ln -s default.vimrc ~/.config/nvim/init.vim`
```
3. Create a symlink of `vim-config` to `.vim/custom`
```
mkdir ~/.vim
ln -s vim-config ~/.vim/custom
```
4. Launch vim, install the plugins with `:PlugInstall` then close and relaunch vim.

## VS Code / Cursor

The repo contains a list of useful extensions that can be executed with a shell, e.g. `bash extensions.vscode` or `zsh extensions.vscode`.
Note that it requires the `code` CLI command to be installed and available.

## Global gitignore file

As far as I can tell, git does not read global gitignore files that are symbolic links.
This is slightly annoying, as I cannot just update the file in this repo and symlink it.

As a global config file, I want to have the system read the file from  `~/`.
Without being able to use symlinks, this means I have to copy the reference file from here to `~/` when I make changes.

I could configure git to look for the global gitignore within this repo but I'm not comfortable with that approach.


