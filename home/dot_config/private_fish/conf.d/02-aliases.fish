# 系统命令增强
alias ls='eza --icons' # 或 'ls --color=auto'
alias ll='eza -lh --icons'
alias la='eza -lah --icons'
alias tree='eza --tree --icons'

alias c='clear'

alias moi='chezmoi'
alias moie='chezmoi edit'
alias moia='chezmoi apply -v'
alias moim='chezmoi merge'
alias moima='chezmoi merge-all'

alias moiw='chezmoi edit --watch'

alias moic='chezmoi cd'

alias rmoi='rootmoi'

# Aria2 管理
alias aria2-start='systemctl --user start aria2.service'
alias aria2-stop='systemctl --user stop aria2.service'
alias aria2-restart='systemctl --user restart aria2.service'
alias aria2-status='systemctl --user status aria2.service'
alias aria2-log='tail -f ~/.config/aria2/aria2.log'

# trash
alias rm='trash'

alias ff='fastfetch'
