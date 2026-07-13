#!/bin/bash
set -euo pipefail

MPPL_MERMAID_CONF_DIR="/etc/mppl/mermaid"
WORKDIR="${MPPL_WORKDIR:-/mppl}"

if [ ! -d "${WORKDIR}" ]; then
  WORKDIR="$(pwd)"
fi

cd "${WORKDIR}"

# 将内置 Mermaid 配置写入工作目录，供 mermaid-filter / mmdc 读取
cp -f "${MPPL_MERMAID_CONF_DIR}/.mermaid-config.json" .
cp -f "${MPPL_MERMAID_CONF_DIR}/.mermaid.css" .
cp -f "${MPPL_MERMAID_CONF_DIR}/.puppeteer.json" .

# 渲染缓存目录（可通过环境变量覆盖）
export MERMAID_FILTER_LOC="${MERMAID_FILTER_LOC:-.mppl-mermaid-cache}"
export MERMAID_FILTER_FORMAT="${MERMAID_FILTER_FORMAT:-png}"
export MERMAID_FILTER_BACKGROUND="${MERMAID_FILTER_BACKGROUND:-white}"
export MERMAID_FILTER_WIDTH="${MERMAID_FILTER_WIDTH:-1400}"
export MERMAID_FILTER_SCALE="${MERMAID_FILTER_SCALE:-2}"

mkdir -p "${MERMAID_FILTER_LOC}"

exec pandoc \
  -f markdown-auto_identifiers \
  --listings \
  --pdf-engine=xelatex \
  --template=/templates/mppl.tex \
  --lua-filter=/etc/mppl/mermaid/mppl-meta.lua \
  --filter mermaid-filter \
  "$@"
