#!/usr/bin/env sh
set -eu

if [ -f /tmp/snapshot.pgdump ]; then # Not a directory and so was supplied by user
  export PGPASSWORD="${POSTGRES_PASSWORD}"
  export PGUSER="${POSTGRES_USER}"
  psql -d postgres -c "CREATE ROLE \"sergii.vasyltsov\" LOGIN PASSWORD '$POSTGRES_PASSWORD';"
  psql -d postgres -c "CREATE ROLE \"mainnet2\" LOGIN PASSWORD '$POSTGRES_PASSWORD';"

  if [ "${CALL_TRACES:-false}" = "false" ]; then
    echo "Restoring pgdump without call_traces table"
    pg_restore -l /tmp/snapshot.pgdump  | grep -iv 'call_traces' >/tmp/snapshot.list
    __list="-L /tmp/snapshot.list"
  else
    echo "Restoring pgdump with call_traces table"
    __list=""
  fi

  pg_restore -v -d eranode ${__list} /tmp/snapshot.pgdump
fi
