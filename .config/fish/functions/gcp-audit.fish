#!/usr/bin/env fish

function gcp-audit --description "List users and service accounts that accessed a GCP project in the past N days"
    # Parse arguments
    argparse --name=gcp-audit 'd/days=' h/help -- $argv
    or return

    # Show help
    if set -q _flag_help
        echo "Usage: gcp-audit PROJECT_ID [--days DAYS]"
        echo ""
        echo "List users and service accounts that accessed a GCP project in the past N days"
        echo ""
        echo "Arguments:"
        echo "  PROJECT_ID          Google Cloud project ID to audit"
        echo ""
        echo "Options:"
        echo "  -d, --days DAYS     Number of days to look back (default: 7)"
        echo "  -h, --help          Show this help message"
        return 0
    end

    # Check if project ID is provided
    if test (count $argv) -eq 0
        echo "Error: PROJECT_ID is required" >&2
        echo "Run 'gcp-audit --help' for usage information" >&2
        return 1
    end

    set project_id $argv[1]
    set days 7

    # Override days if provided
    if set -q _flag_days
        set days $_flag_days
    end

    echo "Querying audit logs for project '$project_id' (past $days days)..."

    # Query audit logs using gcloud
    set filter 'protoPayload."@type"="type.googleapis.com/google.cloud.audit.AuditLog"'

    echo "Fetching audit log entries..."
    set -l temp_file (mktemp)

    gcloud logging read "$filter" \
        --project="$project_id" \
        --freshness="$days"d \
        --format=json \
        --limit=10000 >$temp_file 2>/dev/null

    if test $status -ne 0
        echo "Error: Failed to query audit logs. Ensure you have:" >&2
        echo "  1. Authenticated with 'gcloud auth login'" >&2
        echo "  2. Proper permissions (e.g., roles/logging.viewer)" >&2
        echo "  3. The correct project ID" >&2
        rm -f $temp_file
        return 1
    end

    # Extract principal emails with last access date and count using jq
    set -l principal_data (cat $temp_file | jq -r 'group_by(.protoPayload.authenticationInfo.principalEmail) | map(select(.[0].protoPayload.authenticationInfo.principalEmail != null)) | map({principal: .[0].protoPayload.authenticationInfo.principalEmail, last_access: (map(.timestamp) | max), count: length}) | .[] | "\(.principal)|\(.last_access)|\(.count)"')

    # Clean up temp file
    rm -f $temp_file

    # Separate users from service accounts with parallel arrays for dates and counts
    set -l service_accounts
    set -l service_account_dates
    set -l service_account_counts
    set -l users
    set -l user_dates
    set -l user_counts

    for entry in $principal_data
        set -l parts (string split "|" $entry)
        set -l principal $parts[1]
        set -l last_access $parts[2]
        set -l access_count $parts[3]

        # Format the date to be more readable (YYYY-MM-DD)
        set -l formatted_date (string replace -r 'T.*' '' $last_access)

        if string match -q "*.gserviceaccount.com" $principal
            set -a service_accounts $principal
            set -a service_account_dates $formatted_date
            set -a service_account_counts $access_count
        else
            set -a users $principal
            set -a user_dates $formatted_date
            set -a user_counts $access_count
        end
    end

    # Display results
    echo ""
    echo "=== AUDIT RESULTS FOR PROJECT: $project_id ==="
    echo ""
    echo "Users ("(count $users)"):"
    if test (count $users) -gt 0
        for i in (seq (count $users))
            echo "  - $users[$i] (Last access: $user_dates[$i], $user_counts[$i] accesses)"
        end
    else
        echo "  (none)"
    end

    echo ""
    echo "Service Accounts ("(count $service_accounts)"):"
    if test (count $service_accounts) -gt 0
        for i in (seq (count $service_accounts))
            echo "  - $service_accounts[$i] (Last access: $service_account_dates[$i], $service_account_counts[$i] accesses)"
        end
    else
        echo "  (none)"
    end

    echo ""
    set -l total_principals (math (count $users) + (count $service_accounts))
    echo "Total unique principals: $total_principals"
end
