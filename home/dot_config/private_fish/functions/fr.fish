function fr --description '快速查看文件或文件夹内容'
    # 无参数时，列出当前目录
    if test (count $argv) -eq 0
        eza -l
        return
    end

    set -l target $argv[1]

    # 判断是否以 / 结尾（文件夹）
    if string match -qr '/$' -- $target
        # 查看文件夹内容
        eza -l "$target"
    else
        # 检查目标是否存在
        if not test -e "$target"
            echo "错误: 文件或目录不存在: $target"
            return 1
        end

        # 判断是文件还是目录
        if test -d "$target"
            # 是目录但没有以 / 结尾，也使用 eza 查看
            eza -l "$target"
        else
            # 是文件，使用 bat 查看
            # 检查 bat 是否可用
            if command -q bat
                bat --style=auto --paging=auto "$target"
            else if command -q batcat
                batcat --style=auto --paging=auto "$target"
            else
                echo "提示: 未安装 bat，使用 cat 作为替代"
                cat "$target"
            end
        end
    end
end
