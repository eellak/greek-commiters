#!/bin/bash

token="$1"
dir="$(pwd)"
limit=$(curl -s https://api.github.com/rate_limit \
             -H "Authorization: token ${token}" |
        jq '.resources.core.remaining')

## Create required dirs
mkdir -p user/repos user/contr user/info orgs/repos orgs/contr

source "${dir}/get_users.sh"

source "${dir}/get_users_repos.sh"

source "${dir}/get_repo_info.sh"
