#!/usr/bin/env bash

echo "Creating get-started-aws Docker volume ... "
docker volume create get-started-aws
REGION="${1:-us-east-1}"
echo "Setting up environment REGION=${REGION} ..."
docker run --rm \
    -v $HOME/.aws:/root/.aws \
    -v get-started-aws:/cache \
    -v "$(pwd)":/workspace \
    -w /workspace/atlas-aws "mongodb-developer/get-started-aws-cfn" \
     "ls -l /; \
     ls -l /quickstart-mongodb-atlas-resources/; \
     cd /quickstart-mongodb-atlas-resources/cfn-resources/; \
     ls -l .; \
     echo 'Registering and deploying MongoDB Atlas AWS CloudFormation Resources, this may take a while ...'; \
     CFN_FLAGS='--verbose --set-default --region ${REGION}' SUBMIT_ONLY=true ./cfn-submit-helper.sh; \
     aws cloudformation list-stacks --region ${REGION} --stack-status-filter CREATE_COMPLETE --output=json | jq '.StackSummaries[] | select(.StackName? | match(\"^mongodb-atlas\"))'; \
     echo 'You can now execute get-started.sh and start using the MongoDB Atlas CFN Resources!'"
