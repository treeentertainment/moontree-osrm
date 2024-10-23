# OSRM을 위한 빌드 환경 설정
FROM ubuntu:20.04

# 필수 패키지 설치
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libboost-all-dev \
    libprotobuf-dev \
    protobuf-compiler \
    libosmpbf-dev \
    libstxxl-dev \
    libstxxl1v5 \
    libxml2-dev \
    libsparsehash-dev \
    libbz2-dev \
    zlib1g-dev \
    liblua5.2-dev \
    libtbb-dev \
    curl

# OSRM Backend 소스 클론 및 빌드
RUN git clone https://github.com/Project-OSRM/osrm-backend.git
WORKDIR /osrm-backend
RUN mkdir -p build && cd build && cmake .. && cmake --build .

# PBF 파일 다운로드 (GitHub에서)
ADD south-korea-latest.osm.pbf

# PBF 파일 처리
RUN ./build/osrm-extract /data/map.osm.pbf -p profiles/car.lua
RUN ./build/osrm-contract /data/map.osrm

# OSRM 서버 실행
CMD ["./build/osrm-routed", "--algorithm", "mld", "/data/map.osrm"]
