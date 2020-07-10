FROM postgres:12

ADD postgresql.conf.sample /usr/share/postgresql/

ADD messages.sql /docker-entrypoint-initdb.d/
