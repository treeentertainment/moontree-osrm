FROM osrm/osrm-backend

# Add OSM file to container
ADD ./south-korea-latest.osm.pbf /data/

# Preprocess the map file
RUN osrm-extract -p /opt/bicycle.lua /data/south-korea-latest.osm.pbf
RUN osrm-partition /data/south-korea-latest.osm.pbf
RUN osrm-customize /data/south-korea-latest.osm.pbf

# Expose the OSRM port
EXPOSE 5000

# Run OSRM routing service
CMD ["osrm-routed", "--algorithm", "MLD", "/data/south-korea-latest.osm.pbf"]
