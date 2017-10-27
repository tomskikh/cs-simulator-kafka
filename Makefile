build:
	docker build -t bwsw/cs-simulator-kafka .

clean:
	docker rm -f cloudstack

run:
	docker run -e KAFKA_HOST="${KAFKA_HOST}" \
               -e KAFKA_PORT="${KAFKA_PORT}" \
               -e KAFKA_ASKS="${KAFKA_ASKS}" \
               -e KAFKA_TOPIC="${KAFKA_TOPIC}" \
               -e KAFKA_WRITE_RETRIES="${KAFKA_WRITE_RETRIES}" \
               --name cloudstack-kafka -d -p 8888:8888 bwsw/cs-simulator-kafka

shell:
	docker exec -it cloudstack /bin/bash

logs:
	docker logs -f  cloudstack
