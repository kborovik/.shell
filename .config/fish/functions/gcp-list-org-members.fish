function gcp-list-org-members
    set -l google_org $argv[1]

    if test -z "$google_org"
        set google_org (gcloud organizations list --format='value(name)')
    end

    if test -n "$google_org" -a (command -v gcloud)
        echo "ORG: $google_org"
        gcloud organizations get-iam-policy "$google_org" \
            --flatten="bindings[].members" \
            --format='value(bindings.members)' | sort -u
    else
        echo "Usage: "(status function)" <organization_id>"
    end
end
