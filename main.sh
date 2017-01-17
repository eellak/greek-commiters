#!/bin/bash

token="$1"
dir="$(pwd)"

## Create required dirs
mkdir -p user/repos user/contr user/info orgs/repos orgs/contr

. "${dir}/get_users.sh"

. "${dir}/get_users_repos.sh"

. "${dir}/get_repo_info.sh"
