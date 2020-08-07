#!/bin/bash
set -ex

# Set up ssh known hosts and agent
ssh-keyscan -t rsa github.com >> /etc/ssh/ssh_known_hosts
eval `ssh-agent -s`
ssh-add - <<< "$SSH_PRIVATE_KEY"

# split single parameter of this script into multiple params for the command
eval "set -- $1"
git-filter-repo "$@"

git push "git@github.com:$TARGET_ORG/$TARGET_REPO.git" HEAD:"$TARGET_BRANCH"
