#!/usr/bin/env bash

echo "Creating get-started-aws Docker volume ... "
docker volume create get-started-aws
REGION="${1:-us-east-1}"
echo "REGION=${REGION} ..."
#IMAGE="public.ecr.aws/u1r4t8v5/mongodb-developer/get-started-aws-cfn:latest"
IMAGE="mongodb-developer/get-started-aws-cfn:latest"
docker run --rm \
    -v $HOME/.aws:/root/.aws \
    -v get-started-aws:/cache \
    -v "$(pwd)":/workspace \
    -e AWS_DEFAULT_REGION \
    -e AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY \
    -e AWS_SESSION_TOKEN \
    -w /workspace/atlas-aws "${IMAGE}" \
    "/get-setup-aws-cfn.sh ${REGION}"
