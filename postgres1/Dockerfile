FROM postgres:12

COPY postgresql.conf.sample /usr/share/postgresql/postgresql.conf.sample

ADD messages.sql /docker-entrypoint-initdb.d/
