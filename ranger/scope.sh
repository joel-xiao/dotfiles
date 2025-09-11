#!/usr/bin/env bash

set -o noclobber -o noglob -o nounset -o pipefail
IFS=$'\n'

## 脚本参数
FILE_PATH="${1}"          # 高亮文件的完整路径
PV_WIDTH="${2}"           # 预览面板宽度（字符数）
PV_HEIGHT="${3}"          # 预览面板高度（字符数）
IMAGE_CACHE_PATH="${4}"   # 图片预览缓存路径
PV_IMAGE_ENABLED="${5}"   # 是否启用图片预览（True/False）

FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER="$(printf "%s" "${FILE_EXTENSION}" | tr '[:upper:]' '[:lower:]')"

## 系统检测与配置
if [[ "$(uname -s)" == "Darwin" ]]; then
    # macOS 系统配置
    STAT_SIZE_CMD="stat -f '%z'"  # macOS 兼容的文件大小获取命令
else
    # Linux 系统配置
    STAT_SIZE_CMD="stat --printf='%s'"  # Linux 兼容的文件大小获取命令
fi

## 通用设置
HIGHLIGHT_SIZE_MAX=262143 # 256KiB
HIGHLIGHT_TABWIDTH=${HIGHLIGHT_TABWIDTH:-8}
HIGHLIGHT_STYLE=${HIGHLIGHT_STYLE:-pablo}
HIGHLIGHT_OPTIONS="--replace-tabs=${HIGHLIGHT_TABWIDTH} --style=${HIGHLIGHT_STYLE} ${HIGHLIGHT_OPTIONS:-}"
PYGMENTIZE_STYLE=${PYGMENTIZE_STYLE:-autumn}
OPENSCAD_IMGSIZE=${RNGR_OPENSCAD_IMGSIZE:-1000,1000}
OPENSCAD_COLORSCHEME=${RNGR_OPENSCAD_COLORSCHEME:-Tomorrow Night}

handle_extension() {
    case "${FILE_EXTENSION_LOWER}" in
    ## 压缩包
    a | ace | alz | arc | arj | bz | bz2 | cab | cpio | deb | gz | jar | lha | lz | lzh | lzma | lzo | \
        rpm | rz | t7z | tar | tbz | tbz2 | tgz | tlz | txz | tZ | tzo | war | xpi | xz | Z | zip)
        atool --list -- "${FILE_PATH}" && exit 5
        bsdtar --list --file "${FILE_PATH}" && exit 5
        exit 1
        ;;
    rar)
        unrar lt -p- -- "${FILE_PATH}" && exit 5
        exit 1
        ;;
    7z)
        7z l -p -- "${FILE_PATH}" && exit 5
        exit 1
        ;;

    ## PDF
    pdf)
        pdftotext -l 10 -nopgbrk -q -- "${FILE_PATH}" - |
            fmt -w "${PV_WIDTH}" && exit 5
        mutool draw -F txt -i -- "${FILE_PATH}" 1-10 |
            fmt -w "${PV_WIDTH}" && exit 5
        exiftool "${FILE_PATH}" && exit 5
        exit 1
        ;;

    ## BitTorrent
    torrent)
        transmission-show -- "${FILE_PATH}" && exit 5
        exit 1
        ;;

    ## OpenDocument
    odt | ods | odp | sxw)
        odt2txt "${FILE_PATH}" && exit 5
        pandoc -s -t markdown -- "${FILE_PATH}" && exit 5
        exit 1
        ;;

    ## XLSX
    xlsx)
        xlsx2csv -- "${FILE_PATH}" && exit 5
        exit 1
        ;;

    ## HTML
    htm | html | xhtml)
        w3m -dump "${FILE_PATH}" && exit 5
        lynx -dump -- "${FILE_PATH}" && exit 5
        # macOS 可能没有 elinks，跳过不影响核心功能
        command -v elinks &>/dev/null && elinks -dump "${FILE_PATH}" && exit 5
        pandoc -s -t markdown -- "${FILE_PATH}" && exit 5
        ;;

    ## JSON
    json)
        jq --color-output . "${FILE_PATH}" && exit 5
        python -m json.tool -- "${FILE_PATH}" && exit 5
        ;;

    ## 音频格式
    dff | dsf | wv | wvc)
        mediainfo "${FILE_PATH}" && exit 5
        exiftool "${FILE_PATH}" && exit 5
        ;;
    esac
}

handle_image() {
    local DEFAULT_SIZE="1920x1080"
    local mimetype="${1}"
    
    case "${mimetype}" in
    ## 图片
    image/*)
        local orientation
        orientation="$(identify -format '%[EXIF:Orientation]\n' -- "${FILE_PATH}")"
        if [[ -n "$orientation" && "$orientation" != 1 ]]; then
            convert -- "${FILE_PATH}" -auto-orient "${IMAGE_CACHE_PATH}" && exit 6
        fi
        exit 7
        ;;

    ## PDF 图片预览
    application/pdf)
        pdftoppm -f 1 -l 1 \
            -scale-to-x "${DEFAULT_SIZE%x*}" \
            -scale-to-y -1 \
            -singlefile \
            -jpeg -tiffcompression jpeg \
            -- "${FILE_PATH}" "${IMAGE_CACHE_PATH%.*}" &&
            exit 6 || exit 1
        ;;

    ## 字体预览
    application/font* | application/*opentype)
        preview_png="/tmp/$(basename "${IMAGE_CACHE_PATH%.*}").png"
        if fontimage -o "${preview_png}" \
            --pixelsize "120" \
            --fontname \
            --pixelsize "80" \
            --text "  ABCDEFGHIJKLMNOPQRSTUVWXYZ  " \
            --text "  abcdefghijklmnopqrstuvwxyz  " \
            --text "  0123456789.:,;(*!?') ff fl fi ffi ffl  " \
            --text "  The quick brown fox jumps over the lazy dog.  " \
            "${FILE_PATH}"; then
            convert -- "${preview_png}" "${IMAGE_CACHE_PATH}" &&
                rm "${preview_png}" &&
                exit 6
        else
            exit 1
        fi
        ;;
    esac
}

handle_mime() {
    local mimetype="${1}"
    case "${mimetype}" in
    ## RTF 和 DOC
    text/rtf | *msword)
        catdoc -- "${FILE_PATH}" && exit 5
        exit 1
        ;;

    ## DOCX, ePub, FB2
    *wordprocessingml.document | */epub+zip | */x-fictionbook+xml)
        pandoc -s -t markdown -- "${FILE_PATH}" && exit 5
        exit 1
        ;;

    ## XLS
    *ms-excel)
        xls2csv -- "${FILE_PATH}" && exit 5
        exit 1
        ;;

    ## 文本文件
    text/* | */xml)
        # 使用跨平台的文件大小检测命令
        if [[ "$($STAT_SIZE_CMD -- "${FILE_PATH}")" -gt "${HIGHLIGHT_SIZE_MAX}" ]]; then
            exit 2
        fi
        if [[ "$(tput colors)" -ge 256 ]]; then
            local pygmentize_format='terminal256'
            local highlight_format='xterm256'
        else
            local pygmentize_format='terminal'
            local highlight_format='ansi'
        fi
        env HIGHLIGHT_OPTIONS="${HIGHLIGHT_OPTIONS}" highlight \
            --out-format="${highlight_format}" \
            --force -- "${FILE_PATH}" && exit 5
        env COLORTERM=8bit bat --color=always --style="plain" \
            -- "${FILE_PATH}" && exit 5
        pygmentize -f "${pygmentize_format}" -O "style=${PYGMENTIZE_STYLE}" \
            -- "${FILE_PATH}" && exit 5
        exit 2
        ;;

    ## DjVu
    image/vnd.djvu)
        djvutxt "${FILE_PATH}" | fmt -w "${PV_WIDTH}" && exit 5
        exiftool "${FILE_PATH}" && exit 5
        exit 1
        ;;

    ## 图片元数据
    image/*)
        exiftool "${FILE_PATH}" && exit 5
        exit 1
        ;;

    ## 音视频
    video/* | audio/*)
        mediainfo "${FILE_PATH}" && exit 5
        exiftool "${FILE_PATH}" && exit 5
        exit 1
        ;;
    esac
}

handle_fallback() {
    echo '----- File Type Classification -----' && file --dereference --brief -- "${FILE_PATH}" && exit 5
    exit 1
}

MIMETYPE="$(file --dereference --brief --mime-type -- "${FILE_PATH}")"
if [[ "${PV_IMAGE_ENABLED}" == 'True' ]]; then
    handle_image "${MIMETYPE}"
fi
handle_extension
handle_mime "${MIMETYPE}"
handle_fallback

exit 1
