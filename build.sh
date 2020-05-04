#!/bin/bash

for dir in */ ; do
    image=`basename "$dir"`
    for subdir in $dir*/ ; do
        tag=`basename "$subdir"`
        docker build --tag smoothy/$image:$tag ./$subdir
        docker push smoothy/$image:$tag
    done
done