#!/bin/bash

CONTAINERS=$(docker ps -a | grep -E "spotify/kafka|$IMAGE_REPOSITORY" | awk '{ print $1 }')
echo "Containers: '$CONTAINERS'"
docker stop $CONTAINERS

IMAGES=$(docker images | grep "$IMAGE_REPOSITORY" | awk ' {print $1 ":" $2} ')
echo "Simulator images: '$IMAGES'"

docker rmi spotify/kafka
docker rmi $IMAGES
