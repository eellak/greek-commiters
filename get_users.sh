#!/bin/bash

## Get users usernames whose location is in Greece and save them to file

if ! [[ -f "user/users.txt" ]]
then
  for loca in Greece Athens Thessaloniki Patra Irakleio Larissa Patras Volos \
              Heraklion Rhodes Rodos Ioannina Chania Chalkis Chalkida Agrinio \
              Katerini Trikala Serres Lamia Alexandroupoli Kozani Kavala Veria \
              Athina Hellas Ellada
  do
#    for (( i=1; i<=2; i++ ))
#    do
      curl -s "https://api.github.com/search/users?q=repos:%3E4+location:${loca}&page=1&per_page=100" \
           -H "Authorization: token ${token}"
      curl -s "https://api.github.com/search/users?q=repos:%3E4+location:${loca}&page=2&per_page=100" \
           -H "Authorization: token ${token}"
#    done
  done |
    sed -n 's/.*"login": "\(.*\)",/\1/p' |
    sort -u > "user/users.txt"
fi

## Get more user info from previously created list
while read user                                                                 
do                                                                              
  if ! [[ -f "user/info/${user}.json" ]]
  then
    curl -s "https://api.github.com/users/${user}" \
         -H "Authorization: token ${token}" \
       > "user/info/${user}.json"
  fi
done < "user/users.txt"
