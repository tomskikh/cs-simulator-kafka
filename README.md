# CloudStack Simulator With Kafka Event Bus Integration

ACS Version is 4.10.3

## Setup

The docker image runs the CloudStack simulator and contains two zones for the different network setups: `basic` and `advanced` networking.

* CloudStack Zone: Sandbox-simulator-advanced
* Zone: Sandbox-simulator-basic

## Specify environment variables:
    KAFKA_HOST,
    KAFKA_PORT,
    KAFKA_ACKS ("all" by default),
    KAFKA_TOPIC ("cs" by default),
    KAFKA_WRITE_RETRIES (1 by default)

## Prepare kafka
    docker run -d -p 2181:2181 -p $KAFKA_PORT:$KAFKA_PORT --env ADVERTISED_HOST=$KAFKA_HOST --env ADVERTISED_PORT=$KAFKA_PORT spotify/kafka

## Build

    docker build -t bwsw/cs-simulator-kafka .

## Run

    docker run -e KAFKA_HOST="${KAFKA_HOST}" \
               -e KAFKA_PORT="${KAFKA_PORT}" \
               -e KAFKA_ACKS="${KAFKA_ACKS}" \
               -e KAFKA_TOPIC="${KAFKA_TOPIC}" \
               -e KAFKA_WRITE_RETRIES="${KAFKA_WRITE_RETRIES}" \
               --name cloudstack-kafka -d -p 8888:8888 bwsw/cs-simulator-kafka

NOTE: It may take some time until the zones are deployed. The web server will respond with HTTP 503 on port 8888 unless the zones are fully deployed.
