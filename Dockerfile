FROM ubuntu:trusty
MAINTAINER Stephen Thirlwall <sdt@dr.com>

# Here is where we hardcode the toolchain decision.
ENV HOST=arm-linux-gnueabihf \
    TOOLCHAIN=gcc-linaro-arm-linux-gnueabihf-raspbian

# I'd put all these into the same ENV command, but you cannot define and use
# a var in the same command.
ENV ARCH=arm \
    TOOLCHAIN_ROOT=/rpxc/$TOOLCHAIN \
    CROSS_COMPILE=/rpxc/$TOOLCHAIN/bin/$HOST-
ENV AS=${CROSS_COMPILE}as \
    AR=${CROSS_COMPILE}ar \
    CC=${CROSS_COMPILE}gcc \
    CPP=${CROSS_COMPILE}cpp \
    CXX=${CROSS_COMPILE}g++ \
    LD=${CROSS_COMPILE}ld

# 1. Install debian packages.
# 2. Fetch the raspberrypi/tools tarball from github.
# 3. Extract only the toolchain we will be using.
# 4. Create rpxc- prefixed symlinks in /usr/local/bin (eg. rpxc-gcc, rpxc-ld)
WORKDIR /rpxc

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        automake \ 
        curl \ 
        ;

RUN curl -s -L https://github.com/raspberrypi/tools/tarball/master | \
        tar --strip-components 1 -xzf -

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
        bc \
        bison \
        cmake \
        build-essential\
        curl \
        flex \
        lib32stdc++6 \
        lib32z1 \
        ncurses-dev \
        perl \
        ;



RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
        git \
        sed \
				cmake-curses-gui \
        libgl1-mesa-dev \
        ;


WORKDIR /build
ENTRYPOINT [ "/rpxc/entrypoint.sh" ]

COPY imagefiles/entrypoint.sh imagefiles/rpxc /rpxc/
