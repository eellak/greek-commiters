#!/bin/bash

#### Get users organisations and repos and save them to file "user/repos/${user}.json"

while read user ; do
    if ! [[ -f "user/repos/${user}.json" ]]
    then
## REPOS
        curl -s "https://api.github.com/users/${user}/repos" \
             -H "Authorization: token ${token}" \
          > "user/repos/${user}.json"
## ORGS
        curl -s "https://api.github.com/users/${user}/orgs" \
             -H "Authorization: token ${token}" \
          >> "user/repos/${user}.json"
    fi
done < "user/users.txt"
