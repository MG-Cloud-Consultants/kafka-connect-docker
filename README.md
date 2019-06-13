# kafka-connect-docker

Dockerized [Apache Kafka Connect](http://kafka.apache.org/documentation.html#connect) (distributed mode), based on the [Wurstmeister Apache Kafka Image](https://hub.docker.com/r/wurstmeister/kafka)

## Supported Tags
- `2.2.1` (2.12) 

## Quick Start 

### Docker Compose

```yaml
version: "2.1"
services:
  zookeeper:
    image: zookeeper
    environment:
      ZOOKEEPER_CLIENT_PORT: 2181
  kafka:
    image: wurstmeister/kafka
    depends_on:
    - zookeeper
    environment:
      KAFKA_ZOOKEEPER_CONNECT: zookeeper:2181
      KAFKA_ADVERTISED_LISTENERS: PLAINTEXT://kafka:9092
      KAFKA_LISTENERS: PLAINTEXT://kafka:9092
  kafka-connect:
    image: markusgulden/kafka-connect
    ports:
      - "8083:8083"
    environment:
      CONNECT_BOOTSTRAP_SERVERS: "kafka:9092"
      CONNECT_REST_ADVERTISED_HOST_NAME: localhost
      CONNECT_REST_PORT: 8083
      CONNECT_GROUP_ID: compose-connect-group      
    depends_on:
      - zookeeper
      - kafka
```

### Docker CLI

```shell
$ docker run -d --name zookeeper zookeeper

$ docker run -d --name kafka \
    -e KAFKA_ZOOKEEPER_CONNECT=zookeeper:2181 \
    -e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://kafka:9092 \
    -e KAFKA_LISTENERS=PLAINTEXT://kafka:9092 \ 
    wurstmeister/kafka
    
$ docker run --rm --name connect \
    -p 8083:8083 \
    -e CONNECT_BOOTSTRAP_SERVERS=kafka:9092 \
    -e CONNECT_REST_ADVERTISED_HOST_NAME=localhost \
    -e CONNECT_REST_PORT=8083 \
    -e CONNECT_GROUP_ID=compose-connect-group \
    markusgulden/kafka-connect
```

## Environment Variables

Pass env variables starting with `CONNECT_` to configure `connect-distributed.properties`.  
For example, If you want to set `offset.flush.interval.ms=15000`, use `CONNECT_OFFSET_FLUSH_INTERVAL_MS=15000`

- (**required**) `CONNECT_BOOTSTRAP_SERVERS`

For other parameters, see [Kafka Connect Configs](http://kafka.apache.org/documentation/#connect_running)
