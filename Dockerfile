FROM osrm/osrm-backend:${OSRM_VERSION:-v5.22.0}
WORKDIR /data
RUN sed -i 's/stable\/updates/stable-security\/updates/' /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y curl
RUN curl http://download.geofabrik.de/australia-oceania/australia-latest.osm.pbf > /data/australia-latest.osm.pbf
COPY config/driving_side.geojson /data/driving_side.geojson
COPY config/rail.lua /opt/rail.lua
COPY config/car.lua /opt/car.lua
# COPY config/way_handlers.lua /opt/lib/way_handlers.lua
RUN osrm-extract -p /opt/${OSRM_PROFILE:-car}.lua --location-dependent-data /data/driving_side.geojson /data/australia-latest.osm.pbf
RUN osrm-partition /data/australia-latest.osrm
RUN osrm-customize /data/australia-latest.osrm

EXPOSE 5000
ENTRYPOINT ["osrm-routed", "--max-matching-size", "3000", "--algorithm", "mld" ,"/data/australia-latest.osrm"]
