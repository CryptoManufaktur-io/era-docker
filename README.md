# Overview

Docker Compose for ZKSync Era RPC "external" node.

`cp default.env .env`, then `nano .env` and adjust values, including `PG_SNAPSHOT` if desired/required.

You will need to download the snapshot file locally, and should `rm` it and unset `PG_SNAPSHOT` after initial setup.
The space will be freed when postgres is restarted; only do this once era-node has completed its initial load.

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

To update the software, run `./erad update` and then `./erad up`

## Hardware

3.8+ TB SSD to load the initial snapshot, with around 1 TiB free after initial load and removal of the snapshot.
A conservative deployment would use a 7.6 TB drive to allow for future growth, for both the databases and the snapshot
in case of resync.

N cores and N GiB RAM, tbd. The official 32 cores 64 GiB RAM are likely oversized, by a lot.

This is Era Docker v1.0.0
