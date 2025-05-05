# generated from genmsg/cmake/pkg-genmsg.cmake.em

message(STATUS "volumetric_drilling_msgs: 4 messages, 0 services")

set(MSG_I_FLAGS "-Ivolumetric_drilling_msgs:/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg;-Igeometry_msgs:/opt/ros/noetic/share/geometry_msgs/cmake/../msg;-Istd_msgs:/opt/ros/noetic/share/std_msgs/cmake/../msg")

# Find all generators
find_package(gencpp REQUIRED)
find_package(geneus REQUIRED)
find_package(genlisp REQUIRED)
find_package(gennodejs REQUIRED)
find_package(genpy REQUIRED)

add_custom_target(volumetric_drilling_msgs_generate_messages ALL)

# verify that message/service dependencies have not changed since configure



get_filename_component(_filename "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Index.msg" NAME_WE)
add_custom_target(_volumetric_drilling_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "volumetric_drilling_msgs" "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Index.msg" ""
)

get_filename_component(_filename "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Voxels.msg" NAME_WE)
add_custom_target(_volumetric_drilling_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "volumetric_drilling_msgs" "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Voxels.msg" "std_msgs/ColorRGBA:std_msgs/Header:volumetric_drilling_msgs/Index"
)

get_filename_component(_filename "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/DrillSize.msg" NAME_WE)
add_custom_target(_volumetric_drilling_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "volumetric_drilling_msgs" "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/DrillSize.msg" "std_msgs/Header:std_msgs/UInt8"
)

get_filename_component(_filename "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/VolumeInfo.msg" NAME_WE)
add_custom_target(_volumetric_drilling_msgs_generate_messages_check_deps_${_filename}
  COMMAND ${CATKIN_ENV} ${PYTHON_EXECUTABLE} ${GENMSG_CHECK_DEPS_SCRIPT} "volumetric_drilling_msgs" "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/VolumeInfo.msg" "geometry_msgs/Pose:std_msgs/Header:geometry_msgs/Quaternion:geometry_msgs/Point"
)

#
#  langs = gencpp;geneus;genlisp;gennodejs;genpy
#

### Section generating for lang: gencpp
### Generating Messages
_generate_msg_cpp(volumetric_drilling_msgs
  "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Index.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/volumetric_drilling_msgs
)
_generate_msg_cpp(volumetric_drilling_msgs
  "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Voxels.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/ColorRGBA.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Index.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/volumetric_drilling_msgs
)
_generate_msg_cpp(volumetric_drilling_msgs
  "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/DrillSize.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/UInt8.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/volumetric_drilling_msgs
)
_generate_msg_cpp(volumetric_drilling_msgs
  "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/VolumeInfo.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Pose.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/volumetric_drilling_msgs
)

### Generating Services

### Generating Module File
_generate_module_cpp(volumetric_drilling_msgs
  ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/volumetric_drilling_msgs
  "${ALL_GEN_OUTPUT_FILES_cpp}"
)

add_custom_target(volumetric_drilling_msgs_generate_messages_cpp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_cpp}
)
add_dependencies(volumetric_drilling_msgs_generate_messages volumetric_drilling_msgs_generate_messages_cpp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Index.msg" NAME_WE)
add_dependencies(volumetric_drilling_msgs_generate_messages_cpp _volumetric_drilling_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Voxels.msg" NAME_WE)
add_dependencies(volumetric_drilling_msgs_generate_messages_cpp _volumetric_drilling_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/DrillSize.msg" NAME_WE)
add_dependencies(volumetric_drilling_msgs_generate_messages_cpp _volumetric_drilling_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/VolumeInfo.msg" NAME_WE)
add_dependencies(volumetric_drilling_msgs_generate_messages_cpp _volumetric_drilling_msgs_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(volumetric_drilling_msgs_gencpp)
add_dependencies(volumetric_drilling_msgs_gencpp volumetric_drilling_msgs_generate_messages_cpp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS volumetric_drilling_msgs_generate_messages_cpp)

### Section generating for lang: geneus
### Generating Messages
_generate_msg_eus(volumetric_drilling_msgs
  "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Index.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/volumetric_drilling_msgs
)
_generate_msg_eus(volumetric_drilling_msgs
  "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Voxels.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/ColorRGBA.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Index.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/volumetric_drilling_msgs
)
_generate_msg_eus(volumetric_drilling_msgs
  "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/DrillSize.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/UInt8.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/volumetric_drilling_msgs
)
_generate_msg_eus(volumetric_drilling_msgs
  "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/VolumeInfo.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Pose.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/volumetric_drilling_msgs
)

### Generating Services

### Generating Module File
_generate_module_eus(volumetric_drilling_msgs
  ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/volumetric_drilling_msgs
  "${ALL_GEN_OUTPUT_FILES_eus}"
)

add_custom_target(volumetric_drilling_msgs_generate_messages_eus
  DEPENDS ${ALL_GEN_OUTPUT_FILES_eus}
)
add_dependencies(volumetric_drilling_msgs_generate_messages volumetric_drilling_msgs_generate_messages_eus)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Index.msg" NAME_WE)
add_dependencies(volumetric_drilling_msgs_generate_messages_eus _volumetric_drilling_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Voxels.msg" NAME_WE)
add_dependencies(volumetric_drilling_msgs_generate_messages_eus _volumetric_drilling_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/DrillSize.msg" NAME_WE)
add_dependencies(volumetric_drilling_msgs_generate_messages_eus _volumetric_drilling_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/VolumeInfo.msg" NAME_WE)
add_dependencies(volumetric_drilling_msgs_generate_messages_eus _volumetric_drilling_msgs_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(volumetric_drilling_msgs_geneus)
add_dependencies(volumetric_drilling_msgs_geneus volumetric_drilling_msgs_generate_messages_eus)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS volumetric_drilling_msgs_generate_messages_eus)

### Section generating for lang: genlisp
### Generating Messages
_generate_msg_lisp(volumetric_drilling_msgs
  "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Index.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/volumetric_drilling_msgs
)
_generate_msg_lisp(volumetric_drilling_msgs
  "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Voxels.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/ColorRGBA.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Index.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/volumetric_drilling_msgs
)
_generate_msg_lisp(volumetric_drilling_msgs
  "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/DrillSize.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/UInt8.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/volumetric_drilling_msgs
)
_generate_msg_lisp(volumetric_drilling_msgs
  "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/VolumeInfo.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Pose.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/volumetric_drilling_msgs
)

### Generating Services

### Generating Module File
_generate_module_lisp(volumetric_drilling_msgs
  ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/volumetric_drilling_msgs
  "${ALL_GEN_OUTPUT_FILES_lisp}"
)

add_custom_target(volumetric_drilling_msgs_generate_messages_lisp
  DEPENDS ${ALL_GEN_OUTPUT_FILES_lisp}
)
add_dependencies(volumetric_drilling_msgs_generate_messages volumetric_drilling_msgs_generate_messages_lisp)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Index.msg" NAME_WE)
add_dependencies(volumetric_drilling_msgs_generate_messages_lisp _volumetric_drilling_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Voxels.msg" NAME_WE)
add_dependencies(volumetric_drilling_msgs_generate_messages_lisp _volumetric_drilling_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/DrillSize.msg" NAME_WE)
add_dependencies(volumetric_drilling_msgs_generate_messages_lisp _volumetric_drilling_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/VolumeInfo.msg" NAME_WE)
add_dependencies(volumetric_drilling_msgs_generate_messages_lisp _volumetric_drilling_msgs_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(volumetric_drilling_msgs_genlisp)
add_dependencies(volumetric_drilling_msgs_genlisp volumetric_drilling_msgs_generate_messages_lisp)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS volumetric_drilling_msgs_generate_messages_lisp)

### Section generating for lang: gennodejs
### Generating Messages
_generate_msg_nodejs(volumetric_drilling_msgs
  "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Index.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/volumetric_drilling_msgs
)
_generate_msg_nodejs(volumetric_drilling_msgs
  "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Voxels.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/ColorRGBA.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Index.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/volumetric_drilling_msgs
)
_generate_msg_nodejs(volumetric_drilling_msgs
  "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/DrillSize.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/UInt8.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/volumetric_drilling_msgs
)
_generate_msg_nodejs(volumetric_drilling_msgs
  "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/VolumeInfo.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Pose.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/volumetric_drilling_msgs
)

### Generating Services

### Generating Module File
_generate_module_nodejs(volumetric_drilling_msgs
  ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/volumetric_drilling_msgs
  "${ALL_GEN_OUTPUT_FILES_nodejs}"
)

add_custom_target(volumetric_drilling_msgs_generate_messages_nodejs
  DEPENDS ${ALL_GEN_OUTPUT_FILES_nodejs}
)
add_dependencies(volumetric_drilling_msgs_generate_messages volumetric_drilling_msgs_generate_messages_nodejs)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Index.msg" NAME_WE)
add_dependencies(volumetric_drilling_msgs_generate_messages_nodejs _volumetric_drilling_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Voxels.msg" NAME_WE)
add_dependencies(volumetric_drilling_msgs_generate_messages_nodejs _volumetric_drilling_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/DrillSize.msg" NAME_WE)
add_dependencies(volumetric_drilling_msgs_generate_messages_nodejs _volumetric_drilling_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/VolumeInfo.msg" NAME_WE)
add_dependencies(volumetric_drilling_msgs_generate_messages_nodejs _volumetric_drilling_msgs_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(volumetric_drilling_msgs_gennodejs)
add_dependencies(volumetric_drilling_msgs_gennodejs volumetric_drilling_msgs_generate_messages_nodejs)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS volumetric_drilling_msgs_generate_messages_nodejs)

### Section generating for lang: genpy
### Generating Messages
_generate_msg_py(volumetric_drilling_msgs
  "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Index.msg"
  "${MSG_I_FLAGS}"
  ""
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/volumetric_drilling_msgs
)
_generate_msg_py(volumetric_drilling_msgs
  "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Voxels.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/ColorRGBA.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Index.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/volumetric_drilling_msgs
)
_generate_msg_py(volumetric_drilling_msgs
  "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/DrillSize.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/UInt8.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/volumetric_drilling_msgs
)
_generate_msg_py(volumetric_drilling_msgs
  "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/VolumeInfo.msg"
  "${MSG_I_FLAGS}"
  "/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Pose.msg;/opt/ros/noetic/share/std_msgs/cmake/../msg/Header.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Quaternion.msg;/opt/ros/noetic/share/geometry_msgs/cmake/../msg/Point.msg"
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/volumetric_drilling_msgs
)

### Generating Services

### Generating Module File
_generate_module_py(volumetric_drilling_msgs
  ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/volumetric_drilling_msgs
  "${ALL_GEN_OUTPUT_FILES_py}"
)

add_custom_target(volumetric_drilling_msgs_generate_messages_py
  DEPENDS ${ALL_GEN_OUTPUT_FILES_py}
)
add_dependencies(volumetric_drilling_msgs_generate_messages volumetric_drilling_msgs_generate_messages_py)

# add dependencies to all check dependencies targets
get_filename_component(_filename "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Index.msg" NAME_WE)
add_dependencies(volumetric_drilling_msgs_generate_messages_py _volumetric_drilling_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/Voxels.msg" NAME_WE)
add_dependencies(volumetric_drilling_msgs_generate_messages_py _volumetric_drilling_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/DrillSize.msg" NAME_WE)
add_dependencies(volumetric_drilling_msgs_generate_messages_py _volumetric_drilling_msgs_generate_messages_check_deps_${_filename})
get_filename_component(_filename "/home/samvl7/SAINT/volumetric_drilling/volumetric_drilling_msgs/msg/VolumeInfo.msg" NAME_WE)
add_dependencies(volumetric_drilling_msgs_generate_messages_py _volumetric_drilling_msgs_generate_messages_check_deps_${_filename})

# target for backward compatibility
add_custom_target(volumetric_drilling_msgs_genpy)
add_dependencies(volumetric_drilling_msgs_genpy volumetric_drilling_msgs_generate_messages_py)

# register target for catkin_package(EXPORTED_TARGETS)
list(APPEND ${PROJECT_NAME}_EXPORTED_TARGETS volumetric_drilling_msgs_generate_messages_py)



if(gencpp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/volumetric_drilling_msgs)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gencpp_INSTALL_DIR}/volumetric_drilling_msgs
    DESTINATION ${gencpp_INSTALL_DIR}
  )
endif()
if(TARGET geometry_msgs_generate_messages_cpp)
  add_dependencies(volumetric_drilling_msgs_generate_messages_cpp geometry_msgs_generate_messages_cpp)
endif()
if(TARGET std_msgs_generate_messages_cpp)
  add_dependencies(volumetric_drilling_msgs_generate_messages_cpp std_msgs_generate_messages_cpp)
endif()

if(geneus_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/volumetric_drilling_msgs)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${geneus_INSTALL_DIR}/volumetric_drilling_msgs
    DESTINATION ${geneus_INSTALL_DIR}
  )
endif()
if(TARGET geometry_msgs_generate_messages_eus)
  add_dependencies(volumetric_drilling_msgs_generate_messages_eus geometry_msgs_generate_messages_eus)
endif()
if(TARGET std_msgs_generate_messages_eus)
  add_dependencies(volumetric_drilling_msgs_generate_messages_eus std_msgs_generate_messages_eus)
endif()

if(genlisp_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/volumetric_drilling_msgs)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genlisp_INSTALL_DIR}/volumetric_drilling_msgs
    DESTINATION ${genlisp_INSTALL_DIR}
  )
endif()
if(TARGET geometry_msgs_generate_messages_lisp)
  add_dependencies(volumetric_drilling_msgs_generate_messages_lisp geometry_msgs_generate_messages_lisp)
endif()
if(TARGET std_msgs_generate_messages_lisp)
  add_dependencies(volumetric_drilling_msgs_generate_messages_lisp std_msgs_generate_messages_lisp)
endif()

if(gennodejs_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/volumetric_drilling_msgs)
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${gennodejs_INSTALL_DIR}/volumetric_drilling_msgs
    DESTINATION ${gennodejs_INSTALL_DIR}
  )
endif()
if(TARGET geometry_msgs_generate_messages_nodejs)
  add_dependencies(volumetric_drilling_msgs_generate_messages_nodejs geometry_msgs_generate_messages_nodejs)
endif()
if(TARGET std_msgs_generate_messages_nodejs)
  add_dependencies(volumetric_drilling_msgs_generate_messages_nodejs std_msgs_generate_messages_nodejs)
endif()

if(genpy_INSTALL_DIR AND EXISTS ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/volumetric_drilling_msgs)
  install(CODE "execute_process(COMMAND \"/usr/bin/python3\" -m compileall \"${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/volumetric_drilling_msgs\")")
  # install generated code
  install(
    DIRECTORY ${CATKIN_DEVEL_PREFIX}/${genpy_INSTALL_DIR}/volumetric_drilling_msgs
    DESTINATION ${genpy_INSTALL_DIR}
  )
endif()
if(TARGET geometry_msgs_generate_messages_py)
  add_dependencies(volumetric_drilling_msgs_generate_messages_py geometry_msgs_generate_messages_py)
endif()
if(TARGET std_msgs_generate_messages_py)
  add_dependencies(volumetric_drilling_msgs_generate_messages_py std_msgs_generate_messages_py)
endif()
