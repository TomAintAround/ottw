cmake_minimum_required(VERSION 3.31)
project(
  ottw
  DESCRIPTION "Over The Top Widgets, made with GTK 4"
  VERSION 0.1
  LANGUAGES C)

find_package(PkgConfig REQUIRED)
find_program(GLIB_COMPILE_RESOURCES NAMES glib-compile-resources REQUIRED)

set(CMAKE_CXX_STANDARD 26)
set(CXX_STANDARD_REQUIRED ON)
message(STATUS "Setting compile flags")
add_compile_options(
  -Wall
  -Wextra
  -Wpedantic
  -Wno-unused-parameter
  -Wno-unused-value
  -Wno-missing-field-initializers
  -Wno-narrowing
  -Wno-pointer-arith
  -Wno-clobbered)

if(CMAKE_BUILD_TYPE MATCHES Debug)
  message(STATUS "Compile ottw in debug mode")
  add_compile_options(-g)
else()
  message(STATUS "Compile ottw normally")
  add_compile_options(-O3)
endif()

set(CMAKE_EXECUTABLE_ENABLE_EXPORTS TRUE)
set(CMAKE_EXPORT_COMPILE_COMMANDS TRUE)

message(STATUS "Checking GTK4")
pkg_check_modules(GTK4 REQUIRED gtk4)
link_directories(${GTK4_LIBRARY_DIRS})
add_compile_options(${GTK4_CFLAGS_OTHER})
set(LIBRARIES ${LIBRARIES} ${GTK4_LIBRARIES})
set(CMAKE_C_FLAGS ${CMAKE_C_FLAGS} ${GTK4_CFLAGS})

message(STATUS "Checking gtk4-layer-shell")
pkg_check_modules(GTK4LS REQUIRED gtk4-layer-shell-0)
link_directories(${GTK4LS_LIBRARY_DIRS})
add_compile_options(${GTK4LS_CFLAGS_OTHER})
set(LIBRARIES ${LIBRARIES} ${GTK4LS_LIBRARIES})
set(CMAKE_C_FLAGS ${CMAKE_C_FLAGS} ${GTK4LS_CFLAGS})

string(REPLACE ";" " " CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
string(REPLACE ";" "\n-L" LDFLAGS "${GTK4_LIBRARY_DIRS}")
string(REPLACE ";" "\n-l" LFLAGS "${GTK4_LIBRARIES}")
string(REPLACE " " "\n" CFLAGS "${CMAKE_C_FLAGS}")
message(STATUS "LDFlags: \n-L${LDFLAGS} \n-l${LFLAGS}")
message(STATUS "CFlags: \n${CFLAGS}")

message(STATUS "Generating gresource.c")
set(GRESOURCE_XML ${CMAKE_SOURCE_DIR}/share/gresource.xml)
set(GRESOURCE_C ${CMAKE_SOURCE_DIR}/src/gresource.c)

add_custom_command(
  OUTPUT ${GRESOURCE_C}
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  COMMAND ${GLIB_COMPILE_RESOURCES} ARGS --target=${GRESOURCE_C}
          ${GRESOURCE_XML} --generate-source
  VERBATIM
  MAIN_DEPENDENCY ${GRESOURCE_XML})

file(GLOB SRC_FILES "${CMAKE_SOURCE_DIR}/src/*.c")
list(APPEND SRC_FILES ${GRESOURCE_C})

add_executable(${PROJECT_NAME} ${SRC_FILES})

message(STATUS "Linking libraries")
target_link_libraries(${PROJECT_NAME} ${LIBRARIES})

# TODO: add install instructions
