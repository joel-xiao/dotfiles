import doom_one

config.load_autoconfig()

# ----------------------------
# 主题 (Doom-One 风格优化)
# ----------------------------
doom_one.setup(c, {
    "spacing": {"vertical": 6, "horizontal": 8},
    "padding": {"top": 6, "right": 8, "bottom": 6, "left": 8},
})

# ----------------------------
# 基础设置
# ----------------------------
c.url.default_page = "https://baidu.com"
c.url.start_pages = ["https://baidu.com"]
c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "ddg": "https://duckduckgo.com/?q={}",
    "gh": "https://github.com/search?q={}",
    "bd": "https://www.baidu.com/s?wd={}",
    "yt": "https://www.youtube.com/results?search_query={}",
    "rd": "https://www.reddit.com/search/?q={}",
}
c.content.blocking.enabled = True
c.content.blocking.method = "both"
c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://secure.fanboy.co.nz/fanboy-annoyance.txt",
    "https://easylist.to/easylist/fanboy-social.txt",
]
c.scrolling.smooth = True
c.tabs.show = "multiple"
c.tabs.background = True
c.statusbar.show = "in-mode"
c.tabs.favicons.scale = 1.2
c.zoom.default = "125%"
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.images = "smart"
c.colors.webpage.preferred_color_scheme = "dark"
c.input.partial_timeout = 300
c.input.insert_mode.auto_load = True
c.input.insert_mode.auto_leave = True
c.input.spatial_navigation = False

# ----------------------------
# 隐私与安全
# ----------------------------
c.content.cookies.accept = "no-3rdparty"
c.content.javascript.enabled = True
config.set("content.javascript.enabled", False, "https://example.com/*")
config.set("content.javascript.enabled", True, "https://*.google.com/*")
c.content.autoplay = False
c.content.xss_auditing = True
c.content.geolocation = False
c.content.notifications.enabled = False

# ----------------------------
# 下载管理 (macOS)
# ----------------------------
c.downloads.location.directory = "~/Downloads"  # 保留原始~路径写法
c.downloads.open_dispatcher = "open {}"

# ----------------------------
# 字体设置
# ----------------------------
c.fonts.default_family = ["SF Pro Text", "Helvetica Neue", "Arial", "sans-serif"]
c.fonts.default_size = "14pt"
c.fonts.tabs.selected = "14pt SF Pro Text, Helvetica Neue, Arial"
c.fonts.tabs.unselected = "13pt SF Pro Text, Helvetica Neue, Arial"
c.fonts.hints = "bold 11pt SF Pro Text, Helvetica Neue, Arial"

# ----------------------------
# Leader 键 (LazyVim 空格)
# ----------------------------
LEADER = "<Space>"  # 保留原始空格前缀定义，不添加解绑

# ----------------------------
# 搜索引擎
# ----------------------------
config.bind(LEADER + "sg", "set-cmd-text :open https://www.google.com/search?q=")
config.bind(LEADER + "sd", "set-cmd-text :open https://duckduckgo.com/?q=")
config.bind(LEADER + "sb", "set-cmd-text :open https://www.baidu.com/s?wd=")
config.bind(LEADER + "sy", "set-cmd-text :open https://www.youtube.com/results?search_query=")
config.bind(LEADER + "sr", "set-cmd-text :open https://www.reddit.com/search/?q=")
config.bind(LEADER + "sh", "set-cmd-text :open https://github.com/search?q=")

# ----------------------------
# 标签页管理 / Buffer
# ----------------------------
config.bind(LEADER + "bn", "tab-next")
config.bind(LEADER + "bp", "tab-prev")
config.bind(LEADER + "b", "set-cmd-text :buffer")
config.bind(LEADER + "n", "open -t")
config.bind(LEADER + "x", "tab-close")
config.bind(LEADER + "wo", "tab-only")
config.bind(LEADER + "N", "tab-move +1")
config.bind(LEADER + "P", "tab-move -1")

# ----------------------------
# Vim 核心操作
# ----------------------------
config.bind("/", "set-cmd-text /")
config.bind("n", "search-next")
config.bind("N", "search-prev")
config.bind("gg", "scroll-to-perc 0")
config.bind("G", "scroll-to-perc 100")
config.bind("<Alt-j>", "scroll-page 0 0.5")  # 保留原始Alt键写法
config.bind("<Alt-k>", "scroll-page 0 -0.5")
config.bind("zz", "scroll-to-perc 50")
# config.bind("i", "enter-mode insert")
config.bind("i", "hint inputs")
config.bind("Esc", "leave-mode")
config.bind("u", "undo")

# ----------------------------
# Hint / Visual / Yank
# ----------------------------
config.bind("f", "hint links")
config.bind("F", "hint links tab")
config.bind("yf", "hint links yank")
config.bind("yi", "hint images yank")
config.bind("gd", "hint links")
config.bind("gD", "hint links tab")
config.bind("gf", "hint all tab")
config.bind("v", "mode-enter caret")  # 仅修复模式名称（visual→caret，避免报错）
config.bind("y", "yank selection", mode="caret")  # 仅修复模式名称

# ----------------------------
# DevTools
# ----------------------------
config.bind(LEADER + "d", "devtools")
config.bind(LEADER + "dc", "devtools console")
config.bind(LEADER + "de", "devtools elements")
config.bind(LEADER + "ds", "devtools sources")
config.bind(LEADER + "dn", "devtools network")

# ----------------------------
# 刷新 / 配置 / 退出
# ----------------------------
config.bind(LEADER + "r", "reload")
config.bind(LEADER + "R", "reload -f")
config.bind(LEADER + "s", "config-source")
config.bind(LEADER + "q", "quit")
config.bind(LEADER + "g", "open -t https://github.com")
config.bind(LEADER + "y", "yank")
config.bind(LEADER + "p", "open -t {clipboard}")

# ----------------------------
# 代理
# ----------------------------
config.bind(LEADER + "pa", "set content.proxy http://127.0.0.1:7890")
config.bind(LEADER + "pn", "set content.proxy ''")
config.bind(LEADER + "ps", "set content.proxy socks5://127.0.0.1:7891")

# ----------------------------
# 缩放
# ----------------------------
config.bind(LEADER + "+", "zoom-in")
config.bind(LEADER + "-", "zoom-out")
config.bind(LEADER + "0", "zoom-reset")

# ----------------------------
# 书签 / 历史
# ----------------------------
config.bind(LEADER + "ma", "bookmark-add")
config.bind(LEADER + "ml", "set-cmd-text :bookmark-list")
config.bind(LEADER + "hh", "set-cmd-text :history")

# ----------------------------
# 分屏 / 下载
# ----------------------------
config.bind(LEADER + "vv", "open -w")  # 保留原始分屏绑定逻辑
config.bind(LEADER + "ss", "tab-clone")
config.bind(LEADER + "w", "window-close")
config.bind(LEADER + "dl", "spawn open ~/Downloads")  # 保留原始~路径

# ----------------------------
# 站点特定
# ----------------------------
config.set("colors.webpage.darkmode.enabled", False, "https://github.com/*")

# ----------------------------
# macOS Cmd 键
# ----------------------------
config.bind("Cmd-q", "quit")
config.bind("Cmd-w", "tab-close")
config.bind("Cmd-n", "open -w")
config.bind("Cmd-t", "open -t")
config.bind("Cmd-Shift-]", "tab-next")
config.bind("Cmd-Shift-[", "tab-prev")
config.bind("Cmd-r", "reload")
config.bind("Cmd-Shift-r", "reload -f")
config.bind("Cmd-=", "zoom-in")
config.bind("Cmd--", "zoom-out")
config.bind("Cmd-0", "zoom-reset")
config.bind("Cmd-f", "set-cmd-text /")
config.bind("Cmd-c", "yank selection")
config.bind("Cmd-v", "insert-text {clipboard}")
config.bind("Cmd-l", "set-cmd-text :open")
