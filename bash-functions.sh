#!/usr/bin/env bash

gen-pass() {
  gpg --gen-random --armor 1 64 | tr -d '/=+' | cut -c -32 | tr -d '\n'
}

# Get GCP Project ID
gcp-project-id() {
  gcloud config list --format='value(core.project)'
}

# Get GCP Org ID
gcp-org-id() {
  gcloud organizations list --format='value(name)'
}

# List GCP project members and filter out GCP service_accounts
gcp-list-project-members() {
  local google_project="$1"
  
  if [[ -z "$google_project" ]]; then 
    google_project=$(gcloud config list --format='value(core.project)')
  fi
  
  if [[ "$google_project" && "$(command -v gcloud)" ]]; then
    echo "PROJECT: $google_project"
    gcloud projects get-iam-policy "$google_project" \
      --flatten="bindings[].members" \
      --format='value(bindings.members)' | sort -u
  else
    echo "Usage: ${FUNCNAME[0]} <project_id>"
  fi
}

# List ServeAccount, Users, Groups for GCP project
gcp-list-project-member-roles() {
  local google_member="$1"
  local google_project="$2"

  if [[ -z "$google_member" ]]; then
    echo echo "Usage: ${FUNCNAME[0]} <user|group|service_account> <project_id>"
    return 1
  fi
  
  if [[ -z "$google_project" ]]; then
    google_project=$(gcloud config list --format='value(core.project)')
  fi
  
  if [[ "$google_member" && "$google_project" && "$(command -v gcloud)" ]]; then
    echo "PROJECT: $google_project"
    echo "MEMBER: $google_member"
    gcloud projects get-iam-policy "$google_project" \
      --flatten="bindings[].members" \
      --format="table(bindings.role)" \
      --filter="bindings.members:$google_member"
  else
    echo "Usage: ${FUNCNAME[0]} <user|group|service_account> <project_id>"
  fi
}

# List GCP Organization members and filter out GCP service_accounts
gcp-list-org-members() {
  local google_org="$1"

  if [[ -z "$google_org" ]]; then 
    google_org=$(gcloud organizations list --format='value(name)')
  fi
  
  if [[ "$google_org" && "$(command -v gcloud)" ]]; then
    echo "ORG: ${google_org}"
    gcloud organizations get-iam-policy "$google_org" \
      --flatten="bindings[].members" \
      --format='value(bindings.members)' | sort -u
  else
    echo "Usage: ${FUNCNAME[0]} <organization_id>"
  fi
}

# List Organization ServeAccount, Users, Groups roles
gcp-list-org-member-roles() {
  local google_member="${1}"
  local google_org="${2}"

  if [[ -z $google_member ]]; then 
    echo "Usage: ${FUNCNAME[0]} <user|group|service_account> <organization_id>"
    return 1
  fi

  if [[ -z ${google_org} ]]; then
    google_org=$(gcloud organizations list --format='value(name)')
  fi

  if [[ "$google_member" && "${google_org}" && "$(command -v gcloud)" ]]; then
    echo "ORG: ${google_org}"
    echo "MEMBER: $google_member"
    gcloud organizations get-iam-policy ${google_org} \
      --flatten="bindings[].members" \
      --format="table(bindings.role)" \
      --filter="bindings.members:$google_member"
  else
    echo "Usage: ${FUNCNAME[0]} <user|group|service_account> <organization_id>"
  fi
}
