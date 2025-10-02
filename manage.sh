#!/bin/bash
# 配置管理脚本 - 新电脑安装和日常同步使用同一套逻辑

# --------------------------
# 1. 配置路径（只需修改这里）
# 格式：仓库中的路径:系统中的目标路径
# --------------------------
CONFIG_PATHS=(
    "qutebrowser:~/.config/qutebrowser"
    "wezterm:~/.config/wezterm"
    "ranger:~/.config/ranger"
    "starship/starship.toml:~/.config/starship.toml"
    # 新增配置在这里添加
)

# --------------------------
# 2. 依赖工具（新电脑需要安装的软件）
# --------------------------
REQUIRED_TOOLS=(
    "wezterm"
    "qutebrowser"
    "ranger"
    "starship"
    # 新增依赖在这里添加
)

# --------------------------
# 3. 核心逻辑（无需修改）
# --------------------------

# 获取仓库根目录
DOTFILES_DIR=$(cd "$(dirname "$0")" && pwd)

# 处理路径中的~符号
expand_path() {
    echo "$1" | sed "s|~|$HOME|g"
}

# 同步单个配置（核心逻辑，安装和同步共用）
sync_item() {
    local repo_path=$(echo "$1" | cut -d: -f1)
    local target_path=$(echo "$1" | cut -d: -f2)
    
    local full_repo=$(expand_path "$DOTFILES_DIR/$repo_path")
    local full_target=$(expand_path "$target_path")
    
    # 检查源文件
    if [ ! -e "$full_repo" ]; then
        echo "⚠️  仓库中未找到: $repo_path"
        return
    fi
    
    # 创建目标目录
    mkdir -p "$(dirname "$full_target")"
    
    # 备份已有文件（如果存在）
    if [ -e "$full_target" ] && [ ! -L "$full_target" ]; then
        mv "$full_target" "$full_target.bak"
        echo "🔄 已备份: $target_path"
    fi
    
    # 复制文件/目录
    cp -r "$full_repo" "$full_target"
    echo "✅ 已同步: $repo_path → $target_path"
}

# 检查并安装依赖（仅新电脑初始化时使用）
install_dependencies() {
    echo "===== 检查依赖工具 ====="
    
    # 判断系统类型
    if [ "$(uname)" = "Darwin" ]; then
        # macOS
        PACKAGE_MANAGER="brew install"
    elif [ -x "$(command -v apt)" ]; then
        # Debian/Ubuntu
        PACKAGE_MANAGER="sudo apt install -y"
    elif [ -x "$(command -v pacman)" ]; then
        # Arch Linux
        PACKAGE_MANAGER="sudo pacman -S --noconfirm"
    else
        echo "⚠️  未识别的系统，跳过自动安装依赖"
        return
    fi
    
    # 安装缺失的工具
    for tool in "${REQUIRED_TOOLS[@]}"; do
        if ! command -v "$tool" &> /dev/null; then
            echo "📦 安装 $tool..."
            eval "$PACKAGE_MANAGER $tool"
        else
            echo "✅ $tool 已安装"
        fi
    done
}

# --------------------------
# 4. 执行入口（根据参数选择模式）
# --------------------------
case "$1" in
    # 日常同步：只同步配置文件
    "sync")
        echo "===== 开始日常同步 ====="
        for item in "${CONFIG_PATHS[@]}"; do
            sync_item "$item"
        done
        echo "===== 同步完成 ====="
        ;;
    
    # 新电脑安装：先安装依赖，再同步配置
    "install")
        echo "===== 开始新电脑初始化 ====="
        install_dependencies
        echo
        echo "===== 开始同步配置 ====="
        for item in "${CONFIG_PATHS[@]}"; do
            sync_item "$item"
        done
        echo "===== 初始化完成 ====="
        ;;
    
    *)
        echo "用法:"
        echo "  日常同步配置: $0 sync"
        echo "  新电脑初始化: $0 install"
        exit 1
        ;;
esac
    
