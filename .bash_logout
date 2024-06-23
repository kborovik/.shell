# Remove duplicate lines from bash history
awk '!seen[$0]++' ~/.bash_history >|~/.bash_history.tmp
# Replace original history file with deduplicated version
mv ~/.bash_history.tmp ~/.bash_history
