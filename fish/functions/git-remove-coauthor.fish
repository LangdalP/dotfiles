function git-remove-coauthor
    set -l current_coauthors (git log -1 --pretty=format:%B | grep "^Co-authored-by:" | sed 's/^Co-authored-by: //')

    if test -z "$current_coauthors"
        echo "No co-authors found on the last commit"
        return 1
    end

    set -l selected_coauthor (printf '%s\n' $current_coauthors | fzf --prompt="Select co-author to remove: ")

    if test -n "$selected_coauthor"
        set -l new_message (git log -1 --pretty=format:%B | grep -v "^Co-authored-by: $selected_coauthor\$")
        git commit --amend -m "$new_message"
        echo "Removed co-author: $selected_coauthor"
    else
        echo "No co-author selected"
    end
end
