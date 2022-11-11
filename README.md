# Global hooks for pre-commit

## Introduction

Because the main developper of pre-commit does really not want to implement this feature,
there one smart way to got bypass this bug. The idea is to install a global config in your
`$HOME`, but the hooks will actually call a first time your global `pre-commit` config and
then a second time your project `pre-commit` config (if present). Simple smart, and not so bad
to install.


## Installation

It's better to have pre-commit installed at the system or user level:
```
pip install --user pre-commit
```

Clone this repo in your home config (you may want to fork it to keep a track of your config):
```
cd ~/.config/git
git clone https://github.com/mrjk/hooks-pre-commit.git hooks-pre-commit
```

Enable global hooks:
```
git config --global core.hooksPath $HOME/.config/git/hooks
```

Add your global hooks in this file:
```
vim ~/.config/git/hooks-pre-commit/.pre-commit-config.yaml
```

Update your global modules:
```
pre-commit autoupdate -c ~/.config/git/hooks-pre-commit/.pre-commit-config.yaml
```

## Tutorial

Let's create a global common config:
```
cat ~/.config/git/hooks-pre-commit/pre-commit-config.yaml

default_install_hook_types:
  - pre-commit

repos:
- hooks:
  - id: check-added-large-files
  - id: trailing-whitespace
  - id: end-of-file-fixer
  - id: fix-encoding-pragma
  repo: https://github.com/pre-commit/pre-commit-hooks
  rev: v4.3.0
```

Let's try to see how it works:
```
$ mkdir -p ~/tmp/test
$ cd ~/tmp/test
$ pre-commit run pre-commit
An error has occurred: FatalError: git failed. Is it installed, and are you in a Git repository directory?
Check the log at ~/.cache/pre-commit/pre-commit.log
```
Ok, normal so far, we are not in a git repo.

Let's make one:
```
$ git init .
Initialized empty Git repository in /home/jez/tmp/titi/.git/
```
And try to commit our file:
```
$ echo "world" > hello.txt
$ git add hello.txt
$ git commit -m "test commit" hello.txt
check for added large files..........................(no files to check)Skipped
trim trailing whitespace.............................(no files to check)Skipped
fix end of files.....................................(no files to check)Skipped
fix python encoding pragma...........................(no files to check)Skipped
On branch main
nothing to commit, working tree clean
```

However, you can't do this:
```
$ pre-commit run pre-commit
An error has occurred: InvalidConfigError:
=====> .pre-commit-config.yaml is not a file
Check the log at ~/.cache/pre-commit/pre-commit.log
```
Unless you create a pre-commit config for your project :) To use
precommit command don't forget to add the option `-c ~/.config/git/hooks-pre-commit/.pre-commit-config.yaml`
