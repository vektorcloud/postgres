#!/bin/sh

mkdir /run/postgresql 2> /dev/null
chown -R postgres. /run/postgresql
chown -R postgres. "$PGDATA"

[[ -z "$(find $PGDATA -type f -maxdepth 1)" ]] && {
  : ${PGPASSWORD:?}

  su - postgres -c "initdb -D $PGDATA"
  sed -ri "s/^#(listen_addresses\s*=\s*)\S+/\1'*'/" "$PGDATA"/postgresql.conf

  export PGUSER="postgres"
  export PGDATABASE="postgres"

  userSql="ALTER USER postgres WITH SUPERUSER PASSWORD '$PGPASSWORD';"
  echo $userSql | su - postgres -c "postgres --single -D $PGDATA -jE"

  [[ -d "/dbscripts" ]] && {
    # start postgres
    su - postgres -c "pg_ctl -D $PGDATA -w start"; echo

    for f in /dbscripts/*.sql; do
      echo "running $f"
      psql < "$f" && echo
    done

    # stop postgres
    su - postgres -c "pg_ctl -D $PGDATA -m fast -w stop"
  }

  echo -e "\nhost all all 0.0.0.0/0 md5" >> ${PGDATA}/pg_hba.conf
}

exec su - postgres -c "postgres -D $PGDATA"
