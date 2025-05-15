function gcp-list-project-members
    set -l google_project $argv[1]

    if test -z "$google_project"
        set google_project (gcloud config list --format='value(core.project)')
    end

    if test -n "$google_project" -a (command -v gcloud)
        echo "PROJECT: $google_project"
        gcloud projects get-iam-policy "$google_project" \
            --flatten="bindings[].members" \
            --format='value(bindings.members)' | sort -u
    else
        echo "Usage: "(status function)" <project_id>"
    end
end
