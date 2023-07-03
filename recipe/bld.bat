@echo on
@rem Let us set the C++ Standard
sed -i '/CMAKE_CXX_STANDARD/d' CMakeLists.txt
if %ERRORLEVEL% neq 0 exit 1

cmake %CMAKE_ARGS% -DCMAKE_INSTALL_PREFIX="%LIBRARY_PREFIX%" ^
    -DPROTOBUF_USE_DLLS=ON ^
    -DBUILD_STATIC_LIB=OFF ^
    -DCMAKE_CXX_STANDARD=17 ^
    -DBUILD_TESTS=OFF ^
    -DPython3_ROOT_DIR="%PREFIX%" ^
    -DPython3_EXECUTABLE="%PYTHON%" ^
    -DPYTHON_EXECUTABLE="%PYTHON%" ^
    -DPython3_FIND_STRATEGY=LOCATION ^
    -DCMAKE_CXX_FLAGS="/DPROTOBUF_USE_DLLS=1 /EHsc /std:c++17" ^
    -GNinja ^
    -B build
if %ERRORLEVEL% neq 0 exit 1

cmake --build build
if %ERRORLEVEL% neq 0 exit 1

cmake --install build
if %ERRORLEVEL% neq 0 exit 1

%PYTHON% ./setup.py bdist_wheel
if %ERRORLEVEL% neq 0 exit 1

for /r dist %%f in (*.whl) do %PYTHON% -m pip install %%f
if %ERRORLEVEL% neq 0 exit 1
