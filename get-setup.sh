#!/usr/bin/env bash

echo "Creating get-started-aws Docker volume ... "
docker volume create get-started-aws
echo "Setting up environment ..."
IMAGE="${1:-atlas-aws}"
REGION="${2:-us-east-1}"
docker run --rm \
    -v $HOME/.aws:/root/.aws \
    -v get-started-aws:/cache \
    -v "$(pwd)":/workspace \
    -w /workspace/atlas-aws "${IMAGE}" \
     "ls -l /; \
     ls -l /quickstart-mongodb-atlas-resources/; \
     cd /quickstart-mongodb-atlas-resources/cfn-resources/; \
     ls -l .; \
     echo 'Registering and deploying MongoDB Atlas AWS CloudFormation Resources, this may take a while ...';
     CFN_FLAGS='--verbose --set-default --region ${REGION}' SUBMIT_ONLY=true ./cfn-submit-helper.sh
     echo 'You can now execute get-started.sh <Quickstart_Name>' and start using the MongoDB Atlas CFN Resources!"
