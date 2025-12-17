# lnav shortcuts for systemd journal viewing
function jl --wraps=lnav --description 'View all systemd journals with lnav'
    lnav
end
function jlu --description 'View specific systemd unit logs with lnav'
    if test (count $argv) -eq 0
        echo "Usage: jlu <unit-name>"
        echo "Example: jlu nginx"
        return 1
    end
    journalctl -u $argv[1] -o json | lnav
end
function jlf --description 'Follow systemd journal with lnav'
    journalctl -f -o json | lnav
end
function jlb --description 'View systemd journal since last boot with lnav'
    journalctl -b -o json | lnav
end
function jle --description 'View systemd errors with lnav'
    journalctl -p err -o json | lnav
end
function jlt --description 'View systemd journal for last N minutes'
    if test (count $argv) -eq 0
        set -l minutes 30
    else
        set -l minutes $argv[1]
    end
    journalctl --since "$minutes minutes ago" -o json | lnav
end
