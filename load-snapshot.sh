#!/usr/bin/env bash
set -euo pipefail

if [ -n "${PG_SNAPSHOT}" ]; then
  export PGPASSWORD="${POSTGRES_PASSWORD}"
  export PGUSER="${POSTGRES_USER}"

  echo "Downloading snapshot file"
  aria2c -c -x6 -s6 --auto-file-renaming=false --conditional-get=true --allow-overwrite=true -d /tmp \
    -o snapshot.pgdump "${PG_SNAPSHOT}"

  if [ "${CALL_TRACES:-false}" = "false" ]; then
    echo "Restoring pgdump without call_traces table"
    pg_restore -l /tmp/snapshot.pgdump  | grep -iv 'call_traces' >/tmp/snapshot.list
    __list="-L /tmp/snapshot.list"
  else
    echo "Restoring pgdump with call_traces table"
    __list=""
  fi

  pg_restore -O -v -d ${POSTGRES_DB} ${__list} /tmp/snapshot.pgdump

  echo "Removing snapshot file"
  rm -f /tmp/snapshot.pgdump
fi
