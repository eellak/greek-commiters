#!/bin/bash

#### Get users contributions in his own repos and joined organisations

while read user
do
    sum=0
## Get more info about each users repo and save it to file
    if ! [[ -f "user/contr/${user}.json" ]]
    then
        for repo in $(sed -n 's/.*"full_name": "\(.*\)",/\1/p' \
                      "user/repos/${user}.json")
        do
            curl -s "https://api.github.com/repos/${repo}/contributors" \
                 -H "Authorization: token ${token}"
        done > "user/contr/${user}.json"
    fi
## Get contributions sum of each user in their own repos
    for num in $(jq "map(select(.login | contains (\"${user}\")))" \
                  < "user/contr/${user}.json" |
                 sed -n 's/.*"contributions": \(.*\)/\1/p')
    do
        sum=$(( ${sum} + ${num} ))
    done
### Loop over all organisations of each user
    for org in $(sed -n -e 's/.*"login": "\(.*\)",/\1/p' \
                 "user/repos/${user}.json" |sed "/${user}$/d")
    do
        if ! [[ -f "orgs/repos/${org}.json" ]]
        then
        ## Get repos of users organizations
            curl -s "https://api.github.com/users/${org}/repos" \
                 -H "Authorization: token ${token}" \
              > "orgs/repos/${org}.json"
        ## Get more info on users repos of each organization
            for repo in $(sed -n 's/.*"full_name": "\(.*\)",/\1/p' \
                          "orgs/repos/${org}.json")
            do
                curl -s "https://api.github.com/repos/${repo}/contributors" \
                     -H "Authorization: token ${token}"
            done > "orgs/contr/${org}.json"
        fi
       ## Make a sum of each users contributions in each organization repo
        for num in $(jq "map(select(.login | contains (\"${user}\")))" \
                      < "orgs/contr/${org}.json" |
                     sed -n 's/.*"contributions": \(.*\)/\1/p')
        do
            sum=$(( ${sum} + ${num} ))
        done
    done
### End organization loop
      echo "${sum}, ${user}"
done < "user/users.txt" |
  sort -u |
  sort -n > "sum_contr.txt"
