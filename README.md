# OSRM with data

This repo generates Docker images with network data already in place.  These images are ready to deploy without additional steps to build the network.

Includes separate images for roads and rail in Australia.

Images are built by GitHub Actions (daily, on push to `main`, or manually) and
published to `ghcr.io/jxeeno/osrm-with-data`.

## OSRM v5.22 car (original)

Built from `Dockerfile` with `config/car.lua`. Unchanged — existing consumers
rely on these tags:

- `carmain`, `carnightly`, `sha-<commit>`

## OSRM v26+ car and rail

Built from `Dockerfile.v26` by the `build-v26` job, using the Geofabrik Australia
extract, the MLD algorithm and `config/driving_side.geojson` (left-hand traffic).
`car` uses OSRM's stock `car.lua`; `rail` uses `config/rail.lua`. The source
extract is not included in the image.

| Tag | Meaning |
|---|---|
| `<profile>-v26.9.0-YYYYMMDD` | build date (Sydney time) — pin these in deployments |
| `<profile>-v26.9.0-main` | latest build from `main` |
| `<profile>-v26.9.0-nightly` | latest scheduled build |
| `<profile>-v26.9.0-sha-<commit>` | build of a specific commit |

`<profile>` is `car` or `rail`. Run one with:

```sh
docker run --rm -p 5000:5000 ghcr.io/jxeeno/osrm-with-data:rail-v26.9.0-main
curl "http://localhost:5000/route/v1/rail/151.00825,-34.0879;151.05718,-34.03166?overview=false"
```

Scheduled workflows are disabled by GitHub after 60 days without repository
activity; re-enable the workflow from the Actions tab if nightly tags stop updating.
