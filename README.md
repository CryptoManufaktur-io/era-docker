# Overview

Docker Compose for zkSync Era RPC "external" node.

`cp default.env .env`, then `nano .env` and adjust values, including `NODE_DOCKER_TAG` and `PG_SNAPSHOT`. `PG_SNAPSHOT`
should be a URL and will be downloaded.

This repo supports splitting PostgreSQL and era node to two different machines, see `SQL_NODE`.

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

10+ TB SSD to load the initial snapshot. The PostgreSQL DB without `call_traces` is ~ 4 TiB as of Mar 2024, and
the RocksDB takes ~ 2.4 TiB.

A conservative deployment would use a 14 TiB drive to allow for future growth and to allow for in-place
PostgreSQL version updates, which requires as much space again as PostgreSQL is taking up.

Provision 6 or 8 cores and 64 GiB RAM. Initial snapshot load takes up to 60 GiB RAM with zkSync Era node and
PostgreSQL, and up to 4 cores. Steady state takes ~ 37 GiB RAM and ~ 1/5th of a core when 64 GiB are available.

When using a separate machine for PostgreSQL, 32 GiB RAM, 4 or 6 cores and 14 TiB+ NVMe work well.

## Split deployment

The era node and PostgreSQL can be run on separate machines. Ideally, they can communicate over a private network.

On the one using `era.yml`, adjust the `SQL_NODE` variable to the IP of the PostgreSQL server.

One the using `psql.yml:psql-shared.yml`, adjust `PG_PARAMS` for better performance and set `SHARE_IP` to the IP
of the interface on the private network.

If you don't have a private network, [place ufw in front of Docker](https://eth-docker.net/Support/Cloud) and allow
tcp 5432 from the trusted IP of the era node, disallow all other access to tcp 5432.

## Version

Era Docker uses semver versioning. First digit breaking changes, second digit non-breaking changes and additions,
third digit bugfixes.

This is Era Docker v3.0.0
