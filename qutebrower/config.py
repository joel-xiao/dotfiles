import dracula.draw

# Load existing settings made via :set
config.load_autoconfig()

dracula.draw.blood(c, {
    'spacing': {
        'vertical': 6,
        'horizontal': 8
    }
})

## 字体设置（macOS 上推荐使用系统字体）
c.fonts.default_family = ["SF Pro Text", "Helvetica Neue", "Arial"]
c.fonts.default_size = "14pt"

## 启动页
c.url.start_pages = ["https://www.google.com"]

## 默认搜索引擎（快捷输入）
c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "ddg": "https://duckduckgo.com/?q={}",
    "gh": "https://github.com/search?q={}",
    "yt": "https://www.youtube.com/results?search_query={}",
    "w": "https://en.wikipedia.org/wiki/{}"
}

## 隐私相关
c.content.cookies.accept = "no-3rdparty"   # 阻止第三方 cookie
c.content.blocking.enabled = True          # 启用广告屏蔽（内置 adblock）
c.content.geolocation = False              # 默认禁用地理位置
c.content.notifications.enabled = False    # 禁用网页通知

## 下载路径（macOS 默认 Downloads 文件夹）
c.downloads.location.directory = "~/Downloads"

## Mac 风格快捷键（Command 键）
config.bind("Cmd-q", "quit")
config.bind("Cmd-t", "open -t")
config.bind("Cmd-w", "tab-close")
config.bind("Cmd-Shift-]", "tab-next")
config.bind("Cmd-Shift-[", "tab-prev")
config.bind("Cmd-r", "reload")
config.bind("Cmd-Shift-r", "reload -f")
config.bind("Cmd-=", "zoom-in")
config.bind("Cmd--", "zoom-out")
config.bind("Cmd-0", "zoom")

## 启用暗色模式（如果网站支持）
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.images = "smart"

## 代理示例（可选）
# c.content.proxy = "socks://127.0.0.1:7890"  # Clash / Shadowsocks 代理
