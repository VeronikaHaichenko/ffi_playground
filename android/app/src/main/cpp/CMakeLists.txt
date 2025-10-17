cmake_minimum_required(VERSION 3.4.1)

# Создаем shared library (.so)
add_library(native_bridge SHARED native_bridge.c)

# Укажем логирование (если нужно)
find_library(log-lib log)
target_link_libraries(native_bridge ${log-lib})
