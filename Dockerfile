# ARM64 - Build FF2 Core Applications
#
# VERSION               0.0.1

FROM ericvh/arm64-ubuntu-hpc:15.04-gcc5
MAINTAINER Eric Van Hensbergen <eric.vanhensbegren@arm.com>

RUN mkdir /benchmarks

# Marker Infrastructure

WORKDIR /benchmarks
RUN wget -qO- https://github.com/arm-hpc/marker/archive/master.tar.gz | tar xvzf - --transform 's/marker-master/marker/'
WORKDIR /benchmarks/marker
RUN make install

# LMbench
WORKDIR /benchmarks
RUN wget -qO- http://www.bitmover.com/lmbench/lmbench3.tar.gz | tar xvzf - 
WORKDIR /benchmarks/lmbench3
ADD lmbench.patch /tmp/lmbench.patch
RUN patch -p1 < /tmp/lmbench.patch
RUN make -j4 build

# CoMD

WORKDIR /benchmarks
RUN wget -qO- https://github.com/arm-hpc/CoMD/archive/master.tar.gz | tar xvzf - --transform 's/CoMD-master/CoMD/'
WORKDIR /benchmarks/CoMD/src-openmp
RUN make -f Makefile.aarch64 -j4
RUN make -f Makefile.aarch64 clean
RUN make -f Makefile.aarch64.omp -j4
WORKDIR /benchmarks/CoMD/src-mpi
RUN make -f Makefile.aarch64 -j4 DO_MPI=OFF
RUN make -f Makefile.aarch64 clean
RUN make -f Makefile.aarch64 -j4 DO_MPI=ON

# LULESH

WORKDIR /benchmarks
RUN wget -qO- https://github.com/arm-hpc/lulesh/archive/master.tar.gz | tar xvzf - --transform 's/LULESH-master/lulesh/'
WORKDIR /benchmarks/lulesh
RUN make -f Makefile.aarch64.serial -j4
RUN make -f Makefile.aarch64.serial -j4 lulesh2.0-serial-static
RUN make -f Makefile.aarch64 tidy
RUN make -f Makefile.aarch64.omp -j4
RUN make -f Makefile.aarch64 tidy
RUN make -f Makefile.aarch64.mpi -j4
RUN make -f Makefile.aarch64 tidy
RUN make -f Makefile.aarch64 -j4

# miniAMR (no ARM optimizations yet)
#
# need to fix, it needs a -lm (among other things)
#
WORKDIR /benchmarks
RUN wget -qO- https://github.com/arm-hpc/miniAMR/archive/master.tar.gz | tar xvzf - --transform 's/miniAMR-master/miniAMR/'
WORKDIR /benchmarks/miniAMR
RUN make -f Makefile.aarch64 -j4

# hpgmg-fv

WORKDIR /benchmarks
RUN wget -qO- https://github.com/arm-hpc/hpgmg/archive/master.tar.gz | tar xvzf - --transform 's/hpgmg-master/hpgmg/'
WORKDIR /benchmarks/hpgmg
RUN ./configure --CC mpicc --CFLAGS '-fopenmp -march=armv8-a+fp+simd -O3'
RUN make -j4 -C build

# XSbench

WORKDIR /benchmarks
RUN wget -qO- https://github.com/arm-hpc/XSBench/archive/master.tar.gz | tar xvzf - --transform 's/XSBench-master/XSBench/'
WORKDIR /benchmarks/XSBench/src
RUN make -j4 -f Makefile.aarch64

# RSbench

WORKDIR /benchmarks
RUN wget -qO- https://github.com/arm-hpc/RSBench/archive/master.tar.gz | tar xvzf - --transform 's/RSBench-master/RSBench/'
WORKDIR /benchmarks/RSBench/src
RUN make -j4 -f makefile.aarch64

# nekbone
WORKDIR /benchmarks
RUN wget -qO- https://github.com/arm-hpc/nekbone/archive/master.tar.gz | tar xvzf - --transform 's/nekbone-master/nekbone/'
WORKDIR /benchmarks/nekbone/test/example1
RUN ./makenek.aarch64

# SNAP
WORKDIR /benchmarks
RUN wget -qO- https://github.com/arm-hpc/SNAP/archive/master.tar.gz | tar xvzf - --transform 's/SNAP-master/SNAP/'
WORKDIR /benchmarks/SNAP/src
RUN make -j4

# mcb
WORKDIR /benchmarks
RUN wget -qO- https://github.com/arm-hpc/mcb/archive/master.tar.gz | tar xvzf - --transform 's/mcb-master/mcb/'
WORKDIR /benchmarks/mcb
RUN chmod ugo+x build-linux-aarch64.sh
RUN ./build-linux-aarch64.sh

WORKDIR /
