# ARM64 - Build FF2 Core Applications
#
# VERSION               0.0.1

FROM ericvh/arm64-ubuntu-hpc
MAINTAINER Eric Van Hensbergen <ericvh@gmail.com>

RUN mkdir /home/ff2

# first build LULESH

WORKDIR /home/ff2
RUN git clone https://github.com/arm-hpc/lulesh.git
WORKDIR /home/ff2/lulesh
RUN make -f Makefile.aarch64 -j4

# CoMD

WORKDIR /home/ff2
RUN wget -qO- https://github.com/arm-hpc/CoMD/archive/master.tar.gz | tar xvzf -
RUN mv CoMD-master CoMD
WORKDIR /home/ff2/CoMD/src-openmp
RUN ln -s Makefile.aarch64 Makefile
RUN make -f Makefile.aarch64 -j4

#
## miniAMR (no ARM optimizations yet)
#
#WORKDIR /home/ff2
#ADD https://github.com/arm-hpc/miniAMR/archive/master.zip /home/ff2/miniAMR
#WORKDIR /home/ff2/miniAMR
#RUN make -f Makefile.mpi -j4
#
## hpgmg-fv
#
#WORKDIR /home/ff2
#ADD https://github.com/arm-hpc/hpgmg/archive/master.zip /home/ff2/hpgmg/
#WORKDIR /home/ff2/hpgmg/
#RUN make -f Makefile.mpi -j4
 
