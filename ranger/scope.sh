#!/usr/bin/env bash

set -o noclobber -o noglob -o nounset -o pipefail
IFS=$'\n'

FILE_PATH="${1}" # Full path of the highlighted file
PV_WIDTH="${2}"  # Width of the preview pane (characters)
PV_HEIGHT="${3}" # Height of the preview pane (characters) (unused)
IMAGE_CACHE_PATH="${4}" # Full path for cached image preview
PV_IMAGE_ENABLED="${5}" # 'True' if image previews are enabled

FILE_EXTENSION="${FILE_PATH##*.}"
FILE_EXTENSION_LOWER="$(printf "%s" "${FILE_EXTENSION}" | tr '[:upper:]' '[:lower:]')"

## Settings
HIGHLIGHT_SIZE_MAX=262143 # 256 KiB
HIGHLIGHT_TABWIDTH=${HIGHLIGHT_TABWIDTH:-8}
HIGHLIGHT_STYLE=${HIGHLIGHT_STYLE:-pablo}
HIGHLIGHT_OPTIONS="--replace-tabs=${HIGHLIGHT_TABWIDTH} --style=${HIGHLIGHT_STYLE} ${HIGHLIGHT_OPTIONS:-}"
PYGMENTIZE_STYLE=${PYGMENTIZE_STYLE:-autumn}

handle_extension() {
    case "${FILE_EXTENSION_LOWER}" in
    ## Archive
    zip | tar | tgz | tbz | tbz2 | gz | 7z | rar)
        atool --list -- "${FILE_PATH}" && exit 5
        unar -l "${FILE_PATH}" && exit 5
        exit 1
        ;;

    ## PDF
    pdf)
        pdftotext -l 10 -nopgbrk -q -- "${FILE_PATH}" - |
            fmt -w "${PV_WIDTH}" && exit 5
        exiftool "${FILE_PATH}" && exit 5
        exit 1
        ;;

    ## HTML
    htm | html | xhtml)
        w3m -dump "${FILE_PATH}" && exit 5
        pandoc -s -t markdown -- "${FILE_PATH}" && exit 5
        exit 1
        ;;

    ## JSON
    json)
        jq --color-output . "${FILE_PATH}" && exit 5
        python3 -m json.tool -- "${FILE_PATH}" && exit 5
        exit 1
        ;;
    esac
}

handle_image() {
    local mimetype="${1}"
    case "${mimetype}" in
    image/*)
        local orientation
        orientation="$(identify -format '%[EXIF:Orientation]\n' -- "${FILE_PATH}" || true)"
        if [[ -n "$orientation" && "$orientation" != 1 ]]; then
            convert -- "${FILE_PATH}" -auto-orient "${IMAGE_CACHE_PATH}" && exit 6
        fi
        exit 7
        ;;

    application/pdf)
        pdftoppm -f 1 -l 1 \
            -scale-to-x 1920 \
            -scale-to-y -1 \
            -singlefile \
            -jpeg \
            -- "${FILE_PATH}" "${IMAGE_CACHE_PATH%.*}" &&
            exit 6 || exit 1
        ;;
    esac
}

handle_mime() {
    local mimetype="${1}"
    case "${mimetype}" in
    ## Text
    text/* | */xml)
        if [[ "$(stat -f%z -- "${FILE_PATH}")" -gt "${HIGHLIGHT_SIZE_MAX}" ]]; then
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
            --out-format="${highlight_format}" --force -- "${FILE_PATH}" && exit 5
        bat --color=always --style="plain" -- "${FILE_PATH}" && exit 5
        pygmentize -f "${pygmentize_format}" -O "style=${PYGMENTIZE_STYLE}" \
            -- "${FILE_PATH}" && exit 5
        exit 2
        ;;

    ## Image
    image/*)
        exiftool "${FILE_PATH}" && exit 5
        exit 1
        ;;

    ## Video / Audio
    video/* | audio/*)
        mediainfo "${FILE_PATH}" && exit 5
        exiftool "${FILE_PATH}" && exit 5
        exit 1
        ;;
    esac
}

handle_fallback() {
    echo '----- File Type Classification -----'
    file --dereference --brief -- "${FILE_PATH}" && exit 5
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
