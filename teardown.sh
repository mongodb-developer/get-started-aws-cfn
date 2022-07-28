#!/usr/bin/env bash

QUICKSTART_NAME=${1:-"get-started-aws-quickstart"}
IMAGE="${2:-atlas-aws}"

echo "Executing..."
echo "Tearing down quickstart stack named ${QUICKSTART_NAME}"

docker run -it --rm \
    -v $HOME/.aws:/root/.aws \
    -v get-started-aws:/cache \
    -v "$(pwd)":/workspace \
    -w /workspace/atlas-aws "${IMAGE}" \
     "aws cloudformation delete-stack --stack-name ${QUICKSTART_NAME}; \
     echo 'Stack deleted.'"

echo "Checking stack events from local machine:"
aws cloudformation describe-stack-events --stack-name ${QUICKSTART_NAME} \
