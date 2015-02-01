# ARM64 - Build FF2 Core Applications
#
# VERSION               0.0.1

FROM ericvh/arm64-ubuntu-hpc
MAINTAINER Eric Van Hensbergen <ericvh@gmail.com>

RUN mkdir /benchmarks
ENV HOME /benchmarks

# Marker Infrastructure

WORKDIR /benchmarks
RUN wget -qO- https://github.com/arm-hpc/marker/archive/master.tar.gz | tar xvzf - --transform 's/marker-master/marker/'
WORKDIR /benchmarks/marker
RUN make install

# CoMD

WORKDIR /benchmarks
RUN wget -qO- https://github.com/arm-hpc/CoMD/archive/master.tar.gz | tar xvzf - --transform 's/CoMD-master/CoMD/'
WORKDIR /benchmarks/CoMD/src-openmp
RUN ln -s Makefile.aarch64 Makefile
RUN make -f Makefile.aarch64 -j4
RUN make clean
RUN make -f Makefile.aarch64 -j4
WORKDIR /benchmarks/CoMD/src-openmp

# LULESH

WORKDIR /benchmarks
RUN wget -qO- https://github.com/arm-hpc/lulesh/archive/master.tar.gz | tar xvzf - --transform 's/LULESH-master/lulesh/'
WORKDIR /benchmarks/lulesh
RUN make -f Makefile.aarch64 -j4
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
# [TODO: fix broken link]
#WORKDIR /benchmarks
#RUN wget -qO- https://github.com/arm-hpc/SNAP/archive/master.tar.gz | tar xvzf - --transform 's/SNAP-master/SNAP/'
#WORKDIR /benchmarks/SNAP/src
#RUN make -j4

# mcb
#[TODO: fix boost dependencies]
#WORKDIR /benchmarks
#RUN wget -qO- https://github.com/arm-hpc/mcb/archive/master.tar.gz | tar xvzf - --transform 's/mcb-master/mcb/'
#WORKDIR /benchmarks/mcb
#RUN chmod ugo+x build-linux-aarch64.sh
#RUN ./build-linux-aarch64.sh

WORKDIR /benchmarks
