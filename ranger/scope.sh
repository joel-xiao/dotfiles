#!/usr/bin/env bash
set -o noclobber -o noglob -o nounset -o pipefail
IFS=$'\n'

FILE_PATH="${1}"        # 当前选中文件
PV_WIDTH="${2}"         # 预览宽度
PV_HEIGHT="${3}"        # 预览高度
IMAGE_CACHE_PATH="${4}" # 图片缓存路径
PV_IMAGE_ENABLED="${5}" # True / False

FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER=$(echo "$FILE_EXTENSION" | tr '[:upper:]' '[:lower:]')

# -----------------------------
# 文本文件高亮预览
# -----------------------------
if [[ -f "$FILE_PATH" ]]; then
    if [[ "$FILE_EXTENSION_LOWER" =~ ^(py|c|cpp|sh|js|rb|pl|java|rs|lua|txt|md|json|csv|xml|tex)$ ]]; then
        if command -v bat >/dev/null 2>&1; then
            bat --style=plain --color=always --paging=never "$FILE_PATH" && exit 0
        elif command -v pygmentize >/dev/null 2>&1; then
            pygmentize -f terminal256 -O style=monokai "$FILE_PATH" && exit 0
        else
            cat "$FILE_PATH" && exit 0
        fi
    fi
fi

# -----------------------------
# PDF 文件文本预览
# -----------------------------
if [[ "$FILE_EXTENSION_LOWER" == "pdf" ]]; then
    if command -v pdftotext >/dev/null 2>&1; then
        pdftotext -l 10 -nopgbrk -q "$FILE_PATH" - | head -n "$PV_HEIGHT" && exit 0
    elif command -v mutool >/dev/null 2>&1; then
        mutool draw -F txt -i "$FILE_PATH" 1-10 | head -n "$PV_HEIGHT" && exit 0
    fi
fi

# -----------------------------
# Excel / CSV / Markdown
# -----------------------------
if [[ "$FILE_EXTENSION_LOWER" =~ ^(xls|xlsx)$ ]] && command -v xlsx2csv >/dev/null 2>&1; then
    xlsx2csv "$FILE_PATH" | head -n "$PV_HEIGHT" && exit 0
fi
if [[ "$FILE_EXTENSION_LOWER" =~ ^(csv|md)$ ]]; then
    head -n "$PV_HEIGHT" "$FILE_PATH" && exit 0
fi

# -----------------------------
# 图片预览
# -----------------------------
if [[ "$PV_IMAGE_ENABLED" == "True" ]]; then
    case "$FILE_EXTENSION_LOWER" in
        jpg|jpeg|png|gif|bmp|tiff|webp)
            [[ -n "$IMAGE_CACHE_PATH" ]] && cp "$FILE_PATH" "$IMAGE_CACHE_PATH" && exit 6
            ;;
    esac
fi

# -----------------------------
# 其他文件
# -----------------------------
file --dereference --brief "$FILE_PATH" && exit 0

exit 1
