awk '!seen[$0]++' ~/.bash_history >| ~/.bash_history_
mv ~/.bash_history_ ~/.bash_history