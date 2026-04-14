function git-list-authors
    git log --format='%aN' | sort -u
end
