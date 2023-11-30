# Overview

Docker Compose for zkSync Era RPC "external" node.

`cp default.env .env`, then `nano .env` and adjust values, including `NODE_DOCKER_TAG` and `PG_SNAPSHOT`. `PG_SNAPSHOT`
should be a URL and will be downloaded.

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

5+ TB SSD to load the initial snapshot. The PostgreSQL DB without `call_traces` is ~ 2.3 TiB as of Nov 2023, and
the RocksDB takes ~ 1.5 TiB.

A conservative deployment would use a 7.6 TB / 7 TiB drive to allow for future growth and to allow for in-place
PostgreSQL version updates, which requires as much space again as PostgreSQL is taking up.

Provision 6 or 8 cores and 64 GiB RAM. Initial snapshot load takes up to 60 GiB RAM with zkSync Era node and
PostgreSQL, and up to 4 cores. Steady state takes ~ 37 GiB RAM and ~ 1/5th of a core when 64 GiB are available.
On a 32 GiB machine, era-node stayed under 14 GiB RAM total.

## Version

Era Docker uses semver versioning. First digit breaking changes, second digit non-breaking changes and additions,
third digit bugfixes.

This is Era Docker v1.0.0
