fish_vi_key_bindings

set fish_cursor_default underscore
set fish_cursor_insert line
set fish_cursor_replace_one block
set fish_cursor_replace block
set fish_cursor_external line
set fish_cursor_visual block

if command -q starship
    starship init fish | source
end

# zoxide
if command -q zoxide
    zoxide init fish | source
    alias cd="z"
end

# 只启动 ssh-agent，不自动加载密钥
if command -q keychain
    # 不带密钥参数，只初始化 agent
    eval (keychain --eval --quiet --noask)
end

# mise
if command -q mise
    mise activate fish | source
end

# fzf
# if command -q fzf
#     fzf --fish
# end
