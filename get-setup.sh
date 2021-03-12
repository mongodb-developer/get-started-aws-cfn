#!/usr/bin/env bash

echo "Creating get-started-aws Docker volume ... "
docker volume create get-started-aws
REGION="${1:-us-east-1}"
IMAGE_REPO=${IMAGE_REPO:-public.ecr.aws/u1r4t8v5/}
IMAGE=${IMAGE:-mongodb-developer/get-started-aws-cfn:latest}
IMG="${IMAGE_REPO}${IMAGE}"

echo "Running get-setup for REGION=${REGION}"
echo "Running Docker image: ${IMG}"
echo "Executing ... "
docker run --rm \
    -v $HOME/.aws:/root/.aws \
    -v get-started-aws:/cache \
    -v "$(pwd)":/workspace \
    -e AWS_DEFAULT_REGION \
    -e AWS_ACCESS_KEY_ID \
    -e AWS_SECRET_ACCESS_KEY \
    -e AWS_SESSION_TOKEN \
    -w /workspace/atlas-aws "${IMG}" \
    "/get-setup-aws-cfn.sh ${REGION}"
