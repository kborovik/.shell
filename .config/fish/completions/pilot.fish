# Fish completion for pilot
# Target: Fish shell 4.0+

function __pilot_complete_commands
    set -l cmd (commandline -opc)
    set -l cur (commandline -ct)

    # Root commands
    if test (count $cmd) -eq 1
        echo "db	Database management commands"
        echo "gmail	Gmail integration commands"
        echo "completion	Generate shell completions"
        echo "version	Show version information"
        return
    end

    # Subcommands
    switch $cmd[2]
        case db
            if test (count $cmd) -eq 2
                echo "status	Check database connection and stats"
                echo "schema	Database schema management"
            else if test (count $cmd) -eq 3 -a "$cmd[3]" = schema
                echo "show	Display embedded schema"
                echo "create	Create database schema"
            end
        case gmail
            if test (count $cmd) -eq 2
                echo "test	Test Gmail API connection and permissions"
            end
        case completion
            if test (count $cmd) -eq 2
                echo "fish	Generate fish completions"
            end
    end
end

# Main completion registration
complete -c pilot -f -a '(__pilot_complete_commands)'

# Global flags
complete -c pilot -l debug -d "Enable debug logging"
complete -c pilot -l log-pretty -d "Enable pretty JSON formatting"
complete -c pilot -l version -d "Show version"
complete -c pilot -l help -d "Show help"

# Command-specific flags
# Gmail test command
complete -c pilot -n "__fish_seen_subcommand_from gmail; and __fish_seen_subcommand_from test" -l email -d "Email address to test" -r
