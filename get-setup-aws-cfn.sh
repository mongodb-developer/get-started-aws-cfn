#!/usr/bin/env bash

REGION="${1:-us-east-1}"
echo "REGION=${REGION} ..."
cd /quickstart-mongodb-atlas-resources/cfn-resources/
echo 'aws sts-get-caller-identity:'
aws sts get-caller-identity
echo 'Registering and deploying MongoDB Atlas AWS CloudFormation Resources, this may take a while...'
CFN_FLAGS="--verbose --set-default --region ${REGION}" SUBMIT_ONLY=true ./cfn-submit-helper.sh;
echo "----- rpdk.log ------"
cat **/rpdk.log
aws cloudformation list-stacks --region ${REGION} --stack-status-filter CREATE_COMPLETE --output=json | jq '.StackSummaries[] | select(.StackName? | match(\"^mongodb-atlas\"))'
echo 'You can now execute get-started.sh and start using the MongoDB Atlas CFN Resources!'
