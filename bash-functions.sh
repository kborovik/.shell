#!/usr/bin/env bash

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

# Get GCP Project ID
gcp-project-id() {
  gcloud config list --format='value(core.project)'
}

# Get GCP Org ID
gcp-org-id() {
  project_id=$(gcloud config list --format='value(core.project)')
  gcloud projects get-ancestors ${project_id} --format='value(id,type)' | grep organization | cut -f1
}

# Passwd generator
gen-pass-16() {
  gpg --gen-random --armor 1 32 | tr -d '/=+' | cut -c -16 | tr -d '\n'
}

gen-pass-32() {
  gpg --gen-random --armor 1 64 | tr -d '/=+' | cut -c -32 | tr -d '\n'
}

# PDF Files
pdf-optimize() {
  if [ "${1}" ]; then
    gs -sDEVICE=pdfwrite -dCompatibilityLevel=2.0 -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile="${1%.pdf}-optimized.pdf" "${1}"
  else
    echo "Usage: ${FUNCNAME[0]} <input_file.pdf>"
  fi
}

history-clean() {
  awk '!seen[$0]++' ~/.bash_history >| ~/.bash_history
}