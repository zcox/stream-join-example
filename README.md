- join two ktables on foreign key, created by debezium from postgres
- postgres
    - tables
        - messages
        - users
    - would be more compelling if users & messages were in separate postgres instances, to simulate microservice databases
- zk, kafka, schema registry, kafka connect?, ksqldb?
- docker-compose runs all components
- debezium
    - stream pg tables to kafka topics
    - register avro schemas
- kafka-streams program
    - messages ktable
    - users ktable
    - join messages with users on messages.user_id = users.user_id
    - what exactly does this do? what can we do with it?

## Initial Setup

```
#run all components:
docker-compose up -d

#verify everything is running using:
docker-compose ps

#set up postgres
./setup-postgres.sh

#install debezium connector
docker-compose exec connect confluent-hub install --no-prompt debezium/debezium-connector-postgresql:1.2.0

#restart kafka connect to load debezium connector
docker-compose restart connect

#after kafka connect restarts, run the postgres source connector
./run-basic-postgres-source.sh

#view contents of users topic (run in confluent download dir)
bin/kafka-console-consumer --bootstrap-server localhost:9092 --property print.key=true --formatter io.confluent.kafka.formatter.AvroMessageFormatter --property schema.registry.url=http://localhost:8081 --topic chat.public.users --from-beginning
```

Example user change record key:

```json
{"user_id":"8f232ed5-4cf6-4606-b539-f608473e5949"}
```

And value:

```json
{
  "before": null,
  "after": {
    "chat.public.users.Value": {
      "user_id": "8f232ed5-4cf6-4606-b539-f608473e5949",
      "name": "Alice Adams"
    }
  },
  "source": {
    "version": "1.2.0.Final",
    "connector": "postgresql",
    "name": "chat",
    "ts_ms": 1593358575676,
    "snapshot": {
      "string": "true"
    },
    "db": "postgres",
    "schema": "public",
    "table": "users",
    "txId": {
      "long": 493
    },
    "lsn": {
      "long": 24619272
    },
    "xmin": null
  },
  "op": "r",
  "ts_ms": {
    "long": 1593358575681
  },
  "transaction": null
}
```

Example message change record key:

```json
{"message_id":"7eda6993-2fae-4104-9565-dd509a172c7d"}
```

And value:

```json
{
  "before": null,
  "after": {
    "chat.public.messages.Value": {
      "message_id": "7eda6993-2fae-4104-9565-dd509a172c7d",
      "user_id": "8f232ed5-4cf6-4606-b539-f608473e5949",
      "message": "Hello my name is Alice",
      "sent": "2020-06-28T15:43:17.050942Z"
    }
  },
  "source": {
    "version": "1.2.0.Final",
    "connector": "postgresql",
    "name": "chat",
    "ts_ms": 1593358997051,
    "snapshot": {
      "string": "false"
    },
    "db": "postgres",
    "schema": "public",
    "table": "messages",
    "txId": {
      "long": 494
    },
    "lsn": {
      "long": 24619600
    },
    "xmin": null
  },
  "op": "c",
  "ts_ms": {
    "long": 1593358997156
  },
  "transaction": null
}
```

View Confluent Control Center at http://localhost:9021.

## KSQLDB

[Docs](https://docs.ksqldb.io/)

```
#connect to ksqldb
docker-compose exec ksqldb-cli ksql http://ksqldb-server:8088

#define streams for the debezium changelog topics
CREATE STREAM CHAT_MESSAGES_DEBEZIUM WITH (KAFKA_TOPIC='chat.public.messages',VALUE_FORMAT='AVRO');
CREATE STREAM CHAT_USERS_DEBEZIUM WITH (KAFKA_TOPIC='chat.public.users',VALUE_FORMAT='AVRO');

#define new streams with simpler schema and keyed correctly
#TODO why can't we just create tables from the debezium streams? those should already be keyed properly...
CREATE STREAM CHAT_USERS_REKEY AS SELECT AFTER->USER_ID AS USER_ID, AFTER->NAME AS NAME FROM CHAT_USERS_DEBEZIUM PARTITION BY AFTER->USER_ID;
CREATE STREAM CHAT_MESSAGES_REKEY AS SELECT AFTER->MESSAGE_ID AS MESSAGE_ID, AFTER->USER_ID AS USER_ID, AFTER->MESSAGE AS MESSAGE, AFTER->SENT AS SENT FROM CHAT_MESSAGES_DEBEZIUM PARTITION BY AFTER->MESSAGE_ID;

#define tables from the previous rekey streams' topics
#TODO but these aren't compacted topics...
CREATE TABLE CHAT_USERS WITH (KAFKA_TOPIC='CHAT_USERS_REKEY',VALUE_FORMAT='AVRO');
CREATE TABLE CHAT_MESSAGES WITH (KAFKA_TOPIC='CHAT_MESSAGES_REKEY',VALUE_FORMAT='AVRO');
```
