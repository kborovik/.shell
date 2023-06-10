#!/usr/bin/env bash

# Decoding JSON Web Tokens (JWT)
jwt-decode() {
  if [ "$(command -v jq)" ]; then
    jq -R 'split(".") | .[0],.[1] | @base64d | fromjson'
  else
    echo "jq not found"
  fi
}

# List ServeAccount, Users, Groups for GCP project
gcp-list-project-member-roles() {
  if [ "${1}" ] && [ "${2}" ] && [ "$(command -v gcloud)" ]; then
    gcloud projects get-iam-policy "${2}" \
      --flatten="bindings[].members" \
      --format="table(bindings.role)" \
      --filter="bindings.members:${1}"
  else
    echo "Usage: ${FUNCNAME[0]} <user|group|service_account> <project_id>"
  fi
}

# List GCP project members and filter out GCP service_accounts
gcp-list-project-members() {
  if [ "${1}" ] && [ "$(command -v gcloud)" ]; then
    gcloud projects get-iam-policy "${1}" \
      --flatten="bindings[].members" \
      --format='value(bindings.members)' |
      sort -u |
      grep -vE 'developer.gserviceaccount.com|cloudservices.gserviceaccount.com|serviceAccount:service-'
  else
    echo "Usage: ${FUNCNAME[0]} <project_id>"
  fi
}
