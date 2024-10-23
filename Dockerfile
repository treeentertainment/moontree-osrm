FROM osrm/osrm-backend

# GitHub에서 OSM 파일을 다운로드
RUN apt-get update && apt-get install -y curl
RUN curl -L -o /data/south-korea-latest.osm.pbf https://raw.githubusercontent.com/your-username/your-repo/main/south-korea-latest.osm.pbf

# OSRM 데이터 준비
RUN osrm-extract -p /opt/bicycle.lua /data/south-korea-latest.osm.pbf
RUN osrm-partition /data/south-korea-latest.osm.pbf
RUN osrm-customize /data/south-korea-latest.osm.pbf

# OSRM 포트 노출
EXPOSE 5000

# OSRM 실행
CMD ["osrm-routed", "--algorithm", "MLD", "/data/south-korea-latest.osm.pbf"]
