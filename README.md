# Overview

Docker Compose for ZKsync Era RPC "external"/zklink/treasure node.

This repo supports mainnet only. It would need to be adjusted for testnet.

`cp default.env .env`, then `nano .env` and adjust values, including `NODE_DOCKER_TAG`, `SQL_NODE` and `PG_SNAPSHOT`. `PG_SNAPSHOT`
should be a URL and will be downloaded.

If `PG_SNAPSHOT` is omitted, the node will sync from a network snapshot. This is fast and takes very little storage,
but does not have any historical data.

If `PRUNING` is set to `true`, the node will keep data only for `PRUNING_RETENTION` seconds. This means it won't
have historical data past that point.

This repo supports splitting PostgreSQL and era node to two different machines, see `SQL_NODE`.
### Note its important to use a unique value for SQL_NODE even if running on single machine to allow running multiple versions of the repo on same machine.

Meant to be used with [central-proxy-docker](https://github.com/CryptoManufaktur-io/central-proxy-docker) for traefik
and Prometheus remote write; use `:ext-network.yml` in `COMPOSE_FILE` inside `.env` in that case.

Note there is a memory leak in the Era node when Prometheus metrics are configured but not scraped. Unset
`METRICS_PORT` if you are not going to scrape metrics.

If you want the RPC ports exposed locally, use `rpc-shared.yml` in `COMPOSE_FILE` inside `.env`.

The `./erad` script can be used as a quick-start:

`./erad install` brings in docker-ce, if you don't have Docker installed already.

`cp default.env .env`

`nano .env` and adjust variables as needed

`./erad up`

Do **not** restart the machine or the stack until the initial load has been completed, which takes ~ 2 days.

To update the software, run `./erad update` and then `./erad up`

## Hardware

Seriously consider splitting the era node (RocksDB) and the PostgreSQL server, if you have a limit to your
storage.

Storage use climbs by around 350 GiB/month.

March 2024: RocksDB ~2.4 TiB, PostgreSQL without `call_traces` ~4 TiB.
June 20th 2024: RocksDB 3.2 TB (~3 TiB), PostgreSQL without `call_traces` 5.8 TB, ~5.4 TiB.
Nov 14th 2024: RocksDB 3.5TB (~3.3 TiB), PostgreSQL without `call_traces` 6.3 TB, ~5.9 TiB

The storage requirements depend on whether the node is configured to prune, and are roughly:

- **40GB + ~5GB/day of retained data** of disk space for RocksDB / the node
- **300GB + ~15GB/day of retained data** of disk space for PostgreSQL

Keep in mind the initial PostgreSQL snapshot load will require roughly twice the space of the DB.

Provision 6 or 8 cores and 64 GiB RAM. Initial snapshot load takes up to 60 GiB RAM with ZKsync Era node and
PostgreSQL, and up to 4 cores. Steady state takes ~ 37 GiB RAM and ~ 1/5th of a core when 64 GiB are available.

When using a separate machine for PostgreSQL, 32 GiB RAM, 4 or 6 cores and 14 TiB+ NVMe work well.

## Split deployment `SQL_NODE`

The era node and PostgreSQL can be run on separate machines. Ideally, they can communicate over a private network.

On the one running the era node with `era.yml`, adjust the `SQL_NODE` variable to the IP of the PostgreSQL server.

On the one running PostgreSQL with `psql.yml:psql-shared.yml`, adjust `PG_PARAMS` for better performance and set
`SHARE_IP` to the IP of the interface on the private network.

If you don't have a private network, [place ufw in front of Docker](https://eth-docker.net/Support/Cloud) and allow
tcp 5432 from the trusted IP of the era node, disallow all other access to tcp 5432.

## zklink and treasure
Both of this are very similar to era external node but different enough to require their own yaml files. Use `zklink.yml` and `treasure.yml` for zklink and treasure respectively in place of `era.yml`.

## Version

Era Docker uses semver versioning. First digit breaking changes, second digit non-breaking changes and additions,
third digit bugfixes.

This is Era Docker v4.2.0
