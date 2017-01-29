#!/bin/bash

#### Get users organisations and repos and save them to file "user/repos/${user}.json"

while read user ; do
  if ! [[ -f "user/repos/${user}.json" ]]
  then
    if (( ${limit} >= 2 ))
    then
### REPOS
      curl -s "https://api.github.com/users/${user}/repos" \
           -H "Authorization: token ${token}" \
         > "user/repos/${user}.json"
### ORGS
      curl -s "https://api.github.com/users/${user}/orgs" \
           -H "Authorization: token ${token}" \
        >> "user/repos/${user}.json"
      limit=$(( ${limit} - 2 ))
    else
      until (( $(curl -s https://api.github.com/rate_limit \
                      -H "Authorization: token ${token}" |
                 jq '.resources.core.reset') >=2 ))
      do
        sleep 10s
      done
      limit=$(curl -s https://api.github.com/rate_limit \
                   -H "Authorization: token ${token}" |
              jq '.resources.core.remaining')
    fi 
  fi
done < "user/users.txt"
