FROM postgres:12

COPY postgresql.conf.sample /usr/share/postgresql/postgresql.conf.sample

ADD users.sql /docker-entrypoint-initdb.d/
