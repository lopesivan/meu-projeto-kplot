cmake_minimum_required(VERSION 3.15)
project(KPlotDemo LANGUAGES C)

find_package(kplot REQUIRED)

add_executable(kplot_demo main.c)

target_link_libraries(kplot_demo PRIVATE kplot::kplot)

set_target_properties(kplot_demo PROPERTIES RUNTIME_OUTPUT_DIRECTORY
                                            ${CMAKE_BINARY_DIR}/bin)
