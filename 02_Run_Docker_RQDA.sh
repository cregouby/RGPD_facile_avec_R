#!/bin/bash
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.docker.xauth
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
docker run --rm -it --volume=$XSOCK:$XSOCK:rw \
       --volume=$XAUTH:$XAUTH:rw \
       --env="XAUTHORITY=${XAUTH}" \
       --env="DISPLAY" \
       --name whirl_wheels \
       --workdir=/root/ \
       --volume=/home/creg/R/NLP_pipeline/data/:/home/dockerqda/\
 frdvnw/dockerqda:latest
