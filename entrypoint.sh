#!/bin/bash

# This is the entrypoint script for the dockerfile. Executed in the
# container at runtime.

# This needs to get passed in by the caller.
: ${BUILD_PREFIX?}


# Set up some of the usual makefile variables
export AS=$BUILD_PREFIX-as
export AR=$BUILD_PREFIX-ar
export CC=$BUILD_PREFIX-gcc
export CPP=$BUILD_PREFIX-cpp
export CXX=$BUILD_PREFIX-g++
export LD=$BUILD_PREFIX-ld

# If we are running docker locally, we want to create a user in the container
# with the same UID and GID as the user on the host machine, so that any files
# created are owned by that user. Without this they are all owned by root.
# If we are running from boot2docker, this is not necessary.
if [[ -n $BUILDER_UID ]] && [[ -n $BUILDER_GID ]]; then

    BUILDER_USER=build-user
    BUILDER_GROUP=build-group

    # Create a group with the given GID unless it already exists.
    grep -q :$BUILDER_GID: /etc/group || groupadd -g $BUILDER_GID $BUILDER_GROUP

    # Create a user with the given UID (TODO: what if uid exists?)
    useradd -g $BUILDER_GID -u $BUILDER_UID $BUILDER_USER

    # su to the user to run the command
    su -c "$*" $BUILDER_USER

else

    # Just run the command
    "$@"
fi
