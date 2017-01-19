#!/bin/bash

token="$1"
dir="$(pwd)"

## Create required dirs
mkdir -p user/repos user/contr user/info orgs/repos orgs/contr

source "${dir}/get_users.sh"

source "${dir}/get_users_repos.sh"

source "${dir}/get_repo_info.sh"
