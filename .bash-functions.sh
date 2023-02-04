#!/usr/bin/env bash

# Decoding JSON Web Tokens (JWT)
jwt-decode() {
  if [ "$(command -v jq)" ]; then
    jq -R 'split(".") | .[0],.[1] | @base64d | fromjson'
  else
    echo "jq not found"
  fi
}

# List GCP Service Account project roles
gcp-service_account-project-roles() {
  if [ "${1}" ] && [ "${2}" ] && [ "$(command -v gcloud)" ]; then
    gcloud projects get-iam-policy "${1}" \
      --flatten="bindings[].members" \
      --format="table(bindings.role)" \
      --filter="bindings.members:${2}"
  else
    echo "Usage: ${FUNCNAME[0]} <project_id> <service_account_email>"
  fi
}
