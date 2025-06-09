# Fish shell completions for Bun CLI
# https://bun.sh

# bunx command (separate from bun x)
complete -c bunx -f -a "(__fish_complete_suffix)"

# Main bun command completions
complete -c bun -f

# Subcommands
complete -c bun -n __fish_use_subcommand -a add -d "Add a dependency"
complete -c bun -n __fish_use_subcommand -a build -d "Bundle TypeScript/JavaScript"
complete -c bun -n __fish_use_subcommand -a create -d "Create a new project from template"
complete -c bun -n __fish_use_subcommand -a dev -d "Start development server"
complete -c bun -n __fish_use_subcommand -a init -d "Initialize a new project"
complete -c bun -n __fish_use_subcommand -a install -d "Install dependencies"
complete -c bun -n __fish_use_subcommand -a link -d "Link a local package"
complete -c bun -n __fish_use_subcommand -a outdated -d "Check for outdated dependencies"
complete -c bun -n __fish_use_subcommand -a pm -d "Package manager commands"
complete -c bun -n __fish_use_subcommand -a publish -d "Publish package to registry"
complete -c bun -n __fish_use_subcommand -a remove -d "Remove a dependency"
complete -c bun -n __fish_use_subcommand -a run -d "Run a script or package.json script"
complete -c bun -n __fish_use_subcommand -a start -d "Start production server"
complete -c bun -n __fish_use_subcommand -a test -d "Run tests"
complete -c bun -n __fish_use_subcommand -a unlink -d "Unlink a local package"
complete -c bun -n __fish_use_subcommand -a update -d "Update dependencies"
complete -c bun -n __fish_use_subcommand -a upgrade -d "Upgrade bun to latest version"
complete -c bun -n __fish_use_subcommand -a x -d "Execute a package (alias for bunx)"

# Global flags for bun command
complete -c bun -l all -d "Use All options"
complete -c bun -l config -d "Specify config file" -r -a "(__fish_complete_suffix)"
complete -c bun -l cwd -d "Change working directory" -r -a "(__fish_complete_directories)"
complete -c bun -l env-file -d "Load environment variables from file" -r
complete -c bun -l global -d "Use Global namespace"
complete -c bun -l help -d "Show help"
complete -c bun -l hot -d "Enable hot reloading"
complete -c bun -l port -d "Specify port number" -r
complete -c bun -l print -d "Print a value and exit"
complete -c bun -l silent -d "Suppress output"
complete -c bun -l verbose -d "Enable verbose output"
complete -c bun -l version -d "Show version"
complete -c bun -l watch -d "Enable watch mode"

# bun pm completions
complete -c bun -n "__fish_seen_subcommand_from pm; and not __fish_seen_subcommand_from cache bin ls hash hash-string hash-print" -a bin -d "Print the path to the bin folder"
complete -c bun -n "__fish_seen_subcommand_from pm; and not __fish_seen_subcommand_from cache bin ls hash hash-string hash-print" -a cache -d "Print the path to the cache folder"
complete -c bun -n "__fish_seen_subcommand_from pm; and not __fish_seen_subcommand_from cache bin ls hash hash-string hash-print" -a hash -d "Generate a hash of the lockfile"
complete -c bun -n "__fish_seen_subcommand_from pm; and not __fish_seen_subcommand_from cache bin ls hash hash-string hash-print" -a hash-print -d "Print the hash stored in bun.lockb"
complete -c bun -n "__fish_seen_subcommand_from pm; and not __fish_seen_subcommand_from cache bin ls hash hash-string hash-print" -a hash-string -d "Print the hash stored in bun.lockb"
complete -c bun -n "__fish_seen_subcommand_from pm; and not __fish_seen_subcommand_from cache bin ls hash hash-string hash-print" -a ls -d "List installed packages"

# bun run completions
complete -c bun -n "__fish_seen_subcommand_from run" -l bun -d "Force usage of Bun runtime"
complete -c bun -n "__fish_seen_subcommand_from run" -l help -d "Show help for run command"
complete -c bun -n "__fish_seen_subcommand_from run" -l hot -d "Enable hot reloading"
complete -c bun -n "__fish_seen_subcommand_from run" -l if-present -d "Don't error if script doesn't exist"
complete -c bun -n "__fish_seen_subcommand_from run" -l silent -d "Don't print the script command"
complete -c bun -n "__fish_seen_subcommand_from run" -l watch -d "Restart on file changes"
complete -c bun -n "__fish_seen_subcommand_from run" -x -a "(__fish_complete_suffix)"

# bun install completions
complete -c bun -n "__fish_seen_subcommand_from install" -l concurrent-scripts -d "Maximum number of concurrent lifecycle scripts" -r
complete -c bun -n "__fish_seen_subcommand_from install" -l dry-run -d "Don't install, just print what would be done"
complete -c bun -n "__fish_seen_subcommand_from install" -l force -d "Always request the latest versions"
complete -c bun -n "__fish_seen_subcommand_from install" -l frozen-lockfile -d "Don't update the lockfile"
complete -c bun -n "__fish_seen_subcommand_from install" -l global -d "Install globally"
complete -c bun -n "__fish_seen_subcommand_from install" -l help -d "Show help for install command"
complete -c bun -n "__fish_seen_subcommand_from install" -l ignore-scripts -d "Skip lifecycle scripts"
complete -c bun -n "__fish_seen_subcommand_from install" -l no-cache -d "Ignore manifest cache entirely"
complete -c bun -n "__fish_seen_subcommand_from install" -l no-progress -d "Disable progress bar"
complete -c bun -n "__fish_seen_subcommand_from install" -l no-save -d "Don't save to package.json"
complete -c bun -n "__fish_seen_subcommand_from install" -l no-summary -d "Don't print a summary"
complete -c bun -n "__fish_seen_subcommand_from install" -l no-verify -d "Skip verifying integrity of newly downloaded packages"
complete -c bun -n "__fish_seen_subcommand_from install" -l production -d "Don't install devDependencies"
complete -c bun -n "__fish_seen_subcommand_from install" -l silent -d "No logging"
complete -c bun -n "__fish_seen_subcommand_from install" -l trust -d "Add to trusted dependencies list"
complete -c bun -n "__fish_seen_subcommand_from install" -l verbose -d "Verbose logging"
complete -c bun -n "__fish_seen_subcommand_from install" -l yarn -d "Generate yarn.lock"

# bun add completions
complete -c bun -n "__fish_seen_subcommand_from add" -l dev -d "Add to devDependencies"
complete -c bun -n "__fish_seen_subcommand_from add" -l development -d "Add to devDependencies"
complete -c bun -n "__fish_seen_subcommand_from add" -l dry-run -d "Don't install, just print what would be done"
complete -c bun -n "__fish_seen_subcommand_from add" -l exact -d "Add exact version"
complete -c bun -n "__fish_seen_subcommand_from add" -l force -d "Always request the latest versions"
complete -c bun -n "__fish_seen_subcommand_from add" -l global -d "Install globally"
complete -c bun -n "__fish_seen_subcommand_from add" -l help -d "Show help for add command"
complete -c bun -n "__fish_seen_subcommand_from add" -l no-save -d "Don't save to package.json"
complete -c bun -n "__fish_seen_subcommand_from add" -l optional -d "Add to optionalDependencies"
complete -c bun -n "__fish_seen_subcommand_from add" -l peer -d "Add to peerDependencies"
complete -c bun -n "__fish_seen_subcommand_from add" -l trust -d "Add to trusted dependencies list"

# bun remove completions
complete -c bun -n "__fish_seen_subcommand_from remove" -l global -d "Remove from global packages"
complete -c bun -n "__fish_seen_subcommand_from remove" -l help -d "Show help for remove command"

# bun update completions
complete -c bun -n "__fish_seen_subcommand_from update" -l help -d "Show help for update command"

# bun test completions
complete -c bun -n "__fish_seen_subcommand_from test" -l bail -d "Stop after first test failure" -r
complete -c bun -n "__fish_seen_subcommand_from test" -l concurrency -d "Number of tests to run concurrently" -r
complete -c bun -n "__fish_seen_subcommand_from test" -l coverage -d "Generate code coverage report"
complete -c bun -n "__fish_seen_subcommand_from test" -l help -d "Show help for test command"
complete -c bun -n "__fish_seen_subcommand_from test" -l only -d "Only run tests marked with .only"
complete -c bun -n "__fish_seen_subcommand_from test" -l reporter -d "Test reporter" -r -a "spec default verbose json"
complete -c bun -n "__fish_seen_subcommand_from test" -l timeout -d "Set test timeout in milliseconds" -r
complete -c bun -n "__fish_seen_subcommand_from test" -l todo -d "Include tests marked as .todo"
complete -c bun -n "__fish_seen_subcommand_from test" -l update-snapshots -d "Update snapshots"
complete -c bun -n "__fish_seen_subcommand_from test" -l watch -d "Watch for changes and re-run tests"

# bun build completions
complete -c bun -n "__fish_seen_subcommand_from build" -l asset-naming -d "Asset file naming pattern" -r
complete -c bun -n "__fish_seen_subcommand_from build" -l chunk-naming -d "Chunk file naming pattern" -r
complete -c bun -n "__fish_seen_subcommand_from build" -l compile -d "Compile to executable"
complete -c bun -n "__fish_seen_subcommand_from build" -l define -d "Define global variables" -r
complete -c bun -n "__fish_seen_subcommand_from build" -l entry-naming -d "Entry file naming pattern" -r
complete -c bun -n "__fish_seen_subcommand_from build" -l external -d "Mark packages as external" -r
complete -c bun -n "__fish_seen_subcommand_from build" -l format -d "Output format" -r -a "esm cjs iife"
complete -c bun -n "__fish_seen_subcommand_from build" -l help -d "Show help for build command"
complete -c bun -n "__fish_seen_subcommand_from build" -l loader -d "File extension loader mapping" -r
complete -c bun -n "__fish_seen_subcommand_from build" -l minify -d "Minify output"
complete -c bun -n "__fish_seen_subcommand_from build" -l no-bundle -d "Don't bundle dependencies"
complete -c bun -n "__fish_seen_subcommand_from build" -l outdir -d "Output directory" -r -a "(__fish_complete_directories)"
complete -c bun -n "__fish_seen_subcommand_from build" -l outfile -d "Output file" -r -a "(__fish_complete_path)"
complete -c bun -n "__fish_seen_subcommand_from build" -l public-path -d "Public path for assets" -r
complete -c bun -n "__fish_seen_subcommand_from build" -l sourcemap -d "Generate sourcemap" -r -a "none inline external"
complete -c bun -n "__fish_seen_subcommand_from build" -l splitting -d "Enable code splitting"
complete -c bun -n "__fish_seen_subcommand_from build" -l target -d "Build target" -r -a "browser node bun"
complete -c bun -n "__fish_seen_subcommand_from build" -l watch -d "Watch for changes and rebuild"

# bun create completions
complete -c bun -n "__fish_seen_subcommand_from create" -l help -d "Show help for create command"

# bun init completions
complete -c bun -n "__fish_seen_subcommand_from init" -l help -d "Show help for init command"
complete -c bun -n "__fish_seen_subcommand_from init" -l yes -d "Accept all default options"

# bun upgrade completions
complete -c bun -n "__fish_seen_subcommand_from upgrade" -l help -d "Show help for upgrade command"

# bun outdated completions
complete -c bun -n "__fish_seen_subcommand_from outdated" -l help -d "Show help for outdated command"

# bun publish completions
complete -c bun -n "__fish_seen_subcommand_from publish" -l access -d "Set package access" -r -a "public restricted"
complete -c bun -n "__fish_seen_subcommand_from publish" -l auth-type -d "Authentication type for 2FA" -r -a "web legacy"
complete -c bun -n "__fish_seen_subcommand_from publish" -l dry-run -d "Don't publish, just show what would be done"
complete -c bun -n "__fish_seen_subcommand_from publish" -l help -d "Show help for publish command"
complete -c bun -n "__fish_seen_subcommand_from publish" -l otp -d "One-time password for 2FA" -r
complete -c bun -n "__fish_seen_subcommand_from publish" -l tag -d "Publish with tag" -r
