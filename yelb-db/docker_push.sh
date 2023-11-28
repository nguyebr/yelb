#!/bin/sh

# DEFAULTS
NAME_TAG="yelb-db:1.0.0"
# ECR_REPO_URI="874542566772.dkr.ecr.us-east-1.amazonaws.com/deo-ss-eks-repo"
REGION=us-east-1

############# COMMAND LINE PARAMETERS #############
# VERIFY A NAME-TAG WAS PROVIDED
if [ "$#" -lt 1 ]
then
  echo "ERROR: No NAME-TAG Provided. Will use $NAME_TAG"
else
  NAME_TAG=$1
fi

# # VERIFY A URI WAS PROVIDED
# if [ "$#" -lt 2 ]
# then
#   echo "ERROR: No ECR REPO URI provided. Will use $ECR_REPO_URI"
# else
#   PORT=$2
# fi
# echo



echo "----STARTING PARSING NAME_TAG FOR ECR REPO NAME"
ECR_REPO_NAME="yelb-db"
VERSION=""
# Split the name and version
IFS=':' read -ra REPO_NAME <<< "$NAME_TAG"
ECR_REPO_NAME=${REPO_NAME[0]}
VERSION=${REPO_NAME[1]}
echo "Will use $ECR_REPO_NAME as the ECR Repo Name."
# for i in "${REPO_NAME[0]}"; do
#   ECR_REPO_NAME=$i
#   VERSION=${REPO_NAME[1]}
#   echo "Will use $ECR_REPO_NAME as the ECR Repo Name."
#   echo
# done

echo "----STARTING CREATION OF ECR REPOSITORY"
aws ecr create-repository --repository-name $ECR_REPO_NAME --region $REGION
echo "----FINISHED CREATION OF ECR REPOSITORY"
echo

echo "----STARTING RETRIEVAL OF ECR REPOSITORY URI"
ECR_REPO_URI=`aws ecr describe-repositories --repository-names $ECR_REPO_NAME --query 'repositories[].repositoryUri | [0]'`
# Remove the double quotes
ECR_REPO_URI=`sed -e 's/^"//' -e 's/"$//' <<<"$ECR_REPO_URI"`
echo "Using ECR REPO URI: $ECR_REPO_URI"
echo

echo "----STARTING GETTING LOGIN TOKEN"
ECR_TOKEN=`aws ecr get-login-password --region $REGION`
echo

echo "----STARTING DOCKER LOGIN"
aws ecr --region $REGION | docker login -u AWS -p $ECR_TOKEN $ECR_REPO_URI
echo "----FINISHED DOCKER LOGIN"
echo

echo "----STARTING DOCKER TAG"
docker tag $NAME_TAG $ECR_REPO_URI:$VERSION
echo

echo "----STARTING DOCKER PUSH"
docker push $ECR_REPO_URI:$VERSION
echo "----FINISHED DOCKER PUSH"