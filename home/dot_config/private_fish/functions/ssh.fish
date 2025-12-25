# ssh wrapper to avoid xterm-ghosty/kitty problems
function ssh
    env TERM=xterm-256color ssh $argv
end
