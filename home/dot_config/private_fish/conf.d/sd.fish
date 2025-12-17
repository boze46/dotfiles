# Systemctl shortcuts with full completions
function sd --wraps=systemctl --description systemctl
    systemctl $argv
end
function sds --wraps='systemctl start' --description 'systemctl start'
    systemctl start $argv
end
function sdr --wraps='systemctl restart' --description 'systemctl restart'
    systemctl restart $argv
end
function sde --wraps='systemctl enable' --description 'systemctl enable'
    systemctl enable $argv
end
function sdd --wraps='systemctl disable' --description 'systemctl disable'
    systemctl disable $argv
end
function sdes --wraps='systemctl enable' --description 'systemctl enable --now'
    systemctl enable --now $argv
end
