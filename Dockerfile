# ARM64 - Build FF2 Core Applications
#
# VERSION               0.0.1

FROM ericvh/arm64-ubuntu-hpc
MAINTAINER Eric Van Hensbergen <ericvh@gmail.com>

RUN mkdir /home/ff2
ENV HOME /home/ff2

# LULESH

WORKDIR /home/ff2
RUN wget -qO- https://github.com/arm-hpc/lulesh/archive/master.tar.gz | tar xvzf -
RUN mv LULESH-master lulesh
WORKDIR /home/ff2/lulesh
RUN make -f Makefile.aarch64 -j4

# CoMD

WORKDIR /home/ff2
RUN wget -qO- https://github.com/arm-hpc/CoMD/archive/master.tar.gz | tar xvzf -
RUN mv CoMD-master CoMD
WORKDIR /home/ff2/CoMD/src-openmp
RUN ln -s Makefile.aarch64 Makefile
RUN make -f Makefile.aarch64 -j4


# miniAMR (no ARM optimizations yet)
#
# need to fix, it needs a -lm (among other things)
#
WORKDIR /home/ff2
RUN wget -qO- https://github.com/arm-hpc/miniAMR/archive/master.tar.gz | tar xvzf -
RUN mv miniAMR-master miniAMR
WORKDIR /home/ff2/miniAMR
RUN make -f Makefile.aarch64 -j4

# hpgmg-fv

WORKDIR /home/ff2
RUN wget -qO- https://github.com/arm-hpc/hpgmg/archive/master.tar.gz | tar xvzf -
RUN mv hpgmg-master hpgmg
WORKDIR /home/ff2/hpgmg
RUN ./configure --CC mpicc --CFLAGS '-fopenmp -march=armv8-a+fp+simd -O3'
RUN make -j4 -C build

# XSbench

WORKDIR /home/ff2
RUN wget -qO- https://github.com/arm-hpc/XSBench/archive/master.tar.gz | tar xvzf -
RUN mv XSBench-master XSBench
WORKDIR /home/ff2/XSBench/src
RUN make -j4 -f Makefile.aarch64

# RSbench

WORKDIR /home/ff2
RUN wget -qO- https://github.com/arm-hpc/RSBench/archive/master.tar.gz | tar xvzf -
RUN mv RSBench-master RSBench
WORKDIR /home/ff2/RSBench/src
RUN make -j4 -f makefile.aarch64

# SNAP
# [TODO: fix broken link]
#WORKDIR /home/ff2
#RUN wget -qO- https://github.com/arm-hpc/SNAP/archive/master.tar.gz | tar xvzf -
#RUN mv SNAP-master SNAP
#WORKDIR /home/ff2/SNAP/src
#RUN make -j4 

# nekbone
WORKDIR /home/ff2
RUN wget -qO- https://github.com/arm-hpc/nekbone/archive/master.tar.gz | tar xvzf -
RUN mv nekbone-master nekbone
WORKDIR /home/ff2/nekbone/test/example1
RUN ./makenek.aarch64

# mcb
#[TODO: fix boost dependencies]
#WORKDIR /home/ff2
#RUN wget -qO- https://github.com/arm-hpc/mcb/archive/master.tar.gz | tar xvzf -
#RUN mv mcb-master mcb
#WORKDIR /home/ff2/mcb
#RUN chmod ugo+x build-linux-aarch64.sh
#RUN ./build-linux-aarch64.sh

WORKDIR /home/ff2
