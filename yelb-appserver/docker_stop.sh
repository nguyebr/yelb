#!/bin/sh

# DEFAULTS
NAME_TAG="yelb-appserver:1.0.0"
PORT=4567


############# COMMAND LINE PARAMETERS #############
# VERIFY A NAME-TAG WAS PROVIDED
if [ "$#" -lt 1 ]
then
  echo "ERROR: No NAME-TAG Provided. Will use $NAME_TAG"
else
  NAME_TAG=$1
fi
echo

# STOP CONTAINER BY NAME
echo "----STARTING DOCKER STOP"
docker stop $(docker ps -q --filter ancestor=$NAME_TAG )
echo "----FINISHED DOCKER STOP"

# docker ps
# docker stop $CONTAINER_ID