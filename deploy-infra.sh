#!/bin/bash

AWS_ACCOUNT_ID=`aws sts get-caller-identity --query "Account" --output text`
CODEPIPELINE_BUCKET="$STACK_NAME-$REGION-codepipeline-$AWS_ACCOUNT_ID"

STACK_NAME=awsbootstrap
REGION=us-east-1

EC2_INSTANCE_TYPE=t2.micro

echo -e "\n\n========= Deploying setup.yml=========="
aws cloudformation deploy \
  --region $REGION \
  --profile $CLI_PROFILE \
  --stack-name $STACK_NAME-setup \
  --template-file setup.yml \
  --no-fail-on-empty-changeset \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
    CodePipelineBucket=$CODEPIPELINE_BUCKET

echo -e "\n\n========= Deploying main.yml ==========="

aws cloudformation deploy \
  --region $REGION \
  --stack-name $STACK_NAME \
  --template-file main.yml \
  --no-fail-on-empty-changeset \
  --capabilities CAPABILITY_NAMED_IAM \
  --parameter-overrides \
    EC2InstanceType=$EC2_INSTANCE_TYPE

if [ $? -eq 0 ]; then
  aws cloudformation list-exports \
      --query "Exports[?Name=='InstanceEndpoint'].Value"
fi