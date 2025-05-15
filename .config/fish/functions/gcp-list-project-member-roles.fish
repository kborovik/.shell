function gcp-list-project-member-roles
    set -l google_member $argv[1]
    set -l google_project $argv[2]

    if test -z "$google_member"
        echo "Usage: gcp-list-project-member-roles <user|group|service_account> <project_id>"
        return 1
    end

    if test -z "$google_project"
        set google_project (gcloud config list --format='value(core.project)')
    end

    if test -n "$google_member" -a -n "$google_project" -a (command -v gcloud >/dev/null 2>&1)
        echo "PROJECT: $google_project"
        echo "MEMBER: $google_member"
        gcloud projects get-iam-policy "$google_project" \
            --flatten="bindings[].members" \
            --format="table(bindings.role)" \
            --filter="bindings.members:$google_member"
    else
        echo "Usage: gcp-list-project-member-roles <user|group|service_account> <project_id>"
    end
end
