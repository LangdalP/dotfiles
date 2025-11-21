function ls --description 'List directory contents with color and grouped directories'
    gls --color -h --group-directories-first $argv
end
