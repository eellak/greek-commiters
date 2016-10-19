#!/bin/sh
#

for loca in Greece Athens Thessaloniki Patra Irakleio Larissa Patras Volos Heraklion Rhodes Rodos Ioannina Chania Chalkis Chalkida Agrinio Katerini Trikala Serres Lamia Alexandroupoli Kozani Kavala Veria Athina Hellas Ellada
do
    curl -s -H 'Authorization: token b9fd7c3fb49adf68960d8302318454eb76fe1bcf' 'https://api.github.com/search/users?per_page=100&q=followers:%3E10+location:'$loca
    curl -s -H 'Authorization: token b9fd7c3fb49adf68960d8302318454eb76fe1bcf' 'https://api.github.com/search/users?per_page=100&q=repos:%3E5+location:'$loca
done |
sed -n 's/.*"login": "\(.*\)",/\1/p' |
sort -u >users.txt

while read user
do
  curl -s -H 'Authorization: token b9fd7c3fb49adf68960d8302318454eb76fe1bcf' curl -s 'https://api.github.com/users/'$user
done < users.txt > users.json
