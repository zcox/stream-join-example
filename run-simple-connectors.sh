#!/bin/bash

# This is a very basic use of debezium: replicate all pg tables to kafka topics, no transforms, mostly default configs, etc.

curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ -d @- << EOF
{
  "name": "postgres0-simple-source",
  "config": {
    "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
    "plugin.name": "pgoutput",
    "database.hostname": "postgres0",
    "database.port": "5432",
    "database.user": "postgres",
    "database.password": "postgres",
    "database.dbname" : "postgres",
    "database.server.name": "postgres0",
    "transforms": "unwrap,addPrefix",
    "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
    "transforms.unwrap.drop.tombstones": "false",
    "transforms.addPrefix.type": "org.apache.kafka.connect.transforms.RegexRouter",
    "transforms.addPrefix.regex": ".*",
    "transforms.addPrefix.replacement": "debezium.simple.\$0"
  }
}
EOF

curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ -d @- << EOF
{
  "name": "postgres1-simple-source",
  "config": {
    "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
    "plugin.name": "pgoutput",
    "database.hostname": "postgres1",
    "database.port": "5432",
    "database.user": "postgres",
    "database.password": "postgres",
    "database.dbname" : "postgres",
    "database.server.name": "postgres1",
    "transforms": "unwrap,addPrefix",
    "transforms.unwrap.type": "io.debezium.transforms.ExtractNewRecordState",
    "transforms.unwrap.drop.tombstones": "false",
    "transforms.addPrefix.type": "org.apache.kafka.connect.transforms.RegexRouter",
    "transforms.addPrefix.regex": ".*",
    "transforms.addPrefix.replacement": "debezium.simple.\$0"
  }
}
EOF
