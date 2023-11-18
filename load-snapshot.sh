#!/usr/bin/env sh
set -eu

if [ -f /tmp/snapshot.pgdump ]; then # Not a directory and so was supplied by user
  export PGPASSWORD="${POSTGRES_PASSWORD}"
  export PGUSER="${POSTGRES_USER}"
  psql -d postgres -c "CREATE ROLE \"sergii.vasyltsov\" LOGIN PASSWORD '$POSTGRES_PASSWORD';"
  psql -d postgres -c "CREATE ROLE \"mainnet2\" LOGIN PASSWORD '$POSTGRES_PASSWORD';"
  pg_restore -v -d eranode /tmp/snapshot.pgdump
  if [ "${CALL_TRACES:-false}" = "false" ]; then
    echo "Deleting call_traces table"
    psql -d eranode -c "DELETE FROM call_traces;"
  fi
fi
