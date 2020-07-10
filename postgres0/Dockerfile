# this is basically the stock postgres:12 image, with a few debezium configs, see https://github.com/debezium/docker-images/tree/master/postgres/12
# TODO should really try to use stock postgres:12 image though, to verify pgoutput works properly, with no extensions required
FROM debezium/postgres:12

ADD users.sql /docker-entrypoint-initdb.d/
