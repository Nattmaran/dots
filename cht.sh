#! /bin/env bash

languages=`echo "golang c java python js bash" | tr ' ' '\n'`

printf "%s\n" $languages

selected=`printf "%s\n" $languages | fzf`

read -p "query: " query
tmux neww bash -c "curl https://cht.sh/$selected/`echo $query | tr ' ' '+'` & while [ : ]; do sleep 1; done"
