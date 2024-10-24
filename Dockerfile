# Base image
FROM ubuntu:20.04

# Install necessary packages
RUN apt-get update && apt-get install -y \
    apache2 \
    mod_tile \
    renderd \
    osm2pgsql \
    wget

# Create directories
RUN mkdir -p /var/run/renderd /var/lib/mod_tile

# Copy configuration files (ensure these are present in your repo)
COPY renderd.conf /usr/local/etc/renderd.conf
COPY apache-site.conf /etc/apache2/sites-available/000-default.conf

# Download osm.pbf from your GitHub repository
RUN wget https://raw.githubusercontent.com/202420505/moontree-osrm/main/south-korea-latest.osm.pbf -O /osm-data/osm.pbf

# Import OSM data into PostgreSQL
RUN osm2pgsql -d gis --slim --drop --number-processes 4 /osm-data/osm.pbf

# Expose Apache port
EXPOSE 80

# Start Apache and renderd when the container starts
CMD ["sh", "-c", "service apache2 start && renderd -f"]
