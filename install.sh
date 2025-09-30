# -----------------------------
# NVIM
# -----------------------------
# lang vue
npm install -g @volar/vue-language-server
# lang TS
npm install -g typescript typescript-language-server
# blink.cmp
cargo build --release --manifest-path ~/.local/share/nvim/lazy/blink.cmp/Cargo.toml
# Python Provider
python3 -m venv ~/.venvs/myenv
source ~/.venvs/myenv/bin/activate
pip install pynvim

# -----------------------------
# Ranger
# -----------------------------
chmod +x ~/.config/ranger/scope.sh
# 显示 图片相关等
#  源码编译 w3m
brew install autoconf automake pkg-config imlib2 bdw-gc
git clone https://github.com/tats/w3m.git
cd w3m
./configure --with-imagelib=imlib2
make
sudo make install
sudo cp ./w3mimgdisplay /usr/local/bin/
which w3mimgdisplay

# 1. 压缩包预览工具
brew install atool libarchive unrar p7zip
# 2. 文档预览工具（PDF/Office/HTML 等）
brew install poppler mupdf odt2txt pandoc w3m lynx \
  catdoc djvulibre
# 3. 媒体与图片工具（图片处理、元数据查看）
brew install imagemagick exiftool mediainfo fonttools
# 4. 代码与文本处理工具（语法高亮、JSON 格式化）
brew install highlight bat pygments jq python3
# 5. 特殊格式支持（Torrent、ePub 缩略图）
brew install transmission-cli marianosimone/epub-thumbnailer/epub-thumbnailer

# 如果 brew xlsx2csv 可以安装成功的使用 brew 而非 pipx
brew install xlsx2csv
brew install pipx
pipx ensurepath
pipx install xlsx2csv
# -----------------------------
# Lunar macOS 系统的屏幕亮度 / 色温调节工具，支持根据环境光自动适配屏幕，也可手动精细化调整，适合需要优化屏幕显示效果的用户（如夜间护眼、匹配外接显示器等）。
# -----------------------------
brew install --cask lunar
