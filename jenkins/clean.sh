#!/bin/bash

docker stop $(docker ps -a | grep -E "spotify/kafka|$IMAGE_REPOSITORY" | awk '{ print $1 }')
docker rmi spotify/kafka
docker rmi $(docker images | grep "$IMAGE_REPOSITORY" | awk ' {print $1 ":" $2} ')
