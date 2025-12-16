function cpux
    if command -v cpu-x &>/dev/null
        cpu-x -N
    else
        echo "cpu-x 未安装"
        echo "安装命令: sudo pacman -S cpu-x"
        read -P "是否现在安装? [Y/n] " -n 1 answer
        if test -z "$answer"; or string match -qi y $answer
            sudo pacman -S cpu-x && cpu-x
        end
    end
end
