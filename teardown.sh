#!/usr/bin/env bash

STACK_NAME=${1:-"get-started-aws-quickstart"}
IMAGE="${2:-atlas-aws}"
echo "Executing ... "
echo "Tearing down quickstart stack name: ${STACK_NAME}"

docker run -it --rm \
    -v $HOME/.aws:/root/.aws \
    -v get-started-aws:/cache \
    -v "$(pwd)":/workspace \
    -w /workspace/atlas-aws "${IMAGE}" \
     "aws cloudformation delete-stack --stack-name ${STACK_NAME}; \
     echo 'Stack deleted.';"

echo "Checking stack events from local machine:"
aws cloudformation describe-stack-events --stack-name ${STACK_NAME} \
