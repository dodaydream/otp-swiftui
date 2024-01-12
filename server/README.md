## Use with Docker Compose

### Build data

```bash
docker-compose run opentripplanner --build --save
```

### Start server
```bash
docker-compose up
```

## Data

You can download the data from the following sources:

### GTFS
[LTC GTFS Data](https://www.londontransit.ca/open-data/)

### OSM
Download the pbf format data from [Geofabrik](https://download.geofabrik.de/north-america/canada/ontario.html), then follow the [instruction](https://docs.opentripplanner.org/en/v2.4.0/Preparing-OSM/) to crop and filter the data.
