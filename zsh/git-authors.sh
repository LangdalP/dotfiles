#!/bin/bash

git-list-authors() {
    git log --format='%aN' | sort -u
}

# Litt om trailers:
# https://git-scm.com/docs/SubmittingPatches
# https://git-scm.com/docs/git-interpret-trailers
git-add-coauthor() {
    local authors=$(git log --format='%aN <%aE>' | sort -u)
    local selected_author=$(echo "$authors" | fzf --prompt="Select co-author: ")

    if [[ -n "$selected_author" ]]; then
        git commit --amend --no-verify --no-edit --trailer "Co-authored-by: $selected_author"
        echo "Added co-author: $selected_author"
    else
        echo "No author selected"
    fi
}

git-remove-coauthor() {
    local current_coauthors=$(git log -1 --pretty=format:%B | grep "^Co-authored-by:" | sed 's/^Co-authored-by: //')

    if [[ -z "$current_coauthors" ]]; then
        echo "No co-authors found on the last commit"
        return 1
    fi

    local selected_coauthor=$(echo "$current_coauthors" | fzf --prompt="Select co-author to remove: ")

    if [[ -n "$selected_coauthor" ]]; then
        local new_message=$(git log -1 --pretty=format:%B | grep -v "^Co-authored-by: $selected_coauthor$")
        git commit --amend -m "$new_message"
        echo "Removed co-author: $selected_coauthor"
    else
        echo "No co-author selected"
    fi
}
