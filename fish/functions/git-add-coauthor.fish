# Litt om trailers:
# https://git-scm.com/docs/SubmittingPatches
# https://git-scm.com/docs/git-interpret-trailers
function git-add-coauthor
    set -l selected_author (git log --format='%aN <%aE>' | sort -u | fzf --prompt="Select co-author: ")

    if test -n "$selected_author"
        set -l msg (git log -1 --pretty=format:%B | string collect)
        set -l new_message "$msg"\n\n"Co-authored-by: $selected_author"
        git commit --amend --no-verify -m "$new_message"
        echo "Added co-author: $selected_author"
    else
        echo "No author selected"
    end
end
