fish_vi_key_bindings

# Emulates vim's cursor shape behavior
# Set the normal and visual mode cursors to a block
set fish_cursor_default underscore
# Set the insert mode cursor to a line
set fish_cursor_insert line
# Set the replace mode cursors to an underscore
set fish_cursor_replace_one block
set fish_cursor_replace block
# Set the external cursor to a line. The external cursor appears when a command is started.
# The cursor shape takes the value of fish_cursor_default when fish_cursor_external is not specified.
set fish_cursor_external line
# The following variable can be used to configure cursor shape in
# visual mode, but due to fish_cursor_default, is redundant here
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
