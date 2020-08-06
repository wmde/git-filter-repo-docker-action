# git-filter-repo-docker-action
A GitHub Docker Action to run git-filter-repo and push the result to a GitHub repository using ssh

This repo contains a github action to trigger a custom git-repo-filter command.

It is designed to be run on pushes to the main or master branch of a repository
and to then push the resulting filtered repo to another remote using an ssh key.

# Example Workflow
```
name: CI
on:
  push:
    branches: [ master ]

jobs:
  filter:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
      with:
        fetch-depth: 0
    - name: git-filter-repo
      id: filter
      uses: wmde/git-filter-repo-docker-action@v1
      with:
        privateKey: ${{ secrets.SSH_PRIVATE_KEY }}
        targetOrg: wikimedia
        targetRepo: wikibase-changes
        targetBranch: main
        filterArguments: >-
          --path=lib/includes/changes/
          --path=lib/includes/Changes/
          --path=lib/tests/phpunit/changes/
          --path=lib/tests/phpunit/Changes/
          --path lib/packages/wikibase/changes/
          --path .mailmap
          --path-rename=lib/includes/changes:src
          --path-rename=lib/includes/Changes:src
          --path-rename=lib/tests/phpunit/changes:tests
          --path-rename=lib/tests/phpunit/Changes:tests
          --path-rename lib/packages/wikibase/changes/:
          --message-callback 'return re.sub(b"^changes: ", b"", message)'
```
