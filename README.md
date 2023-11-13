# overtake - a pass client

Overtake is a CLI client for managing gpg encrypted files in a directory hiearchy. It is inspired by [pass](https://www.passwordstore.org/) and works out of the box with your existing **pass** `.password-store` directory.


## But, why?

- Editing passwords is done entierly in memory, nothing is written to disk'
- Automatic sync with remote git repo
- File selection using fzf
- Create new files populated with output from a bash script


## Installation

1. Either `git clone` or download from github. This guide assumes overtake is located at `~/.local/overtake`
2. Create password store directory `mkdir ~/.password-store`, if you already have this and use it with `pass`, it will work just fine
3. Create config file `cp ~/.local/overtake/overtake.conf .config/overtake.conf`
4. Edit `overtake.conf` so **PASSWORD_STORE_KEY** matches your GPG Key ID. See [Creating a GPG key](#CreatingAGPGKey) if you do not already have one
5. If you want bash completion typically symlink to wherever your distro looks for bash completion scripts e.g. `ln -s ~/.local/overtake/overtake_completion /etc/bash_completion.d/overtake_completion`. Or, maybe source it in a startup script `echo '. ~/.local/overtake/overtake_completion' >> ~/.profile`

Some commands to try.

- Create a new encrypted file in the password store `overtake add <name>`
- Decrypt file and copy to clipboard `overtake copy <name>`
- List passwords `overtake list`, the arguments `--full` and `--tree` change the list output


## Setup git syncing

1. Edit `overtake.conf` and uncommment/add `GIT_SYNC=yes`
2. Make sure `~/.password-store` is a git repositorye, e.g. `git init`, or `git clone` it from somewhere

Now any add, edit or delete will update the file and do git add & commit the change. If the git repository has a remote a `git pull` will be run prior to file update, and finally `git push` run at the end.

<a name="Creating a GPG key"></a>
## Creating a GPG key

There are many ways to do this, including generating keys on an air gapped device, but for testing you can try this [gnupg.org guide](https://www.gnupg.org/gph/en/manual/c14.html).











