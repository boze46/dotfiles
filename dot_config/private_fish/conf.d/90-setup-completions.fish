# 在 ~/.config/fish/config.fish 中添加

# 智能补全管理函数
set -l completions_dir ~/.config/fish/conf.d

# 检查 fzf
if command -q fzf; and not test -f $completions_dir/fzf.fish
    fzf --fish >$completions_dir/fzf.fish 2>/dev/null
else if not command -q fzf; and test -f $completions_dir/fzf.fish
    rm $completions_dir/fzf.fish
end

# 检查 mise
if command -q mise; and not test -f $completions_dir/mise.fish
    mise completion fish >$completions_dir/mise.fish 2>/dev/null
else if not command -q mise; and test -f $completions_dir/mise.fish
    rm $completions_dir/mise.fish
end
