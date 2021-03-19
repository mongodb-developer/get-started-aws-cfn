#!/usr/bin/env bash

# This script will fetch a new
# CFN SDK from S3 which can be used to build
# the get-started Dockerfile

SDK_BUCKET="${1:-s3://uno-beta-sdk}"
SDK_DIR="cfn-cli-sdk"

mkdir "${SDK_DIR}"
aws s3 cp --recursive "${SDK_BUCKET}" "${SDK_DIR}"
ls -l "${SDK_DIR}"


cp ~/goplugin.zip "${SDK_DIR}"


