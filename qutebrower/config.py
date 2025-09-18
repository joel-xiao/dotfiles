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
c.url.default_page = "https://duckduckgo.com"
c.url.start_pages = ["https://duckduckgo.com"]
c.url.searchengines = {
    "DEFAULT": "https://www.google.com/search?q={}",
    "ddg": "https://duckduckgo.com/?q={}",
    "gh": "https://github.com/search?q={}",
    "bd": "https://www.baidu.com/s?wd={}",
    "yt": "https://www.youtube.com/results?search_query={}",
    "rd": "https://www.reddit.com/search/?q={}"  # 修复：补充搜索参数{}
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
c.zoom.default = "125%"  # 全局默认缩放，不支持URL模式
c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.policy.images = "smart"  # macOS 暗色模式优化
c.colors.webpage.preferred_color_scheme = "dark"
c.input.partial_timeout = 300
c.input.insert_mode.auto_load = True
c.input.insert_mode.auto_leave = True
c.input.spatial_navigation = False

# ----------------------------
# 隐私与安全增强
# ----------------------------
# Cookie 控制
c.content.cookies.accept = "no-3rdparty"

# JavaScript 管理
c.content.javascript.enabled = True  # 全局启用
# 站点例外设置
config.set("content.javascript.enabled", False, "https://example.com/*")
config.set("content.javascript.enabled", True, "https://*.google.com/*")

# 媒体与安全（修复了无效配置项）
c.content.autoplay = False
c.content.xss_auditing = True  # 替换无效的content.ssl_strict
c.content.javascript.can_close_tabs = False  # 替换无效的force_https
c.content.geolocation = False              # macOS 隐私默认设置
c.content.notifications.enabled = False    # 禁用网页通知

# ----------------------------
# 下载管理 (macOS 适配)
# ----------------------------
c.downloads.location.directory = "~/Downloads"  # macOS 默认下载路径
c.downloads.open_dispatcher = "open {}"  # macOS 打开文件的命令
# 移除无效的show_progress_in_statusbar配置

# ----------------------------
# 字体设置 (macOS 系统字体)
# ----------------------------
c.fonts.default_family = ["SF Pro Text", "Helvetica Neue", "Arial", "sans-serif"]
c.fonts.default_size = "14pt"
c.fonts.tabs.selected = "14pt SF Pro Text, Helvetica Neue, Arial"
c.fonts.tabs.unselected = "13pt SF Pro Text, Helvetica Neue, Arial"
c.fonts.hints = "bold 11pt SF Pro Text, Helvetica Neue, Arial"

# ----------------------------
# 前缀
# ----------------------------
LEADER = ","  # 主前缀，高响应
SECOND = ";"  # 次前缀，快速操作

# ----------------------------
# 搜索引擎快捷键
# ----------------------------
config.bind(LEADER + "sg", "set-cmd-text :open https://www.google.com/search?q=")
config.bind(LEADER + "sd", "set-cmd-text :open https://duckduckgo.com/?q=")
config.bind(LEADER + "sb", "set-cmd-text :open https://www.baidu.com/s?wd=")
config.bind(LEADER + "sy", "set-cmd-text :open https://www.youtube.com/results?search_query=")
config.bind(LEADER + "sr", "set-cmd-text :open https://www.reddit.com/search/?q=")
config.bind(LEADER + "sh", "set-cmd-text :open https://github.com/search?q=")

# ----------------------------
# 标签页 / Buffer 管理
# ----------------------------
config.bind(LEADER + "n", "open -t")            # 新标签
config.bind(LEADER + "x", "tab-close")          # 关闭标签
config.bind(LEADER + "b", "set-cmd-text :buffer")  # buffer 列表
config.bind(LEADER + "bn", "tab-next")          # 下一个标签
config.bind(LEADER + "bp", "tab-prev")          # 上一个标签
config.bind(LEADER + "wo", "tab-only")          # 只保留当前标签
config.bind(LEADER + "N", "tab-move +1")        # 标签向右移动
config.bind(LEADER + "P", "tab-move -1")        # 标签向左移动

# ----------------------------
# 网页操作 / Vim 风格
# ----------------------------
config.bind("/", "set-cmd-text /")             # 搜索
config.bind("n", "search-next")                # 下一个搜索结果
config.bind("N", "search-prev")                # 上一个搜索结果
config.bind("H", "back")                       # 后退
config.bind("L", "forward")                    # 前进
config.bind("zz", "scroll-to-perc 50")         # 居中
config.bind("J", "scroll-page 0 0.5")          # 下滚半页
config.bind("K", "scroll-page 0 -0.5")         # 上滚半页
config.bind("gg", "scroll-to-perc 0")          # 到顶部
config.bind("G", "scroll-to-perc 100")         # 到底部
config.bind("i", "enter-mode insert")          # 进入输入模式
config.bind("Esc", "leave-mode")               # 离开输入模式
config.bind("u", "undo")                       # 回退操作

# ----------------------------
# Hint / 跳转 / LazyVim 风格
# ----------------------------
config.bind("f", "hint links")                 # 跳转链接
config.bind("F", "hint links tab")             # 新标签打开
config.bind("yf", "hint links yank")           # 复制链接
config.bind("yi", "hint images yank")          # 复制图片 URL
config.bind("gd", "set-cmd-text /")            # 搜索当前页 (模拟 gd)
config.bind("gD", "set-cmd-text :open -t ")    # 新标签搜索 (模拟 gD)
config.bind("gf", "hint all tab")              # 跳转任意元素并新标签
config.bind("v", "mode-enter visual")          # 选文本复制
config.bind("y", "yank selection")             # yank 选中文本

# ----------------------------
# DevTools / 前端开发
# ----------------------------
config.bind(LEADER + "d", "devtools")          # 打开 DevTools
config.bind(LEADER + "dc", "devtools console") # Console 面板
config.bind(LEADER + "de", "devtools elements")# DOM 面板
config.bind(LEADER + "ds", "devtools sources") # Sources 面板（断点 / log）
config.bind(LEADER + "dn", "devtools network") # Network 面板

# ----------------------------
# 其他工具 & 刷新
# ----------------------------
config.bind(LEADER + "r", "reload")            # 刷新
config.bind(LEADER + "R", "reload -f")         # 强制刷新
config.bind(LEADER + "s", "config-source")     # 重新加载配置
config.bind(LEADER + "q", "quit")              # 退出浏览器
config.bind(LEADER + "g", "open -t https://github.com") # 打开 GitHub
config.bind(LEADER + "y", "yank")              # 复制当前 URL
config.bind(LEADER + "p", "open -t {clipboard}")  # 粘贴打开

# ----------------------------
# 代理控制
# ----------------------------
config.bind(LEADER + "pa", "set content.proxy http://127.0.0.1:7890")  # 开启 HTTP 代理
config.bind(LEADER + "pn", "set content.proxy ''")                     # 关闭代理
config.bind(LEADER + "ps", "set content.proxy socks5://127.0.0.1:7891") # 开启 SOCKS5 代理

# ----------------------------
# 页面缩放控制
# ----------------------------
config.bind(LEADER + "+", "zoom-in")
config.bind(LEADER + "-", "zoom-out")
config.bind(LEADER + "0", "zoom-reset")

# ----------------------------
# 书签与历史管理
# ----------------------------
config.bind(LEADER + "ma", "bookmark-add")     # 添加书签
config.bind(LEADER + "ml", "set-cmd-text :bookmark-list")  # 查看书签
config.bind(LEADER + "hh", "set-cmd-text :history")  # 历史记录

# ----------------------------
# 分屏操作（修复快捷键冲突）
# ----------------------------
config.bind(LEADER + "vv", "vsplit")  # 垂直分屏（修改为双v避免冲突）
config.bind(LEADER + "ss", "hsplit")  # 水平分屏（修改为双s避免冲突）
config.bind(LEADER + "w", "window-close")  # 关闭当前分屏

# ----------------------------
# 下载管理快捷键
# ----------------------------
config.bind(LEADER + "dl", "downloads-folder")  # 打开下载目录

# ----------------------------
# 次前缀 ; → 快速操作
# ----------------------------
config.bind(SECOND + "r", "reload")
config.bind(SECOND + "R", "reload -f")
config.bind(SECOND + "d", "devtools")
config.bind(SECOND + "q", "quit")
config.bind(SECOND + "o", "set-cmd-text :open ")
config.bind(SECOND + "O", "set-cmd-text :open -t ")
config.bind(SECOND + "y", "yank")             # 次前缀复制 URL

# ----------------------------
# 站点特定配置（使用支持的配置项）
# ----------------------------
# 对 GitHub 禁用深色模式
config.set("colors.webpage.darkmode.enabled", False, "https://github.com/*")

# ----------------------------
# macOS 风格快捷键 (Command 键)
# ----------------------------
# 窗口控制
config.bind("Cmd-q", "quit")                  # 退出浏览器
config.bind("Cmd-w", "tab-close")             # 关闭当前标签页
config.bind("Cmd-n", "open -w")               # 新建窗口
config.bind("Cmd-t", "open -t")               # 新建标签页

# 标签页导航
config.bind("Cmd-Shift-]", "tab-next")        # 下一个标签页
config.bind("Cmd-Shift-[", "tab-prev")        # 上一个标签页
config.bind("Cmd-1", "tab-focus 1")           # 切换到第1个标签
config.bind("Cmd-2", "tab-focus 2")           # 切换到第2个标签
config.bind("Cmd-3", "tab-focus 3")           # 切换到第3个标签
config.bind("Cmd-4", "tab-focus 4")           # 切换到第4个标签
config.bind("Cmd-5", "tab-focus 5")           # 切换到第5个标签

# 刷新与缩放
config.bind("Cmd-r", "reload")                # 刷新页面
config.bind("Cmd-Shift-r", "reload -f")       # 强制刷新
config.bind("Cmd-=", "zoom-in")               # 放大
config.bind("Cmd--", "zoom-out")              # 缩小
config.bind("Cmd-0", "zoom-reset")            # 重置缩放

# 编辑操作
config.bind("Cmd-f", "set-cmd-text /")        # 页面搜索
config.bind("Cmd-a", "tab-focus")             # 全选标签
config.bind("Cmd-c", "yank selection")        # 复制选中内容
config.bind("Cmd-v", "insert-text {clipboard}") # 粘贴

# 地址栏操作
config.bind("Cmd-l", "set-cmd-text :open")    # 聚焦地址栏
