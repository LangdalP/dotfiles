#! /usr/bin/env bash

# This is meant to be sourced
# Required args: Path to key file

gcloud auth activate-service-account --key-file=$1
export GOOGLE_APPLICATION_CREDENTIALS=$1

PROJECT_ID=$(cat $1 | jq -r '.project_id')
gcloud config set project $PROJECT_ID

echo "$1 activated in gcloud and exported as GOOGLE_APPLICATION_CREDENTIALS"
echo "$PROJECT_ID set as active project in gcloud"

