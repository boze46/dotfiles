# Dotfiles 项目说明

这是一个使用 chezmoi 管理的个人配置文件仓库，包含各种 Linux 工具和应用的配置。

## 项目结构

```
.
├── dot_config/              # 应用配置目录 (~/.config/)
│   ├── fish/               # Fish shell 配置
│   ├── niri/               # Niri 窗口管理器配置
│   ├── kitty/              # Kitty 终端配置
│   ├── nvim/               # Neovim 配置
│   ├── starship.toml       # Starship 提示符配置
│   └── ...
├── dot_gitconfig.tmpl      # Git 配置模板
└── private_dot_ssh/        # SSH 配置
```

## Git Commit 规范

### 格式要求

**必须严格遵循以下格式：**

```
<类型>(<作用域>): <简洁描述>

[可选的详细说明]
```

**重要**：不要添加任何自动生成的签名或标记（如 "Generated with Claude Code"、"Co-Authored-By" 等）。

### Commit 类型（type）

| 类型 | 说明 | 使用场景 |
|------|------|----------|
| `feat` | 新功能 | 添加新配置、新功能、新工具配置 |
| `fix` | 修复问题 | 修复配置错误、bug 修复 |
| `refactor` | 重构 | 重构配置结构、优化配置但不改变功能 |
| `docs` | 文档 | 仅文档更改（README、注释等） |
| `style` | 格式 | 代码格式化、空格调整（不影响功能） |
| `chore` | 杂项 | 构建工具、依赖更新等 |

### 作用域（scope）

根据修改的配置文件所属工具/应用确定作用域：

#### 常用作用域

| 作用域 | 说明 | 文件位置 |
|--------|------|----------|
| `fish` | Fish shell 配置 | `dot_config/private_fish/` |
| `niri` | Niri 窗口管理器 | `dot_config/niri/` |
| `kitty` | Kitty 终端 | `dot_config/kitty/` |
| `nvim` | Neovim 编辑器 | `dot_config/nvim/` |
| `starship` | Starship 提示符 | `dot_config/starship.toml` |
| `git` | Git 配置 | `dot_gitconfig.tmpl` |
| `ssh` | SSH 配置 | `private_dot_ssh/` |
| `alacritty` | Alacritty 终端 | `dot_config/alacritty/` |
| `lazygit` | Lazygit TUI | `dot_config/lazygit/` |
| `aria2` | Aria2 下载器 | `dot_config/aria2/` |
| `paru` | Paru AUR 助手 | `dot_config/paru/` |
| `handlr` | Handlr 文件关联 | `dot_config/handlr/` |
| `systemd` | Systemd 用户服务 | `dot_config/systemd/` |
| `volta` | Volta Node 版本管理 | `dot_config/volta/` |
| `fontconfig` | 字体配置 | `dot_config/fontconfig/` |
| `dirate` | Dirate 目录模板 | `dot_config/dirate/` |

#### 通用作用域

- `env`: 环境变量、全局配置
- `chezmoi`: chezmoi 本身的配置

### 描述规范

#### ✅ 好的描述示例

```
feat(fish): 添加 yazi 目录跟随函数
feat(niri): 重构快捷键布局为 WASD 方案
fix(kitty): 修复鼠标滚动自动选中文本问题
feat(git): 模板化 gitconfig 按主机切换凭证
refactor(niri): 调整启动器快捷键为 Alt+Space
```

#### ❌ 不好的描述示例

```
update config          # 缺少类型和作用域
feat: add something    # 缺少作用域
fix(niri): fix bug     # 描述不清晰
feat(fish): 增加了一些新的别名和功能  # 过于笼统
```

#### 描述要求

1. **使用中文**：描述部分使用简体中文
2. **简洁明确**：一句话说清楚做了什么
3. **动词开头**：添加、修复、调整、重构等
4. **具体化**：说明具体改了什么，而不是泛泛而谈

### Commit 工作流

当需要提交 commit 时，AI 助手应遵循以下流程：

1. **检查修改**
   ```bash
   git status
   git diff --staged
   ```

2. **查看历史**（参考格式）
   ```bash
   git log --oneline -10
   ```

3. **分析修改内容**
   - 确定修改了哪些配置文件
   - 判断 commit 类型（feat/fix/refactor）
   - 确定作用域（根据修改的工具/应用）
   - 总结核心改动

4. **编写 commit message**
   - 遵循上述格式规范
   - 如果改动复杂，添加详细说明（列表形式）

5. **提交 commit**
   ```bash
   git add <files>
   git commit -m "$(cat <<'EOF'
   类型(作用域): 简洁描述

   [详细说明（可选）]
   EOF
   )"
   ```

### 多文件修改指南

当一次修改涉及多个作用域时：

#### 选项 1：使用主要作用域

```
feat(niri): 重构快捷键并更新相关配置
```

#### 选项 2：分别提交（推荐）

```
feat(niri): 重构快捷键布局为 WASD 方案
feat(fish): 添加 niri 快捷键提示函数
```

#### 选项 3：使用通用作用域

```
feat(env): 统一更新窗口管理器相关配置
```

## 特殊文件说明

### 模板文件（.tmpl）

- 文件名以 `.tmpl` 结尾的是 chezmoi 模板文件
- 支持根据主机名、操作系统等条件生成不同配置
- 修改这些文件时，说明是"模板化"改动

示例：
```
feat(git): 模板化 gitconfig 按主机切换凭证
feat(niri): 模板化配置并按主机设置显示器
```

### 私密文件（private_）

- 以 `private_` 开头的文件/目录会被 chezmoi 设置为私密权限
- 通常用于 SSH 密钥、凭证等敏感配置

## 提交检查清单

在提交前确认：

- [ ] commit message 格式正确（类型+作用域+描述）
- [ ] 作用域与修改的文件匹配
- [ ] 描述清晰、具体、使用中文
- [ ] 如有多个改动，考虑是否需要拆分提交
- [ ] 不提交敏感信息（密钥、密码等）
- [ ] 不提交临时文件（logs/、*.log 等）

## 常见场景示例

### 添加新工具配置

```
feat(工具名): 添加基础配置
feat(yazi): 添加文件管理器配置与主题
```

### 调整快捷键

```
fix(niri): 调整关闭与概览快捷键
refactor(kitty): 修改快捷键布局
```

### 修复配置问题

```
fix(kitty): 修复鼠标滚动自动选中文本问题
fix(ssh): 修正配置文件权限
```

### 添加新功能

```
feat(fish): 添加 yazi 目录跟随函数
feat(starship): 添加 git 状态显示
```

### 优化配置

```
refactor(niri): 简化工作区配置
refactor(fish): 重组环境变量加载逻辑
```

## 注意事项

1. **不要批量修改后一次性提交**：应该按功能/模块分别提交
2. **提交信息要诚实**：如果是大重构，不要说成"小调整"
3. **保持提交原子性**：一个 commit 只做一件事
4. **避免"WIP"提交**：完成一个完整功能再提交
5. **使用中文描述**：与现有提交历史保持一致
