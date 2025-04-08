cmake_minimum_required(VERSION 3.20)
project(WebSocketExample)

set(CMAKE_CXX_STANDARD 17)

include(FetchContent)

FetchContent_Declare(
    websocketpp
    GIT_REPOSITORY https://github.com/zaphoyd/websocketpp.git
    GIT_TAG master
)

FetchContent_MakeAvailable(websocketpp)

FetchContent_Declare(
    asio
    GIT_REPOSITORY https://github.com/chriskohlhoff/asio.git
    GIT_TAG asio-1-28-0
)

FetchContent_MakeAvailable(asio)

include_directories(
    ${websocketpp_SOURCE_DIR}
    ${asio_SOURCE_DIR}/asio/include
)

add_executable(server server.cpp)
target_compile_definitions(server PRIVATE ASIO_STANDALONE)
target_link_libraries(server pthread)

add_executable(client client.cpp)
target_compile_definitions(client PRIVATE ASIO_STANDALONE)
target_link_libraries(client pthread)
