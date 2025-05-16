set --local command document database settings

complete --command text-miner --exclusive

complete --command text-miner --condition __fish_use_subcommand --arguments document --description "Document management"
complete --command text-miner --condition "__fish_seen_subcommand_from document" --long write --description "Write document" --require-parameter --force-files
complete --command text-miner --condition "__fish_seen_subcommand_from document" --long read --description "Read document" --require-parameter --force-files
complete --command text-miner --condition "__fish_seen_subcommand_from document" --long delete --description "Delete document" --require-parameter --force-files
complete --command text-miner --condition "__fish_seen_subcommand_from document" --long export --description "Export document" --require-parameter --force-files
complete --command text-miner --condition "__fish_seen_subcommand_from document" --long list --description "List documents"

complete --command text-miner --condition __fish_use_subcommand --arguments database --description "Database management"
complete --command text-miner --condition "__fish_seen_subcommand_from database" --long schema-show --description "Show schema"
complete --command text-miner --condition "__fish_seen_subcommand_from database" --long schema-drop --description "Drop schema"

complete --command text-miner --condition __fish_use_subcommand --arguments settings --description "Settings management"
complete --command text-miner --condition "__fish_seen_subcommand_from settings" --long list --description "List settings"
