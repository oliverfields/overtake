# overtake - a pass like client

Overtake is a CLI client for managing a vault containing secrets. The vault is a regular directory tree containing gpg encrypted files and directories. It is inspired by [pass](https://www.passwordstore.org/).


## But, why?

- Secrets are encrypted using GPG
- Editing secrets is done entierly in memory, nothing is written to disk (requires vim)
- Automatic pull and push to remote git repos
- Create new files populated with output from a bash script
- A TUI for managing the vault based on the excellent [fzf](https://github.com/junegunn/fzf)


## Installation

1. Either `git clone` or download from github. This guide assumes overtake is located at `~/.local/overtake`
2. Create vault directory `mkdir ~/.secrets`
3. Create config file `cp ~/.local/overtake/overtake.conf .config/overtake.conf`
4. Edit `overtake.conf` so **recipients** matches your GPG Key ID, you can add multiple recipients by separating them with a space. See [Creating a GPG key](#creating-a-gpg-key) if you do not already have one
5. If you want bash completion typically symlink to wherever your distro looks for bash completion scripts e.g. `ln -s ~/.local/overtake/_overtake_completion /etc/bash_completion.d/overtake_completion`. Or, maybe source it in a startup script `echo '. ~/.local/overtake/_overtake_completion' >> ~/.profile`
6. Make sure `overtake` and `overtake-tui` are in your PATH. Perhaps symlink them to `~/.local/bin`

Some commands to try.

- `overtake-tui`
- Create a new encrypted file in the vault `overtake add <name>`
- Decrypt file and copy to clipboard `overtake copy <name>`
- List secrets `overtake list`, the arguments `--full` and `--tree` change the list output


# GPG

GPG is a large field, that is worth reading up on as it is central to using overtake, but please look elsewhere for more worthwhile gpg enlightenment.

## Creating a GPG key

There are many ways to do this, including generating keys on an air gapped device, but for testing you can try this [gnupg.org guide](https://www.gnupg.org/gph/en/manual/c14.html).

## GPG recipients

Under the hood overtake uses gpg to encrypt and decrypt files. When encrypting it is necassary to specify what gpg keys can decrypt the file. To do this the public key of each recipient must be added to gpg and trusted. A recipient can be specified using the key id, or usually, by email address(called user name in gpg). 

GPG recipients can be spesified in the following ways.

* Space separated list either set by environment variable or in `overtake.conf` setting named **recipients**, these recipients will be applied to all keys in vault
* Specified one recipients per line in `.gpg-id`. These files can be set anywhere in the vault, and the recipients are applied in addition to **recipients** and environment variable **OVERTAKE_DEFAULT_RECIPIENTS**, for all keys in the current directory and below. If a new `.gpg-key` file is found, its recipients will be used instead

Consider this example using the following setup:

The setting `recipients=me@my.tld` is set in `overtake.conf` and the vault directory is set up as follows.

```
~/.secrets
├── personal
│   └── github-user.gpg
└── team
    ├── admin.gpg
    └── .gpg-id
```

The file `.gpg-id` content is:

```
jake@co.tld
lucy@co.tld
```

In this case `github-user.gpg` will be decryptable by gpg public key **me@my.tld**, whilst `admin.gpg` will be decryptable by **me@my.tld**, **jake@co.tld** and **lucy@co.tld**.


## Git

Overtake tries to make git integration work seamlessly behind the scenes. Setup git syncing as follows.

1. Edit `overtake.conf` and uncommment/add `git_sync=yes`
2. Make sure `~/.secrets` is a git repository, e.g. `git init`, or `git clone` it from somewhere

Now any add, edit or delete will update the file and do git add & commit the change. If the git repository has a remote a `git pull` will be run prior to file update, and finally `git push` will sync changes back to remote repo.


### Multiple git repos

Overtake can support keeping multiple git repos synced. This is done by cloning the desired git repos into the vault directory and ensuring the repos ignore each other using .gitignore.

Assume we have one git repo for the vault, but also want to include secrets from a second git repo. This could be setup as such.

```
  git clone <main vault repo> ~/.secrets
  cd ~/.secrets
  git clone <shared vault repo> shared
```

The directory structure will look like so.

```
~/.secrets
├── .git
└── shared
    └── .git
```

Now edit `~/.secrets/.gitignore` and add a line containing `/shared/`, so the `<main vault repo>` ignores the `<shared vault repo>`.

When overtake modifies the vaults it will also keep both git repos synced automatically.








