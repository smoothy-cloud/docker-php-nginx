#!/bin/bash

for dir in */ ; do
    image=`basename "$dir"`
    for subdir in $dir*/ ; do
        tag=$(echo `basename "$subdir"` | sed 's/\-/\./g')
        docker build --no-cache --tag smoothy/$image:$tag ./$subdir
        docker push smoothy/$image:$tag
    done
done