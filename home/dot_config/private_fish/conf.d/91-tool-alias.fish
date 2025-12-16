alias fclist 'fc-list --format="%{family[0]}\t%{style[0]}\t%{file}\t%{fullname}\n"'

function fclist-beauty
    fclist | rg $argv[1] | sort | bat --language tsv
end
