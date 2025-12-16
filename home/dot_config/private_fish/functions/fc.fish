function fc --description '快速创建文件或文件夹 (以 / 结尾创建文件夹)'
    # 解析参数
    argparse 'p/parents' -- $argv
    or return 1

    # 检查参数
    if test (count $argv) -eq 0
        echo "用法: fc [-p] <路径>"
        echo "  -p, --parents  自动创建父目录"
        echo ""
        echo "  以 / 结尾: 创建文件夹"
        echo "  不以 / 结尾: 创建文件"
        return 1
    end

    set -l target $argv[1]

    # 判断是否以 / 结尾
    if string match -qr '/$' -- $target
        # 创建文件夹 (始终递归创建)
        mkdir -p "$target"
        and echo "✓ 已创建文件夹: $target"
    else
        # 创建文件
        set -l parent_dir (dirname "$target")

        # 检查是否需要创建父目录
        if test "$parent_dir" != "."; and not test -d "$parent_dir"
            if set -q _flag_parents
                # 有 -p 参数，自动创建父目录
                mkdir -p "$parent_dir"
                or return 1
            else
                # 没有 -p 参数，报错
                echo "错误: 父目录不存在: $parent_dir"
                echo "提示: 使用 -p 参数自动创建父目录"
                return 1
            end
        end

        touch "$target"
        and echo "✓ 已创建文件: $target"
    end
end
