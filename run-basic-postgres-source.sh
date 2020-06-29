#!/bin/bash

# This is a very basic use of debezium: replicate all pg tables to kafka topics, no transforms, mostly default configs, etc.

curl -i -X POST -H "Accept:application/json" -H "Content-Type:application/json" localhost:8083/connectors/ -d @- << EOF
{
  "name": "chat-postgres-source",
  "config": {
    "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
    "plugin.name": "pgoutput",
    "database.hostname": "postgres",
    "database.port": "5432",
    "database.user": "postgres",
    "database.password": "postgres",
    "database.dbname" : "postgres",
    "database.server.name": "chat"
  }
}
EOF
