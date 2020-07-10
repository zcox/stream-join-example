FROM postgres:12

ADD postgresql.conf.sample /usr/share/postgresql/

ADD users.sql /docker-entrypoint-initdb.d/
