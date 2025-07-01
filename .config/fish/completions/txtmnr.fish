# Fish shell completion for txtmnr
# AI-powered PDF document processor
# Target: Fish shell 4.0+

# Helper and support functions
function __txtmnr_complete_document_types
    echo -e "commercial_invoice\nunknown"
end

function __txtmnr_complete_status_types
    echo -e "pending\nprocessing\ncompleted\nfailed"
end

function __txtmnr_has_command
    set -l cmd (commandline -opc)
    if contains -- $argv[1] $cmd
        return 0
    end
    return 1
end

# Main completion logic
complete -c txtmnr -f

# Global flags
complete -c txtmnr -l help -d "Show help information"
complete -c txtmnr -l version -d "Show version information"

# Subcommands
complete -c txtmnr -a process -d "Process a PDF document and extract structured data"
complete -c txtmnr -a query -d "Query processed documents from database"
complete -c txtmnr -a delete -d "Delete a document from the database"
complete -c txtmnr -a stats -d "Show processing statistics"
complete -c txtmnr -a mcp -d "Start Model Context Protocol (MCP) server"

# Process command arguments - PDF file completion for fish 4.0+
complete -c txtmnr -n "__txtmnr_has_command process" -F -a "*.pdf"

# Query command flags
complete -c txtmnr -n "__txtmnr_has_command query" -l id -d "Query specific document by ID"
complete -c txtmnr -n "__txtmnr_has_command query" -l sha256 -d "Query specific document by SHA256 checksum"
complete -c txtmnr -n "__txtmnr_has_command query" -l type -d "Filter by document type" -a "(__txtmnr_complete_document_types)"
complete -c txtmnr -n "__txtmnr_has_command query" -l status -d "Filter by processing status" -a "(__txtmnr_complete_status_types)"
complete -c txtmnr -n "__txtmnr_has_command query" -l limit -d "Maximum number of results to return"

# Delete command flags
complete -c txtmnr -n "__txtmnr_has_command delete" -l id -d "Delete document by ID"
complete -c txtmnr -n "__txtmnr_has_command delete" -l sha256 -d "Delete document by SHA256 checksum"

# MCP command flags
complete -c txtmnr -n "__txtmnr_has_command mcp" -l name -d "MCP server name"
complete -c txtmnr -n "__txtmnr_has_command mcp" -l version -d "MCP server version"
