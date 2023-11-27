# overtake - a pass like client

Overtake is a CLI client for managing gpg encrypted files in a directory hiearchy. It is inspired by [pass](https://www.passwordstore.org/) and works out of the box with your existing **pass** `.password-store` directory.


## But, why?

- Editing passwords is done entierly in memory, nothing is written to disk
- Automatic sync with remote git repo
- File selection using [fzf](https://github.com/junegunn/fzf)
- Create new files populated with output from a bash script


## Installation

1. Either `git clone` or download from github. This guide assumes overtake is located at `~/.local/overtake`
2. Create password store directory `mkdir ~/.password-store`, if you already have this and use it with `pass`, it will work just fine
3. Create config file `cp ~/.local/overtake/overtake.conf .config/overtake.conf`
4. Edit `overtake.conf` so **OVERTAKE_DEFAULT_RECIPIENTS** matches your GPG Key ID, you can add multiple recipients by separating them with a space. See [Creating a GPG key](#creating-a-gpg-key) if you do not already have one
5. If you want bash completion typically symlink to wherever your distro looks for bash completion scripts e.g. `ln -s ~/.local/overtake/overtake_completion /etc/bash_completion.d/overtake_completion`. Or, maybe source it in a startup script `echo '. ~/.local/overtake/overtake_completion' >> ~/.profile`

Some commands to try.

- Create a new encrypted file in the password store `overtake add <name>`
- Decrypt file and copy to clipboard `overtake copy <name>`
- List passwords `overtake list`, the arguments `--full` and `--tree` change the list output


# GPG

GPG is a large field, that is worth reading up on as it is central to using overtake, but please look elsewhere for more worthwhile gpg enlightenment.

## Creating a GPG key

There are many ways to do this, including generating keys on an air gapped device, but for testing you can try this [gnupg.org guide](https://www.gnupg.org/gph/en/manual/c14.html).

## GPG recipients

Under the hood overtake uses gpg to encrypt and decrypt files. When encrypting it is necassary to specify what gpg keys can decrypt the file. To do this the public key of each recipient must be added to gpg and trusted. A recipient can be specified using the key id, or usually, by email address(called user name in gpg). 

GPG recipients can be spesified in the following ways.

* Space separated list either set by environment variable or in `overtake.conf` setting named **OVERTAKE_VAULT_DEFAULT_RECIPIENTS**, these recipients will be applied to all keys in password store. To be compatible with **pass**, environment variable or config setting **OVERTAKE_VAULT_KEY** can also be used in the same way
* Specified one recipients per line in `.gpg-id`. These files can be set anywhere in the password store, and the recipients are applied in addition to **OVERTAKE_VAULT_DEFAULT_RECIPIENTS** and **OVERTAKE_VAULT_KEY**, for all keys in the current directory and below. If a new `.gpg-key` file is found, its recipients will be used instead

Consider this example using the following setup:

The setting `OVERTAKE_DEFAULT_RECIPIENTS=me@my.tld` is set in `overtake.conf` and the vault directory is set up as follows.

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

1. Edit `overtake.conf` and uncommment/add `GIT_SYNC=yes`
2. Make sure `~/.secrets` is a git repositorye, e.g. `git init`, or `git clone` it from somewhere

Now any add, edit or delete will update the file and do git add & commit the change. If the git repository has a remote a `git pull` will be run prior to file update, and finally `git push` will sync changes back to remote repo.


### Multiple git repos

Overtake can support keeping multiple git repos synced. This is done by cloning the desired git repos into the password store directory and ensuring the repos ignore each other using .gitignore.

Assume we have one git repo for the password store, but also want to include passwords from a second git repo. This could be setup as such.

```
  git clone <main password store repo> ~/.password-store
  cd ~/.password-store
  git clone <shared password store repo> shared
```

The directory structure will look like so.

```
~/password-store
├── .git
└── shared
    └── .git
```

Now edit `~/.password-store/.gitignore` and add a line containing `/shared/`, so the `<main password store repo>` ignores the `<shared password store repo>`.

When overtake modifies the password store it will also keep both git repos synced automatically.








