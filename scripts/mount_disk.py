#!/usr/bin/env python3
"""
硬盘挂载配置脚本 - 用于 Arch Linux + KDE
自动检测硬盘信息并配置 /etc/fstab 自动挂载
"""

import os
import sys
import subprocess
import re
from pathlib import Path

class DiskMounter:
    def __init__(self):
        self.device = None
        self.uuid = None
        self.fs_type = None
        self.mount_point = None
        self.user_uid = None
        self.user_gid = None
        
    def check_root(self):
        """检查是否有 root 权限"""
        if os.geteuid() != 0:
            print("❌ 此脚本需要 root 权限运行")
            print(f"请使用: sudo {sys.argv[0]}")
            sys.exit(1)
    
    def get_user_info(self):
        """获取实际用户的 UID 和 GID"""
        sudo_user = os.environ.get('SUDO_USER')
        if sudo_user:
            import pwd
            user_info = pwd.getpwnam(sudo_user)
            self.user_uid = user_info.pw_uid
            self.user_gid = user_info.pw_gid
        else:
            self.user_uid = 1000
            self.user_gid = 1000
    
    def list_disks(self):
        """列出所有可用的磁盘分区"""
        print("\n📋 检测到的磁盘分区：\n")
        try:
            result = subprocess.run(['lsblk', '-o', 'NAME,SIZE,TYPE,MOUNTPOINT,FSTYPE'], 
                                  capture_output=True, text=True, check=True)
            print(result.stdout)
        except subprocess.CalledProcessError as e:
            print(f"❌ 获取磁盘列表失败: {e}")
            sys.exit(1)
    
    def get_disk_info(self, device):
        """获取指定设备的详细信息"""
        try:
            result = subprocess.run(['blkid', device], 
                                  capture_output=True, text=True, check=True)
            output = result.stdout
            
            # 提取 UUID
            uuid_match = re.search(r'UUID="([^"]+)"', output)
            if uuid_match:
                self.uuid = uuid_match.group(1)
            
            # 提取文件系统类型
            type_match = re.search(r'TYPE="([^"]+)"', output)
            if type_match:
                self.fs_type = type_match.group(1)
            
            if not self.uuid or not self.fs_type:
                print(f"❌ 无法获取 {device} 的完整信息")
                return False
            
            return True
        except subprocess.CalledProcessError:
            print(f"❌ 设备 {device} 不存在或无法访问")
            return False
    
    def check_dependencies(self):
        """检查并安装必要的依赖"""
        deps = {
            'ntfs': 'ntfs-3g',
            'exfat': 'exfatprogs',
            'vfat': 'dosfstools'
        }
        
        if self.fs_type in deps:
            package = deps[self.fs_type]
            try:
                subprocess.run(['pacman', '-Q', package], 
                             capture_output=True, check=True)
                print(f"✓ {package} 已安装")
            except subprocess.CalledProcessError:
                print(f"⚠️  未检测到 {package}，正在安装...")
                try:
                    subprocess.run(['pacman', '-S', '--noconfirm', package], check=True)
                    print(f"✓ {package} 安装成功")
                except subprocess.CalledProcessError:
                    print(f"❌ {package} 安装失败")
                    return False
        return True
    
    def generate_fstab_entry(self):
        """生成 fstab 条目"""
        options = []
        
        if self.fs_type in ['ntfs', 'ntfs-3g']:
            fs_type = 'ntfs-3g'
            options = [
                'defaults',
                f'uid={self.user_uid}',
                f'gid={self.user_gid}',
                'umask=022',
                'windows_names'
            ]
            dump = '0'
            fsck = '0'
        elif self.fs_type == 'exfat':
            options = [
                'defaults',
                f'uid={self.user_uid}',
                f'gid={self.user_gid}',
                'umask=022'
            ]
            dump = '0'
            fsck = '0'
        elif self.fs_type in ['ext4', 'ext3', 'ext2']:
            fs_type = self.fs_type
            options = ['defaults']
            dump = '0'
            fsck = '2'
        elif self.fs_type == 'vfat':
            options = [
                'defaults',
                f'uid={self.user_uid}',
                f'gid={self.user_gid}',
                'umask=022'
            ]
            dump = '0'
            fsck = '0'
        else:
            fs_type = self.fs_type
            options = ['defaults']
            dump = '0'
            fsck = '0'
        
        if self.fs_type not in ['ntfs', 'ntfs-3g']:
            fs_type = self.fs_type
        
        entry = f"UUID={self.uuid}  {self.mount_point}  {fs_type}  {','.join(options)}  {dump}  {fsck}"
        return entry
    
    def backup_fstab(self):
        """备份 fstab 文件"""
        backup_path = '/etc/fstab.backup'
        try:
            subprocess.run(['cp', '/etc/fstab', backup_path], check=True)
            print(f"✓ 已备份 /etc/fstab 到 {backup_path}")
            return True
        except subprocess.CalledProcessError:
            print("❌ 备份 fstab 失败")
            return False
    
    def add_to_fstab(self, entry):
        """将条目添加到 fstab"""
        try:
            with open('/etc/fstab', 'r') as f:
                content = f.read()
            
            # 检查是否已存在该 UUID 的条目
            if self.uuid in content:
                print(f"⚠️  fstab 中已存在 UUID {self.uuid} 的条目")
                response = input("是否覆盖? (y/N): ").strip().lower()
                if response != 'y':
                    print("❌ 操作已取消")
                    return False
                
                # 删除旧条目
                lines = content.split('\n')
                new_lines = [line for line in lines if self.uuid not in line]
                content = '\n'.join(new_lines)
            
            # 添加新条目
            with open('/etc/fstab', 'w') as f:
                f.write(content)
                if not content.endswith('\n'):
                    f.write('\n')
                f.write(f"\n# {self.device} - 由挂载脚本添加于 {subprocess.getoutput('date')}\n")
                f.write(entry + '\n')
            
            print("✓ 已添加到 /etc/fstab")
            return True
        except Exception as e:
            print(f"❌ 写入 fstab 失败: {e}")
            return False
    
    def create_mount_point(self):
        """创建挂载点"""
        try:
            Path(self.mount_point).mkdir(parents=True, exist_ok=True)
            print(f"✓ 挂载点 {self.mount_point} 已创建")
            return True
        except Exception as e:
            print(f"❌ 创建挂载点失败: {e}")
            return False
    
    def test_mount(self):
        """测试挂载"""
        print("\n🔄 测试挂载...")
        try:
            subprocess.run(['mount', '-a'], check=True, capture_output=True)
            print("✓ 挂载测试成功")
            
            # 检查是否真的挂载了
            result = subprocess.run(['mountpoint', '-q', self.mount_point])
            if result.returncode == 0:
                print(f"✓ {self.mount_point} 已成功挂载")
                
                # 显示挂载信息
                df_result = subprocess.run(['df', '-h', self.mount_point], 
                                         capture_output=True, text=True)
                print(f"\n{df_result.stdout}")
                return True
            else:
                print(f"⚠️  {self.mount_point} 未挂载")
                return False
        except subprocess.CalledProcessError as e:
            print(f"❌ 挂载测试失败: {e.stderr.decode() if e.stderr else str(e)}")
            return False
    
    def run(self):
        """主运行流程"""
        print("=" * 60)
        print("  硬盘挂载配置脚本 - Arch Linux + KDE")
        print("=" * 60)
        
        # 检查权限
        self.check_root()
        
        # 获取用户信息
        self.get_user_info()
        
        # 列出磁盘
        self.list_disks()
        
        # 输入设备路径
        self.device = input("\n请输入要挂载的设备 (例如 /dev/sda1): ").strip()
        if not self.device.startswith('/dev/'):
            self.device = '/dev/' + self.device
        
        # 获取磁盘信息
        print(f"\n🔍 正在检测 {self.device}...")
        if not self.get_disk_info(self.device):
            sys.exit(1)
        
        print(f"\n📊 磁盘信息:")
        print(f"  设备: {self.device}")
        print(f"  UUID: {self.uuid}")
        print(f"  文件系统: {self.fs_type}")
        print(f"  用户 UID/GID: {self.user_uid}/{self.user_gid}")
        
        # 检查依赖
        print("\n🔧 检查依赖...")
        if not self.check_dependencies():
            sys.exit(1)
        
        # 输入挂载点
        default_mount = f"/mnt/{self.device.split('/')[-1]}"
        mount_input = input(f"\n请输入挂载点 (默认: {default_mount}): ").strip()
        self.mount_point = mount_input if mount_input else default_mount
        
        # 生成 fstab 条目
        fstab_entry = self.generate_fstab_entry()
        
        print(f"\n📝 将添加以下条目到 /etc/fstab:")
        print(f"  {fstab_entry}")
        
        confirm = input("\n确认继续? (y/N): ").strip().lower()
        if confirm != 'y':
            print("❌ 操作已取消")
            sys.exit(0)
        
        # 备份 fstab
        if not self.backup_fstab():
            sys.exit(1)
        
        # 创建挂载点
        if not self.create_mount_point():
            sys.exit(1)
        
        # 添加到 fstab
        if not self.add_to_fstab(fstab_entry):
            sys.exit(1)
        
        # 测试挂载
        if self.test_mount():
            print("\n✅ 配置完成！硬盘将在下次启动时自动挂载。")
            print(f"   挂载点: {self.mount_point}")
        else:
            print("\n⚠️  配置已添加但挂载测试失败，请检查配置。")
            print("   你可以手动运行 'sudo mount -a' 测试")

if __name__ == '__main__':
    try:
        mounter = DiskMounter()
        mounter.run()
    except KeyboardInterrupt:
        print("\n\n❌ 操作已取消")
        sys.exit(1)
    except Exception as e:
        print(f"\n❌ 发生错误: {e}")
        sys.exit(1)
