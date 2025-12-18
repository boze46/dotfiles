# conf - 配置文件管理工具
# 作者: 幽浮喵 ฅ'ω'ฅ

function conf
    # 配置映射文件路径
    set -l config_file ~/.config/fish/conf_mappings.txt

    # 确保配置文件存在
    if not test -f $config_file
        touch $config_file
    end

    # 无参数时列出所有配置
    if test (count $argv) -eq 0
        _conf_list $config_file
        return
    end

    # 解析子命令
    switch $argv[1]
        case add
            _conf_add $config_file $argv[2..-1]

        case rm remove delete
            _conf_rm $config_file $argv[2..-1]

        case list ls
            _conf_list $config_file

        case help -h --help
            _conf_help

        case '*'
            # 编辑指定配置
            _conf_edit $config_file $argv[1]
    end
end

# 列出所有配置
function _conf_list
    set -l config_file $argv[1]

    if test -s $config_file
        echo "📝 可用的配置喵～"
        while read -l line
            # 跳过空行和注释
            if test -z "$line"; or string match -q '#*' $line
                continue
            end

            set -l parts (string split -m 1 ' ' $line)
            if test (count $parts) -eq 2
                set_color green
                echo -n "  $parts[1]"
                set_color normal
                echo " -> $parts[2]"
            end
        end < $config_file
    else
        echo "😿 还没有添加任何配置喵～"
        echo "使用 'conf add <路径>' 来添加第一个配置吧！"
    end
end

# 添加新配置
function _conf_add
    set -l config_file $argv[1]

    if test (count $argv) -lt 2
        set_color red
        echo "❌ 用法: conf add <路径>"
        set_color normal
        echo "示例: conf add ~/.config/nvim/"
        return 1
    end

    # 展开路径
    set -l target_path (eval echo $argv[2])

    # 检查路径是否存在
    if not test -e "$target_path"
        set_color red
        echo "❌ 路径不存在: $target_path"
        set_color normal
        return 1
    end

    # 转换为绝对路径
    set target_path (realpath "$target_path")

    # 检查是否已经在映射中
    set -l existing_name (grep " $target_path\$" $config_file | cut -d' ' -f1)
    if test -n "$existing_name"
        set_color yellow
        echo "⚠️  这个路径已经添加过了喵！名称是: $existing_name"
        set_color normal

        read -P "是否使用 chezmoi re-add 刷新？[y/N] " -l confirm
        if test "$confirm" = "y" -o "$confirm" = "Y"
            if chezmoi re-add "$target_path"
                set_color green
                echo "✓ 已刷新 $existing_name ($target_path)"
                set_color normal
            else
                set_color red
                echo "❌ 刷新失败，可能不在 chezmoi 管理中"
                set_color normal
                return 1
            end
        end
        return 0
    end

    # 询问配置名称
    read -P "📝 请输入配置名称: " -l config_name

    # 验证名称
    if test -z "$config_name"
        set_color red
        echo "❌ 名称不能为空喵！"
        set_color normal
        return 1
    end

    # 检查名称是否已存在
    if grep -q "^$config_name " $config_file
        set_color red
        echo "❌ 配置名称 '$config_name' 已存在"
        set_color normal
        return 1
    end

    # 添加到 chezmoi
    echo "🔄 正在添加到 chezmoi..."
    if chezmoi add "$target_path"
        # 保存映射
        echo "$config_name $target_path" >> $config_file
        set_color green
        echo "✓ 成功添加配置 '$config_name' -> $target_path"
        set_color normal
        echo "💡 使用 'conf $config_name' 来编辑这个配置喵～"
    else
        set_color red
        echo "❌ 添加到 chezmoi 失败"
        set_color normal
        return 1
    end
end

# 删除配置
function _conf_rm
    set -l config_file $argv[1]

    if test (count $argv) -lt 2
        set_color red
        echo "❌ 用法: conf rm <名称>"
        set_color normal
        return 1
    end

    set -l config_name $argv[2]

    # 查找配置路径
    set -l config_line (grep "^$config_name " $config_file)
    if test -z "$config_line"
        set_color red
        echo "❌ 配置 '$config_name' 不存在喵"
        set_color normal
        echo "使用 'conf list' 查看所有配置"
        return 1
    end

    set -l target_path (string split -m 1 ' ' $config_line)[2]

    # 显示信息
    set_color yellow
    echo "⚠️  准备删除配置: $config_name"
    echo "   路径: $target_path"
    set_color normal

    # 确认删除映射
    read -P "从配置列表中删除？[y/N] " -l confirm
    if test "$confirm" != "y" -a "$confirm" != "Y"
        echo "已取消 (,,•﹏•,,)"
        return 0
    end

    # 从配置文件中删除
    set -l temp_file (mktemp)
    grep -v "^$config_name " $config_file > $temp_file
    mv $temp_file $config_file

    # 询问是否从 chezmoi 中移除
    read -P "是否也从 chezmoi 中移除？[y/N] " -l confirm_chezmoi
    if test "$confirm_chezmoi" = "y" -o "$confirm_chezmoi" = "Y"
        if chezmoi forget "$target_path"
            set_color green
            echo "✓ 已从 chezmoi 中移除"
            set_color normal
        else
            set_color yellow
            echo "⚠️  从 chezmoi 移除失败（可能已经不存在）"
            set_color normal
        end
    end

    set_color green
    echo "✓ 已删除配置 '$config_name' (*^▽^*)"
    set_color normal
end

# 编辑配置
function _conf_edit
    set -l config_file $argv[1]
    set -l config_name $argv[2]

    # 查找配置路径
    set -l config_line (grep "^$config_name " $config_file)
    if test -z "$config_line"
        set_color red
        echo "❌ 配置 '$config_name' 不存在喵"
        set_color normal
        echo "💡 使用 'conf add <路径>' 来添加新配置"
        echo "   或使用 'conf list' 查看所有可用配置"
        return 1
    end

    set -l target_path (string split -m 1 ' ' $config_line)[2]

    # 检查路径是否还存在
    if not test -e "$target_path"
        set_color yellow
        echo "⚠️  警告: 目标路径不存在: $target_path"
        set_color normal
        return 1
    end

    # 使用 chezmoi edit --watch
    echo "📝 正在打开 $config_name ($target_path)..."
    chezmoi edit --watch "$target_path"
end

# 显示帮助信息
function _conf_help
    echo "conf - 配置文件管理工具 ฅ'ω'ฅ"
    echo ""
    echo "用法:"
    echo "  conf                列出所有配置"
    echo "  conf <名称>         使用 chezmoi edit --watch 编辑配置"
    echo "  conf add <路径>     添加新配置到 chezmoi"
    echo "  conf rm <名称>      删除配置"
    echo "  conf list           列出所有配置"
    echo "  conf help           显示此帮助信息"
    echo ""
    echo "示例:"
    echo "  conf add ~/.config/nvim/"
    echo "  conf nvim"
    echo "  conf rm nvim"
end
