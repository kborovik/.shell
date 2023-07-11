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

# List Organization ServeAccount, Users, Groups roles
gcp-list-org-member-roles() {
  if [ "${1}" ] && [ "${2}" ] && [ "$(command -v gcloud)" ]; then
    gcloud organizations get-iam-policy "${2}" \
      --flatten="bindings[].members" \
      --format="table(bindings.role)" \
      --filter="bindings.members:${1}"
  else
    echo "Usage: ${FUNCNAME[0]} <user|group|service_account> <organization_id>"
  fi
}

# List GCP Organization members and filter out GCP service_accounts
gcp-list-org-members() {
  if [ "${1}" ] && [ "$(command -v gcloud)" ]; then
    gcloud organizations get-iam-policy "${1}" \
      --flatten="bindings[].members" \
      --format='value(bindings.members)' |
      sort -u |
      grep -vE 'developer.gserviceaccount.com|cloudservices.gserviceaccount.com|serviceAccount:service-'
  else
    echo "Usage: ${FUNCNAME[0]} <organization_id>"
  fi
}

generate-password-16() {
  gpg --gen-random --armor 1 32 | tr -d /=+ | cut -c -16
}

generate-password-32() {
  gpg --gen-random --armor 1 64 | tr -d /=+ | cut -c -32
}
