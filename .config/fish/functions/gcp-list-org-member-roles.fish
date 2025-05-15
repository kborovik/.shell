function gcp-list-org-member-roles
    set -l google_member "$argv[1]"
    set -l google_org "$argv[2]"

    if test -z "$google_member"
        echo "Usage: gcp-list-org-member-roles <user|group|service_account> <organization_id>"
        return 1
    end

    if test -z "$google_org"
        set google_org (gcloud organizations list --format='value(name)')
    end

    if test -n "$google_member" -a -n "$google_org" -a (command -v gcloud)
        echo "ORG: $google_org"
        echo "MEMBER: $google_member"
        gcloud organizations get-iam-policy $google_org \
            --flatten="bindings[].members" \
            --format="table(bindings.role)" \
            --filter="bindings.members:$google_member"
    else
        echo "Usage: gcp-list-org-member-roles <user|group|service_account> <organization_id>"
    end
end
