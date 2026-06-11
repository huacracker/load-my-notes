#!/usr/bin/env bash
# load-my-notes 一键安装到 hermes 默认 skills 目录
#
# 用法:
#   git clone https://github.com/<your-username>/load-my-notes
#   cd load-my-notes
#   bash install.sh
#
# 或者从本地:
#   bash install.sh /path/to/load-my-notes

set -e

SRC="${1:-$(dirname "$(readlink -f "$0")")}"
DEST="${HOME}/.hermes/skills/load-my-notes"

if [ ! -f "$SRC/SKILL.md" ]; then
  echo "ERROR: SKILL.md not found in $SRC" >&2
  echo "用法: bash install.sh [path-to-load-my-notes]" >&2
  exit 1
fi

mkdir -p "$DEST"
cp "$SRC/SKILL.md" "$DEST/SKILL.md"
chmod 700 "$DEST"
chmod 600 "$DEST/SKILL.md"

echo ""
echo "✓ Installed to: $DEST"
echo ""
echo "Next steps:"
echo "  1. mkdir -p ~/notes"
echo "  2. nano ~/notes/your-first-note.md"
echo "  3. In hermes REPL, type: 查看笔记帮助"
echo ""
