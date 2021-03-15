#!/usr/bin/env bash

#set -x
STACK_NAME="${1:-aws-quickstart}"
MDB=$(aws cloudformation list-exports | \
 jq -r --arg stackname "${STACK_NAME}" \
 '.Exports[] | select(.Name==$stackname+"-ClusterSrvAddress") | .Value')
echo "Found stack:${STACK_NAME} with ClusterSrvAddress: ${MDB}"

STACK_ROLE=$(aws cloudformation describe-stack-resources --stack-name "${STACK_NAME}" --logical-resource-id AtlasIAMRole)
echo "STACK_ROLE=${STACK_ROLE}"

ROLE=$(aws iam get-role --role-name $( echo "${STACK_ROLE}" | jq -r '.StackResources[] | .PhysicalResourceId'))
echo "ROLE=${ROLE}"

ROLE_ARN=$(echo "${ROLE}" | jq -r '.Role.Arn')
echo "ROLE_ARN=${ROLE_ARN}"

ROLE_CREDS=$(aws sts assume-role --role-session-name test --role-arn ${ROLE_ARN})
echo "ROLE_CREDS=${ROLE_CREDS}"
USERNAME=$(echo "${ROLE_CREDS}" | jq -r '.Credentials.AccessKeyId')
echo "USERNAME=${USERNAME}"
PASSWORD=$(echo "${ROLE_CREDS}" | jq -r '.Credentials.SecretAccessKey')
echo "PASSWORD=${PASSWORD}"
TOKEN=$(echo "${ROLE_CREDS}" | jq -r '.Credentials.SessionToken')
echo "TOKEN=${TOKEN}"

mongo "${MDB}/admin?authSource=%24external&authMechanism=MONGODB-AWS" \
    --username "${USERNAME}" \
    --password "${PASSWORD}" \
    --awsIamSessionToken "${TOKEN}" \
    --eval 'db.ServerStatus()'





