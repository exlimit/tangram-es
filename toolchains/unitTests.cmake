# options
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -stdlib=libc++ -std=c++11")

add_definitions(-DPLATFORM_OSX) 

# include headers for homebrew-installed libraries
include_directories(/usr/local/include)

# load core library
add_subdirectory(${PROJECT_SOURCE_DIR}/core)
include_directories(${CORE_INCLUDE_DIRS})
include_directories(${CORE_LIBRARIES_INCLUDE_DIRS})

set(OSX_PLATFORM_SRC ${PROJECT_SOURCE_DIR}/osx/src/platform_osx.mm)

file(GLOB TEST_SOURCES tests/unit/*.cpp)

# configure glfw
set(GLFW_BUILD_EXAMPLES OFF CACHE BOOL "Build the GLFW example programs")
set(GLFW_BUILD_TESTS OFF CACHE BOOL "Build the GLFW test programs")
set(GLFW_BUILD_DOCS OFF CACHE BOOL "Build the GLFW documentation")
set(GLFW_INSTALL OFF CACHE BOOL "Generate installation target")
add_subdirectory(${PROJECT_SOURCE_DIR}/glfw)
include_directories(${PROJECT_SOURCE_DIR}/glfw/include)

# create an executable per test
foreach(_src_file_path ${TEST_SOURCES})
    string(REPLACE ".cpp" "" test_case ${_src_file_path})
    string(REGEX MATCH "([^/]*)$" test_name ${test_case})
    
    set(EXECUTABLE_NAME "${test_name}.out")

    add_executable(${EXECUTABLE_NAME} ${_src_file_path} ${OSX_PLATFORM_SRC})

    target_link_libraries(${EXECUTABLE_NAME} core glfw ${GLFW_LIBRARIES})
    
endforeach(_src_file_path ${TEST_SOURCES})

# copy resources in order to make tests with resources dependency
file(GLOB_RECURSE RESOURCES ${PROJECT_SOURCE_DIR}/core/resources/*)
foreach(_resource ${RESOURCES})
    file(COPY ${_resource} DESTINATION ${PROJECT_SOURCE_DIR}/build/tests/unit/bin)
endforeach()
