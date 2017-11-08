if [ $# -ne 3 ]; then
    echo "Please run this script with four parameters (KAFKA_HOST, KAFKA_PORT, KAFKA_TOPIC, SIMULATOR_PORT)"
    exit 1;
fi

KAFKA_HOST=$1
KAFKA_PORT=$2
KAFKA_TOPIC=$3
SIMULATOR_PORT=$4

curl --fail http://localhost:${SIMULATOR_PORT}/client/ --retry 40 --retry-delay 30

test $(docker exec -it ./bin/kafka-run-class.sh kafka.tools.GetOffsetShell \
        --broker-list $KAFKA_HOST: $KAFKA_PORT \
        --topic $KAFKA_TOPIC --time -1 --offsets 1 \
        | awk -F ":" '{sum += $3} END {print sum}' \
      ) -gt 0
