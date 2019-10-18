FROM quay.io/vektorcloud/base:3.9

RUN apk add --no-cache curl libpq postgresql-client postgresql postgresql-contrib

ENV LANG en_US.utf8
ENV PGDATA /var/lib/postgresql/data
ENV PGUSER postgres
ENV PGDATABASE postgres

VOLUME /var/lib/postgresql/data

COPY entrypoint.sh /entrypoint.sh

EXPOSE 5432
ENTRYPOINT ["/entrypoint.sh"]
