#!/bin/bash 
on_kill() { 
  kill "$pid1" 
  kill "$pid2" 
  exit 
}

trap "on_kill" SIGINT 

dune build -w & 
pid1="$!" 
while read -r path; do 
    echo $path changed 
    if [ ! -z "$pid2" ] 
    then 
    echo "Killing $pid2" 
    kill $pid2 
    fi 
    sleep 1 # wait build finishes
    echo "Starting new server" 
    dune exe zero2prod & 
    pid2="$!"
    # https://stackoverflow.com/questions/28195821/how-can-i-interrupt-or-debounce-an-inotifywait-loop
    echo "Skipping $(timeout 2 cat | wc -l) further changes"
done < <(inotifywait -m ./_build/default/bin)
