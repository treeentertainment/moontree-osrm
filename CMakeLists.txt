cmake_minimum_required(VERSION 3.10)

# 프로젝트 이름과 버전 설정
project(OSRM-Backend VERSION 5.24.0)

# C++ 표준 설정
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED True)

# Boost, Protobuf, and other OSRM dependencies
find_package(Boost REQUIRED COMPONENTS system filesystem iostreams)
find_package(Protobuf REQUIRED)

# 소스 파일 및 실행 파일 정의
file(GLOB OSRM_SOURCES
    src/*.cpp
    src/*.h
)

# OSRM 서버 실행 파일 정의
add_executable(osrm-routed ${OSRM_SOURCES})

# 링킹: Boost와 Protobuf 라이브러리를 연결
target_link_libraries(osrm-routed Boost::system Boost::filesystem Boost::iostreams protobuf)
