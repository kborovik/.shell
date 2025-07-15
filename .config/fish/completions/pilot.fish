# pilot fish shell completion

# Helper functions
function __pilot_get_cmd_context
    set -l cmd (commandline -opc)
    set -e cmd[1] # Remove 'pilot'
    echo $cmd
end

function __pilot_uses_command
    set -l cmd (__pilot_get_cmd_context)
    set -l search_cmd $argv[1]

    for i in $cmd
        if test $i = $search_cmd
            return 0
        end
    end
    return 1
end

function __pilot_no_subcommand
    set -l cmd (commandline -opc)
    # Check if we only have "pilot" on the command line
    test (count $cmd) -eq 1
end

# Disable file completion for base pilot command
complete -c pilot -f

# Main pilot command - use not __fish_seen_subcommand_from for base commands
complete -c pilot -f -n "not __fish_seen_subcommand_from completion account email serve db" -a "completion" -d "Generate shell completions"
complete -c pilot -f -n "not __fish_seen_subcommand_from completion account email serve db" -a "account" -d "Manage Gmail accounts"
complete -c pilot -f -n "not __fish_seen_subcommand_from completion account email serve db" -a "email" -d "Email management commands"
complete -c pilot -f -n "not __fish_seen_subcommand_from completion account email serve db" -a "serve" -d "Start server components"
complete -c pilot -f -n "not __fish_seen_subcommand_from completion account email serve db" -a "db" -d "Database operations"

# Completion subcommands
complete -c pilot -f -n "__pilot_uses_command completion; and not __fish_seen_subcommand_from fish" -a "fish" -d "Generate fish shell completions"

# Account subcommands
complete -c pilot -f -n "__pilot_uses_command account; and not __fish_seen_subcommand_from list create show delete stats validate" -a "list" -d "List all Gmail accounts"
complete -c pilot -f -n "__pilot_uses_command account; and not __fish_seen_subcommand_from list create show delete stats validate" -a "create" -d "Create a new Gmail account"
complete -c pilot -f -n "__pilot_uses_command account; and not __fish_seen_subcommand_from list create show delete stats validate" -a "show" -d "Show detailed information for a specific account"
complete -c pilot -f -n "__pilot_uses_command account; and not __fish_seen_subcommand_from list create show delete stats validate" -a "delete" -d "Remove an account from the system"
complete -c pilot -f -n "__pilot_uses_command account; and not __fish_seen_subcommand_from list create show delete stats validate" -a "stats" -d "Show system-wide account statistics"
complete -c pilot -f -n "__pilot_uses_command account; and not __fish_seen_subcommand_from list create show delete stats validate" -a "validate" -d "Validate account connectivity and credentials"

# Account create flags
complete -c pilot -n "__fish_seen_subcommand_from account; and __fish_seen_subcommand_from create" -l "auth-file" -r -d "Path to Google service account JSON file"

# Account validate flags and positional argument
complete -c pilot -n "__fish_seen_subcommand_from account; and __fish_seen_subcommand_from validate" -l "auth-file" -r -d "Path to Google service account JSON file"

# Email subcommands
complete -c pilot -f -n "__pilot_uses_command email; and not __fish_seen_subcommand_from fetch list search thread show delete export" -a "fetch" -d "Fetch new emails from Gmail"
complete -c pilot -f -n "__pilot_uses_command email; and not __fish_seen_subcommand_from fetch list search thread show delete export" -a "list" -d "List emails"
complete -c pilot -f -n "__pilot_uses_command email; and not __fish_seen_subcommand_from fetch list search thread show delete export" -a "search" -d "Search emails"
complete -c pilot -f -n "__pilot_uses_command email; and not __fish_seen_subcommand_from fetch list search thread show delete export" -a "thread" -d "View email thread"
complete -c pilot -f -n "__pilot_uses_command email; and not __fish_seen_subcommand_from fetch list search thread show delete export" -a "show" -d "Show detailed information for a specific email"
complete -c pilot -f -n "__pilot_uses_command email; and not __fish_seen_subcommand_from fetch list search thread show delete export" -a "delete" -d "Delete an email"
complete -c pilot -f -n "__pilot_uses_command email; and not __fish_seen_subcommand_from fetch list search thread show delete export" -a "export" -d "Export emails to various formats"

# Email fetch flags (supports positional argument OR --all flag)
complete -c pilot -f -n "__fish_seen_subcommand_from email; and __fish_seen_subcommand_from fetch" -l "all" -d "Fetch emails for all accounts"

# Email list flags
complete -c pilot -f -n "__fish_seen_subcommand_from email; and __fish_seen_subcommand_from list" -l "account" -r -d "Filter by account email address"
complete -c pilot -f -n "__fish_seen_subcommand_from email; and __fish_seen_subcommand_from list" -l "limit" -r -d "Number of emails to display (default: 10)"
complete -c pilot -f -n "__fish_seen_subcommand_from email; and __fish_seen_subcommand_from list" -l "unread" -d "Show only unread emails"
complete -c pilot -f -n "__fish_seen_subcommand_from email; and __fish_seen_subcommand_from list" -l "subject" -r -d "Filter by subject (partial match)"
complete -c pilot -f -n "__fish_seen_subcommand_from email; and __fish_seen_subcommand_from list" -l "from" -r -d "Filter by sender email address"
complete -c pilot -f -n "__fish_seen_subcommand_from email; and __fish_seen_subcommand_from list" -l "to" -r -d "Filter by recipient email address"
complete -c pilot -f -n "__fish_seen_subcommand_from email; and __fish_seen_subcommand_from list" -l "thread-id" -r -d "Filter by thread ID"
complete -c pilot -f -n "__fish_seen_subcommand_from email; and __fish_seen_subcommand_from list" -l "has-attachments" -d "Show only emails with attachments"
complete -c pilot -f -n "__fish_seen_subcommand_from email; and __fish_seen_subcommand_from list" -l "received" -r -d "Filter by received date (e.g., '2024-01-01', 'today', 'last-7d')"
complete -c pilot -f -n "__fish_seen_subcommand_from email; and __fish_seen_subcommand_from list" -l "sent" -r -d "Filter by sent date (e.g., '2024-01-01', '2024-01-01..2024-01-31')"

# Email search flags
complete -c pilot -f -n "__fish_seen_subcommand_from email; and __fish_seen_subcommand_from search" -l "email" -r -d "Email address of account (required)"
complete -c pilot -f -n "__fish_seen_subcommand_from email; and __fish_seen_subcommand_from search" -l "query" -r -d "Search query"
complete -c pilot -f -n "__fish_seen_subcommand_from email; and __fish_seen_subcommand_from search" -l "from" -r -d "Filter by sender"
complete -c pilot -f -n "__fish_seen_subcommand_from email; and __fish_seen_subcommand_from search" -l "subject" -r -d "Filter by subject"
complete -c pilot -f -n "__fish_seen_subcommand_from email; and __fish_seen_subcommand_from search" -l "limit" -r -d "Maximum results (default: 10)"

# Email thread flags (supports positional argument for thread ID)
complete -c pilot -f -n "__fish_seen_subcommand_from email; and __fish_seen_subcommand_from thread" -l "account" -r -d "Email address of account (optional)"

# Email show - no flags, just positional argument for email ID

# Email delete flags (supports positional argument for email ID)
complete -c pilot -f -n "__fish_seen_subcommand_from email; and __fish_seen_subcommand_from delete" -l "force" -d "Skip confirmation"

# Email export flags
complete -c pilot -f -n "__fish_seen_subcommand_from email; and __fish_seen_subcommand_from export" -l "email" -r -d "Email address of account (required)"
complete -c pilot -f -n "__fish_seen_subcommand_from email; and __fish_seen_subcommand_from export" -l "format" -r -a "json csv" -d "Export format (default: json)"
complete -c pilot -n "__fish_seen_subcommand_from email; and __fish_seen_subcommand_from export" -l "output" -r -d "Output file path"
complete -c pilot -f -n "__fish_seen_subcommand_from email; and __fish_seen_subcommand_from export" -l "limit" -r -d "Maximum emails to export (default: 100)"

# Serve subcommands
complete -c pilot -f -n "__pilot_uses_command serve; and not __fish_seen_subcommand_from api mcp" -a "api" -d "Start REST API server"
complete -c pilot -f -n "__pilot_uses_command serve; and not __fish_seen_subcommand_from api mcp" -a "mcp" -d "Start MCP server"

# Serve api flags
complete -c pilot -f -n "__fish_seen_subcommand_from serve; and __fish_seen_subcommand_from api" -l "port" -r -d "Port to listen on (default: 8080)"

# Serve mcp flags
complete -c pilot -f -n "__fish_seen_subcommand_from serve; and __fish_seen_subcommand_from mcp" -l "transport" -r -a "stdio sse" -d "Transport type (default: stdio)"

# Database subcommands
complete -c pilot -f -n "__pilot_uses_command db; and not __fish_seen_subcommand_from schema status" -a "schema" -d "Database schema operations"
complete -c pilot -f -n "__pilot_uses_command db; and not __fish_seen_subcommand_from schema status" -a "status" -d "Show database status"

# Database schema subcommands
complete -c pilot -f -n "__fish_seen_subcommand_from db; and __fish_seen_subcommand_from schema; and not __fish_seen_subcommand_from create show" -a "create" -d "Create database schema"
complete -c pilot -f -n "__fish_seen_subcommand_from db; and __fish_seen_subcommand_from schema; and not __fish_seen_subcommand_from create show" -a "show" -d "Show database tables and record counts"

# Global flags
complete -c pilot -f -l "help" -s "h" -d "Show help"
complete -c pilot -f -l "version" -s "v" -d "Show version"
complete -c pilot -f -l "debug" -d "Enable debug logging"
complete -c pilot -f -l "format" -r -a "json table yaml" -d "Output format"
