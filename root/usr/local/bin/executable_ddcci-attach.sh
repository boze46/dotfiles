#!/bin/bash

# 等待显示器和 DRM 完全初始化
sleep 5

echo "=== DDC/CI 设备附加脚本 ==="
echo "开始扫描已连接的显示器..."

# 遍历所有 DP/HDMI 连接器
for status_file in /sys/class/drm/card*/card*-{DP,HDMI}-*/status; do
  [ -f "$status_file" ] || continue

  status=$(cat "$status_file" 2>/dev/null)

  # 只处理已连接的显示器
  if [ "$status" = "connected" ]; then
    connector_path=$(dirname "$status_file")
    connector_name=$(basename "$connector_path")

    # 查找对应的 I2C 总线
    i2c_dir=$(find "$connector_path" -maxdepth 1 -name "i2c-*" -type d 2>/dev/null | head -1)

    if [ -n "$i2c_dir" ]; then
      i2c_bus=$(basename "$i2c_dir")
      i2c_num="${i2c_bus#i2c-}"

      echo ""
      echo "发现: $connector_name -> $i2c_bus"

      # 检查 ddcci 设备是否已存在
      if [ -e "/sys/bus/ddcci/devices/ddcci$i2c_num" ]; then
        echo "  ✓ ddcci$i2c_num 已存在"
        continue
      fi

      # 尝试附加 ddcci 设备
      if echo "ddcci 0x37" >"/sys/bus/i2c/devices/$i2c_bus/new_device" 2>/dev/null; then
        echo "  ✓ 成功创建 ddcci$i2c_num"
        sleep 1
      else
        echo "  ✗ 创建失败（显示器可能不支持 DDC/CI）"
      fi
    else
      echo ""
      echo "警告: $connector_name 未找到 I2C 总线"
    fi
  fi
done

# 等待 backlight 设备初始化
sleep 2

# 显示最终结果
echo ""
echo "=== 检测结果 ==="
ddcci_count=$(ls /sys/bus/ddcci/devices/ddcci[0-9]* 2>/dev/null | wc -l)
backlight_count=$(ls /sys/class/backlight/ddcci* 2>/dev/null | wc -l)

echo "ddcci 设备: $ddcci_count 个"
echo "backlight 设备: $backlight_count 个"

if [ $backlight_count -gt 0 ]; then
  echo ""
  echo "可用设备:"
  ls -1 /sys/class/backlight/ddcci* 2>/dev/null | xargs -I {} basename {}
fi
