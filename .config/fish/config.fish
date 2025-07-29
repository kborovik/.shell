if status is-interactive

    fish_add_path --global ~/.claude/local ~/go/bin ~/.cargo/bin ~/.local/bin ~/.bun/bin ~/.npm-global/bin /opt/homebrew/bin /opt/homebrew/opt/make/libexec/gnubin

    set --global --export EDITOR vim
    set --global --export VISUAL vim
    set --global --export PAGER "less -R -F -i"

    set --global __fish_git_prompt_show_informative_status true
    set --global __fish_git_prompt_showcolorhints true
    set --global __fish_git_prompt_showstashstate true
    set --global __fish_git_prompt_showuntrackedfiles true

    set --global __fish_git_prompt_char_stateseparator ' '
    set --global __fish_git_prompt_char_untrackedfiles '^'
    set --global __fish_git_prompt_char_dirtystate '!'
    set --global __fish_git_prompt_char_stagedstate '+'
    set --global __fish_git_prompt_char_invalidstate '#'
    set --global __fish_git_prompt_char_stashstate '&'

    set --global __fish_git_prompt_color_branch 8bd5ca
    set --global __fish_git_prompt_color_untrackedfiles c6a0f6
    set --global __fish_git_prompt_color_upstream 8aadf4
    set --global __fish_git_prompt_color_stashstate eed49f
    set --global __fish_git_prompt_color_cleanstate a6da95
    set --global __fish_git_prompt_color_merging c6a0f6

    # Define Aliases

    function tokens-calc --description 'Calculate approximate number of LLM tokens in a file'
        if test (count $argv) -eq 0
            echo "Usage: tokens <filename>"
            return 1
        end
        set -l file $argv[1]
        if not test -f $file
            echo "Error: File '$file' not found"
            return 1
        end
        set -l chars (wc -m < $file | string trim)
        set -l words (wc -w < $file | string trim)
        set -l avg_tokens (math "round(($chars / 4 + $words / 0.75) / 2)")
        printf "Approximate tokens: %'d\n" $avg_tokens
    end

    function gaa --description 'git add --all'
        git add --all $argv
    end

    function gc --description 'git commit'
        git commit $argv
    end

    function gd --description 'git difftool'
        git difftool $argv
    end

    function gs --description 'git difftool --staged'
        git difftool --staged $argv
    end

    function gl --description 'git fetch --all --tags'
        git fetch --all --tags $argv
    end

    function gk --description 'git pull --all --tags'
        git pull --all --tags $argv
    end

    function glo --description 'git log with pretty format'
        git log --pretty=format:'%C(#b7bdf8)%h %C(#eed49f)%d%Creset %C(#b8c0e0)(%cr)%Creset %C(#7dc4e4)%cn %Creset %C(#cad3f5)%s' $argv
    end

    function gloa --description 'git log graph with pretty format'
        git log --graph --all --pretty=format:'%C(#b7bdf8)%h %C(#eed49f)%d%Creset %C(#b8c0e0)(%cr)%Creset %C(#7dc4e4)%cn %Creset %C(#cad3f5)%s' $argv
    end

    function gp --description 'git push'
        git push $argv
    end

    function gst --description 'git status'
        git status $argv
    end

    function la --description 'ls -ha'
        ls -ha $argv
    end

    function ll --description 'ls -hlF'
        ls -hlF $argv
    end

    function ls --description 'ls --color=auto'
        command ls --color=auto $argv
    end

    function tree --description 'tree -C'
        command tree -C $argv
    end

    if test (uname) = Darwin; and test -x /opt/homebrew/bin/gln
        function ln --description 'GNU ln replacement'
            /opt/homebrew/bin/gln $argv
        end
    end

end
