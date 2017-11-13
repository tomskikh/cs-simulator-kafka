#!/bin/bash -e

export KAFKA_PORT=9092
export KAFKA_TOPIC=cs
KAFKA_ACKS=all
KAFKA_WRITE_RETRIES=1

export SIMULATOR_PORT=8888

export KAFKA_CONTAINER_ID=$(docker run -d --rm --tty=true -p 2181:2181 -p $KAFKA_PORT:$KAFKA_PORT --env ADVERTISED_HOST=$KAFKA_HOST --env ADVERTISED_PORT=$KAFKA_PORT spotify/kafka)

TAG=`cat version`

IMAGE_REPOSITORY_WITH_TAG=$IMAGE_REPOSITORY:$TAG

docker build -t build-simulator-core --target=build-simulator-core .

docker build -t $IMAGE_REPOSITORY_WITH_TAG .

docker run --rm -e KAFKA_HOST="${KAFKA_HOST}" \
                -e KAFKA_PORT="${KAFKA_PORT}" \
                -e KAFKA_ACKS="${KAFKA_ACKS}" \
                -e KAFKA_TOPIC="${KAFKA_TOPIC}" \
                -e KAFKA_WRITE_RETRIES="${KAFKA_WRITE_RETRIES}" \
                --name cloudstack-kafka -d -p $SIMULATOR_PORT:$SIMULATOR_PORT $IMAGE_REPOSITORY_WITH_TAG

echo "-------------------- Integration tests --------------------"

sh ./tests/integration_tests.sh

echo "git branch: $GIT_BRANCH"
if [ -n "$GIT_BRANCH" ]; then
    if [ "$GIT_BRANCH" = "origin/master" ]; then

	docker login -u="$USERNAME" -p="$PASSWORD"

	NAME_FOR_PUSH=$USERNAME/$IMAGE_REPOSITORY_WITH_TAG

	docker tag $IMAGE_REPOSITORY_WITH_TAG $NAME_FOR_PUSH

	docker push $NAME_FOR_PUSH

	docker logout

	fi
fi
