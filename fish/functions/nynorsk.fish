function nynorsk --description "Bokmål to Nynorsk dictionary lookup"
    if test (count $argv) -eq 0
        echo "Usage: nynorsk <word>"
        echo ""
        echo "Example:"
        echo "  nynorsk ankomst"
        return 1
    end

    deno run --allow-read /Users/peder/Projects/Hobby/nynorsk/nynorsk.ts $argv
end
