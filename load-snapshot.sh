#/usr/bin/env sh

if [ -f /tmp/snapshot.pgdump ]; then # Not a directory and so was supplied by user
  pg_restore -f /tmp/snapshot.pgdump # Rely on ENV to give us the right DB
fi
