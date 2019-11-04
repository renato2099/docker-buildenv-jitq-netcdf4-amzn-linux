FROM ingomuellernet/lambda-build-jitq as lambda-builder

# HDF5
RUN mkdir -p /tmp/hdf5 && \
    cd /tmp/hdf5 && \
    wget https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/hdf5-1.8.18/src/hdf5-1.8.18.tar.gz -O - \
        | tar -xz --strip-components=1 && \
    mkdir /tmp/hdf5/build && cd /tmp/hdf5/build && \
    CXX=clang++-7.0 CC=clang-7.0 cmake \
        -DCMAKE_INSTALL_PREFIX=/opt/hdf5 \
        .. && \
    make && \
    make install

ENV CMAKE_PREFIX_PATH $CMAKE_PREFIX_PATH:/opt/hdf5/share/cmake

#NETCDF
#RUN yum install -y libnetcdf-dev && \
RUN cd /tmp/ && git clone https://github.com/Unidata/netcdf-c.git && \
    mkdir -p /tmp/netcdf-c/build && cd /tmp/netcdf-c/build && \
    CXX=clang++-7.0 CC=clang-7.0 \
        cmake \
            -DCMAKE_INSTALL_PREFIX=/opt/netcdf-c \
            -DENABLE_PARALLEL_TESTS=OFF \
            -DENABLE_BYTERANGE=ON \
            .. && \
    make && \
    make install

ENV CMAKE_PREFIX_PATH $CMAKE_PREFIX_PATH:/opt/netcdf-c/lib/cmake
