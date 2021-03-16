#!/usr/bin/env bash

if [ $# -lt 2 ]; then
  if [ -x "$(command -v mongocli)" ]; then
    echo 'No apikey arguments detected and mongocli installed, will use default mongocli profile.'
    MCLI_ARGS=$(./export-mongocli-config.py default spaces)
    PUBLIC_KEY=$(echo ${MCLI_ARGS} | cut -d' ' -f1)
    PRIVATE_KEY=$(echo ${MCLI_ARGS} | cut -d' ' -f2)
    ORG_ID=$(echo ${MCLI_ARGS} | cut -d' ' -f3)
    QUICKSTART_NAME=${1:-"get-started-aws-quickstart"}
  fi
else
  PUBLIC_KEY=${1}
  PRIVATE_KEY=${2}
  ORG_ID=${3}
  QUICKSTART_NAME=${4:-"get-started-aws-quickstart"}
fi

if [ -z ${PUBLIC_KEY} ]
then
    read -p "MongoDB Atlas Public Key (Required): " PUBLIC_KEY
fi
if [ -z ${PRIVATE_KEY} ]
then
    read -p "MongoDB Atlas Private Key (Required): " PRIVATE_KEY
fi
if [ -z ${ORG_ID} ]
then
    read -p "MongoDB Atlas Org Id (Required): " ORG_ID
fi

IMAGE_REPO=${IMAGE_REPO:-public.ecr.aws/u1r4t8v5/}
IMAGE=${IMAGE:-mongodb-developer/get-started-aws-cfn:latest}
IMG="${IMAGE_REPO}${IMAGE}"

echo "Launching new quickstart stack name: ${QUICKSTART_NAME}"
echo "Running Docker image: ${IMG}"
echo "Executing ... "

docker run -it --rm \
    -v $HOME/.aws:/root/.aws \
    -v get-started-aws:/cache \
    -v "$(pwd)":/workspace \
    -e AWS_DEFAULT_REGION \
    -e AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY \
    -e AWS_SESSION_TOKEN \
    -w /workspace/atlas-aws "${IMG}" \
     "cd /quickstart-mongodb-atlas/; \
     export ATLAS_PUBLIC_KEY=${PUBLIC_KEY}; \
     export ATLAS_PRIVATE_KEY=${PRIVATE_KEY}; \
     export ATLAS_ORG_ID=${ORG_ID}; \
     export PROJECT_NAME=${QUICKSTART_NAME}; \
     ./scripts/launch-new-quickstart.sh ${QUICKSTART_NAME}; \
     echo 'Stack created.';"

echo "Checking stack events from local machine:"
aws cloudformation describe-stack-events --stack-name ${QUICKSTART_NAME} \
