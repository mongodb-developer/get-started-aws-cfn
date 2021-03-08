#!/usr/bin/env bash
PUBLIC_KEY=${1}
PRIVATE_KEY=${2}
ORG_ID=${3}

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

QUICKSTART_NAME=${4:-"get-started-aws-quickstart"}
IMAGE="${5:-mongodb-developer/get-started-aws-cfn}"
echo "Executing ... "
echo "Launching new quickstart stack name: ${QUICKSTART_NAME}"

docker run -it --rm \
    -v $HOME/.aws:/root/.aws \
    -v get-started-aws:/cache \
    -v "$(pwd)":/workspace \
    -w /workspace/atlas-aws "${IMAGE}" \
     "cd /quickstart-mongodb-atlas/; \
     ls -l .; \
     cat ./scripts/launch-new-quickstart.sh; \
     export ATLAS_PUBLIC_KEY=${PUBLIC_KEY}; \
     export ATLAS_PRIVATE_KEY=${PRIVATE_KEY}; \
     export ATLAS_ORG_ID=${ORG_ID}; \
     export PROJECT_NAME=${QUICKSTART_NAME}; \
     ./scripts/launch-new-quickstart.sh ${QUICKSTART_NAME}; \
     echo 'Stack created.';"

echo "Checking stack events from local machine:"
aws cloudformation describe-stack-events --stack-name ${QUICKSTART_NAME} \
