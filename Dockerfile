# OSRM 빌드 환경 설정
FROM ubuntu:20.04

# 필수 패키지 설치 (비대화형으로 tzdata 설정)
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    libboost-all-dev \
    libprotobuf-dev \
    protobuf-compiler \
    libosmpbf-dev \
    libstxxl-dev \
    libxml2-dev \
    libsparsehash-dev \
    libbz2-dev \
    zlib1g-dev \
    liblua5.2-dev \
    libtbb-dev \
    curl \
    tzdata \
    wget \
    && apt-get clean

# CMake 설치 (소스에서 빌드)
RUN wget https://cmake.org/files/v3.18/cmake-3.18.6.tar.gz && \
    tar -xzvf cmake-3.18.6.tar.gz && \
    cd cmake-3.18.6 && \
    ./bootstrap && \
    make && \
    make install && \
    cd .. && \
    rm -rf cmake-3.18.6 cmake-3.18.6.tar.gz

# 시간대 설정 (한국 표준시)
RUN ln -fs /usr/share/zoneinfo/Asia/Seoul /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata

# OSRM Backend 소스 클론 및 빌드
RUN git clone https://github.com/Project-OSRM/osrm-backend.git
WORKDIR /osrm-backend
RUN mkdir -p build && cd build && cmake .. && make

# PBF 파일을 루트 디렉토리에 복사
ADD https://raw.githubusercontent.com/202420505/moontree-osrm/main/south-korea-latest.osm.pbf /map.osm.pbf

# PBF 파일 처리
RUN ./build/osrm-extract /map.osm.pbf -p profiles/car.lua
RUN ./build/osrm-contract /map.osrm

# OSRM 서버 실행
CMD ["./build/osrm-routed", "--algorithm", "mld", "/map.osrm"]
