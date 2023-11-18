#/usr/bin/env sh
set -eu

if [ -f /tmp/snapshot.pgdump ]; then # Not a directory and so was supplied by user
  pg_restore < /tmp/snapshot.pgdump # Rely on ENV to give us the right DB
fi
