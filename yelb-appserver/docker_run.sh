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

# VERIFY A PORT WAS PROVIDED
if [ "$#" -lt 2 ]
then
  echo "ERROR: No PORT Provided. Will use $PORT"
else
  PORT=$2
fi
echo

# BUILD CONTAINER
echo "----STARTING DOCKER BUILD"
docker build -t $NAME_TAG .
echo "----FINISHED DOCKER BUILD"

# # RUN CONTAINER
# echo "----STARTING DOCKER RUN"
# docker run -p $PORT:$PORT $NAME_TAG