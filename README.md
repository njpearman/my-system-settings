# my-system-settings
A repo containing files I use to configure my systems

## Global gitignore file

As far as I can tell, git does not read global gitignore files that are symbolic links.
This is slightly annoying, as I cannot just update the file in this repo and symlink it.

As a global config file, I want to have the system read the file from  `~/`.
Without being able to use symlinks, this means I have to copy the reference file from here to `~/` when I make changes.

I could configure git to look for the global gitignore within this repo but I'm not comfortable with that approach.


