#!/bin/bash -e

ITERATIONS=40
SLEEP=30

for i in `seq 1 $ITERATIONS`
do
    curl -s -I http://localhost:${SIMULATOR_PORT}/client/ | head -1 | grep "200"

    if [ $? -eq 0 ]
    then
        echo "OK"
        break
    else
        echo "retry number $i"
        sleep $SLEEP
    fi

    if [ $i -eq $ITERATIONS ]
    then
        exit 1
    fi
done

sleep $SLEEP

NUMBER_OF_MESSAGES=$(docker exec -i $KAFKA_CONTAINER_ID ./opt/kafka_2.11-0.10.1.0/bin/kafka-run-class.sh kafka.tools.GetOffsetShell \
        --broker-list $KAFKA_HOST:$KAFKA_PORT \
        --topic $KAFKA_TOPIC --time -1 --offsets 1 \
        | awk -F ":" '{sum += $3} END {print sum}')

echo "NUMBER_OF_MESSAGES = $NUMBER_OF_MESSAGES"

if [ -z $NUMBER_OF_MESSAGES ]
then exit 1
fi

if [ $NUMBER_OF_MESSAGES -eq 0 ]
then exit 1
fi
