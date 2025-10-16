# fish completion for pilot                                   -*- shell-script -*-

# Helper functions
function __pilot_no_resource
    not __fish_seen_subcommand_from account config email server contact completion
end

function __pilot_using_resource
    __fish_seen_subcommand_from $argv
end

function __pilot_no_action
    set -l resource $argv[1]
    set -l actions $argv[2..]
    __pilot_using_resource $resource; and not __fish_seen_subcommand_from $actions
end

function __pilot_accounts
    env PILOT_LOG_PRETTY=false uv run pilot account list 2>/dev/null | grep -o '"email": "[^"]*"' | cut -d'"' -f4
end

# Global options
complete -c pilot -s d -l debug -d 'Enable debug log messages'
complete -c pilot -l version -d 'Show version and exit'

# Resources
complete -c pilot -n __pilot_no_resource -a account -d 'Manage email accounts' -f
complete -c pilot -n __pilot_no_resource -a config -d 'Manage system configuration' -f
complete -c pilot -n __pilot_no_resource -a email -d 'Email synchronization and management' -f
complete -c pilot -n __pilot_no_resource -a server -d 'Control the Gmail subscription monitoring server' -f
complete -c pilot -n __pilot_no_resource -a contact -d 'Manage contacts from Google People API' -f
complete -c pilot -n __pilot_no_resource -a completion -d 'Manage shell completions' -f

# Account actions
complete -c pilot -n '__pilot_no_action account add list show disable enable' -a add -d 'Add a new email account for monitoring' -f
complete -c pilot -n '__pilot_no_action account add list show disable enable' -a list -d 'List all managed email accounts' -f
complete -c pilot -n '__pilot_no_action account add list show disable enable' -a show -d 'Display detailed information about an account' -f
complete -c pilot -n '__pilot_no_action account add list show disable enable' -a disable -d 'Disable an account from monitoring' -f
complete -c pilot -n '__pilot_no_action account add list show disable enable' -a enable -d 'Re-enable a previously disabled account' -f

# Account options
complete -c pilot -n '__pilot_using_resource account; and __fish_seen_subcommand_from add' -l name -d 'Account name' -r
complete -c pilot -n '__pilot_using_resource account; and __fish_seen_subcommand_from list' -l all -d 'Show all accounts including disabled ones'
complete -c pilot -n '__pilot_using_resource account; and __fish_seen_subcommand_from disable' -l force -d 'Skip confirmation prompt'

# Config actions
complete -c pilot -n '__pilot_no_action config init show validate' -a init -d 'Initialize database schema' -f
complete -c pilot -n '__pilot_no_action config init show validate' -a show -d 'Show current config' -f
complete -c pilot -n '__pilot_no_action config init show validate' -a validate -d 'Validate API access' -f

# Email actions
complete -c pilot -n '__pilot_no_action email list show sync search stats send' -a list -d 'List emails for an account' -f
complete -c pilot -n '__pilot_no_action email list show sync search stats send' -a show -d 'Display full email message details' -f
complete -c pilot -n '__pilot_no_action email list show sync search stats send' -a sync -d 'Synchronize emails for an account' -f
complete -c pilot -n '__pilot_no_action email list show sync search stats send' -a search -d 'Search emails for an account' -f
complete -c pilot -n '__pilot_no_action email list show sync search stats send' -a stats -d 'Show email statistics' -f
complete -c pilot -n '__pilot_no_action email list show sync search stats send' -a send -d 'Send an email message' -f

# Email options
complete -c pilot -n '__pilot_using_resource email' -l account -d 'Account email address' -r -f -a "(__pilot_accounts)"
complete -c pilot -n '__pilot_using_resource email; and __fish_seen_subcommand_from list' -l limit -d 'Maximum number of emails (1-1000)' -r
complete -c pilot -n '__pilot_using_resource email; and __fish_seen_subcommand_from list' -l labels -d 'Comma-separated labels to filter by' -r
complete -c pilot -n '__pilot_using_resource email; and __fish_seen_subcommand_from show' -l id -d 'Gmail message ID' -r
complete -c pilot -n '__pilot_using_resource email; and __fish_seen_subcommand_from sync' -l max-messages -d 'Maximum number of messages to sync' -r
complete -c pilot -n '__pilot_using_resource email; and __fish_seen_subcommand_from search' -s q -l query -d 'Gmail search query' -r
complete -c pilot -n '__pilot_using_resource email; and __fish_seen_subcommand_from send' -l to -d 'Comma-separated recipient email addresses' -r
complete -c pilot -n '__pilot_using_resource email; and __fish_seen_subcommand_from send' -l subject -d 'Email subject line' -r
complete -c pilot -n '__pilot_using_resource email; and __fish_seen_subcommand_from send' -l body -d 'Email body text' -r
complete -c pilot -n '__pilot_using_resource email; and __fish_seen_subcommand_from send' -l body-file -d 'Path to file containing email body' -r -F
complete -c pilot -n '__pilot_using_resource email; and __fish_seen_subcommand_from send' -l cc -d 'Comma-separated CC recipients' -r
complete -c pilot -n '__pilot_using_resource email; and __fish_seen_subcommand_from send' -l bcc -d 'Comma-separated BCC recipients' -r

# Server actions
complete -c pilot -n '__pilot_no_action server start status stop logs' -a start -d 'Start the Gmail subscription monitoring server' -f
complete -c pilot -n '__pilot_no_action server start status stop logs' -a status -d 'Check Gmail subscription monitoring status' -f
complete -c pilot -n '__pilot_no_action server start status stop logs' -a stop -d 'Stop the Gmail subscription monitoring server' -f
complete -c pilot -n '__pilot_no_action server start status stop logs' -a logs -d 'View server logs' -f

# Server options
complete -c pilot -n '__pilot_using_resource server; and __fish_seen_subcommand_from start' -l daemon -d 'Run as background daemon'
complete -c pilot -n '__pilot_using_resource server; and __fish_seen_subcommand_from start' -l log-level -d 'Logging level' -r -f -a "debug info warning error"
complete -c pilot -n '__pilot_using_resource server; and __fish_seen_subcommand_from stop' -l force -d 'Force immediate shutdown'
complete -c pilot -n '__pilot_using_resource server; and __fish_seen_subcommand_from stop' -l timeout -d 'Graceful shutdown timeout in seconds' -r
complete -c pilot -n '__pilot_using_resource server; and __fish_seen_subcommand_from logs' -s n -l lines -d 'Number of lines to show' -r
complete -c pilot -n '__pilot_using_resource server; and __fish_seen_subcommand_from logs' -s f -l follow -d 'Follow log output'

# Contact actions
complete -c pilot -n '__pilot_no_action contact list show search sync group' -a list -d 'List contacts for an account' -f
complete -c pilot -n '__pilot_no_action contact list show search sync group' -a show -d 'Display detailed contact information' -f
complete -c pilot -n '__pilot_no_action contact list show search sync group' -a search -d 'Search contacts' -f
complete -c pilot -n '__pilot_no_action contact list show search sync group' -a sync -d 'Synchronize contacts' -f
complete -c pilot -n '__pilot_no_action contact list show search sync group' -a group -d 'Manage contact groups' -f

# Contact options
complete -c pilot -n '__pilot_using_resource contact; and not __fish_seen_subcommand_from group' -l account -d 'Account email address' -r -f -a "(__pilot_accounts)"
complete -c pilot -n '__pilot_using_resource contact; and __fish_seen_subcommand_from list' -l limit -d 'Maximum number of contacts (1-1000)' -r
complete -c pilot -n '__pilot_using_resource contact; and __fish_seen_subcommand_from list' -l group -d 'Filter by contact group resource name' -r
complete -c pilot -n '__pilot_using_resource contact; and __fish_seen_subcommand_from show' -l email -d 'Contact email address' -r
complete -c pilot -n '__pilot_using_resource contact; and __fish_seen_subcommand_from search' -s q -l query -d 'Search query' -r
complete -c pilot -n '__pilot_using_resource contact; and __fish_seen_subcommand_from search' -l limit -d 'Maximum number of results (1-100)' -r
complete -c pilot -n '__pilot_using_resource contact; and __fish_seen_subcommand_from sync' -l csv-file -d 'Path to CSV file to sync contacts' -r -F
complete -c pilot -n '__pilot_using_resource contact; and __fish_seen_subcommand_from sync' -l max-contacts -d 'Maximum number of contacts to sync from Gmail' -r

# Contact group subcommands
function __pilot_no_group_action
    __pilot_using_resource contact; and __fish_seen_subcommand_from group; and not __fish_seen_subcommand_from create list show update delete add-members remove-members
end

complete -c pilot -n __pilot_no_group_action -a create -d 'Create a new contact group' -f
complete -c pilot -n __pilot_no_group_action -a list -d 'List all contact groups' -f
complete -c pilot -n __pilot_no_group_action -a show -d 'Show contact group details' -f
complete -c pilot -n __pilot_no_group_action -a update -d 'Update (rename) a contact group' -f
complete -c pilot -n __pilot_no_group_action -a delete -d 'Delete a contact group' -f
complete -c pilot -n __pilot_no_group_action -a add-members -d 'Add contacts to a contact group' -f
complete -c pilot -n __pilot_no_group_action -a remove-members -d 'Remove contacts from a contact group' -f

# Contact group options
complete -c pilot -n '__pilot_using_resource contact; and __fish_seen_subcommand_from group' -l account -d 'Account email address' -r -f -a "(__pilot_accounts)"
complete -c pilot -n '__pilot_using_resource contact; and __fish_seen_subcommand_from group; and __fish_seen_subcommand_from create update show delete add-members remove-members' -l name -d 'Contact group name' -r
complete -c pilot -n '__pilot_using_resource contact; and __fish_seen_subcommand_from group; and __fish_seen_subcommand_from list' -l limit -d 'Maximum number of groups (1-1000)' -r
complete -c pilot -n '__pilot_using_resource contact; and __fish_seen_subcommand_from group; and __fish_seen_subcommand_from list' -l type -d 'Filter by group type' -r -f -a "user system"
complete -c pilot -n '__pilot_using_resource contact; and __fish_seen_subcommand_from group; and __fish_seen_subcommand_from update' -l new-name -d 'New group name' -r
complete -c pilot -n '__pilot_using_resource contact; and __fish_seen_subcommand_from group; and __fish_seen_subcommand_from add-members remove-members' -l emails -d 'Comma-separated contact email addresses' -r

# Completion actions
complete -c pilot -n '__pilot_no_action completion install' -a install -d 'Install fish shell completions' -f
