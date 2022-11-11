#!/usr/bin/env bash

# How to install
# cd ~/.config/git/hooks
# Copy this file into your ~/.config/git/hooks
# Symlink all hooks:
#   HOOKS=$(python  -c  'import pre_commit.constants as c ;print (" ".join(c.HOOK_TYPES));')
#   HOOKS="pre-commit pre-merge-commit pre-push prepare-commit-msg commit-msg post-commit post-checkout post-merge post-rewrite"
#   for i in $HOOKS ; do
#     echo ln -s forward-pre-commit.sh $i
#   done
# Enable global hooks:
#   git config --global core.hooksPath $HOME/.config/git/hooks
# All apps will be installed in home, unless if you specify as env var:
#  export PRE_COMMIT_HOME=$(git rev-parse --git-dir)/precommit
# Or with direnv:
#  export PRE_COMMIT_HOME=$(git rev-parse --show-toplevel)/.direnv/precommit


set -eu
#set -x
#echo "$0"
HOOK_NAME=${0##*/}
GLOBAL_CONFIG=$HOME/.config/git/hooks-pre-commit/.pre-commit-config.yaml
LOCAL_CONFIG=$(git rev-parse --show-toplevel)/.pre-commit-config.yaml


forward ()
{
  local hook_name=$1
  local config=$2
  shift 2

  # Skip if no config specified
  if [[ ! -f "$config" ]]; then
    echo "DEBUG: Skip hooks '$hook_name' because no config: $config"
    return
  fi

  # here="$(cd "$(dirname "$0")" && pwd)"
  local here="$(git rev-parse --git-dir)/hooks"
  local args=(hook-impl --config=$config --hook-type=$hook_name --hook-dir "$here" -- "$@")
  if command -v pre-commit > /dev/null; then
      echo pre-commit "${args[@]}"
      exec pre-commit "${args[@]}"
  else
      echo '`pre-commit` not found.  Did you forget to activate your virtualenv?' 1>&2
      exit 1
  fi
}

forward $HOOK_NAME $GLOBAL_CONFIG ${@-}
forward $HOOK_NAME $LOCAL_CONFIG ${@-}
