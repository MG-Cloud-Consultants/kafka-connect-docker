FROM wurstmeister/kafka:2.12-2.2.1

LABEL maintainer 'Markus Gulden <mg@gulden.consulting>'

ARG kafka_version=2.2.1
ARG scala_version=2.12

ENV KAFKA_HOME=/opt/kafka_${SCALA_VERSION}-${KAFKA_VERSION}


# Set env

ENV PATH=$PATH:/${KAFKA_HOME}/bin \
    CONNECT_CFG=${KAFKA_HOME}/config/connect-distributed.properties \
    CONNECT_BIN=${KAFKA_HOME}/bin/connect-distributed.sh

ENV JMX_PORT=9999 \
    CONNECT_PORT=8083

EXPOSE ${JMX_PORT}
EXPOSE ${CONNECT_PORT}

# Run

WORKDIR $KAFKA_HOME
COPY start-connect.sh $KAFKA_HOME/start-connect.sh
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["./start-connect.sh"]