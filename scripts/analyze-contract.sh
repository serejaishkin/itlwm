#!/bin/bash
set -euo pipefail

# analyze-contract.sh — сравнение vtable-фингерпринтов IO80211SkywalkInterface.
#
# usage: analyze-contract.sh <file...>
#
# <file> — лог (wifi_log / log show), содержащий строки фингерпринта драйвера:
#     CONTRACT idx=<N> addr=0x... kind=O|.
#   (снимается boot-argv "-itlwmcontract" при старте AirportItlwmSkywalkInterface).
#
# Печатает для каждого файла отсортированную подпись индексов "наших" оверрайдов
# (kind=O). Если файлов >= 2 — дополнительно diff индексов между первыми двумя:
# сдвиг/добавление индексов между Sequoia и Tahoe указывает, где верхний контракт
# IO80211SkywalkInterface изменился относительно компилируемых заголовков
# (include/Airport).

usage() {
    echo "usage: $0 <file...>" >&2
    exit 2
}

[ $# -ge 1 ] || usage

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

signature() {
    local src="$1" out="$2" n
    grep -oE "CONTRACT idx=[0-9]+ addr=0x[0-9a-fA-F]+ kind=O" "$src" 2>/dev/null \
        | sed -E 's/CONTRACT idx=([0-9]+) .*/\1/' | sort -n -u > "$out"
    n="$(wc -l < "$out" | tr -d ' ')"
    printf '%-24s (ours=%s):' "$(basename "$src")" "$n"
    if [ "$n" = 0 ]; then
        echo " <нет строк CONTRACT kind=O — фингерпринт не снят?>"
    else
        tr '\n' ' ' < "$out"
        echo
    fi
}

i=0
for f in "$@"; do
    signature "$f" "$tmpdir/sig.$i"
    i=$((i + 1))
done

if [ $# -ge 2 ]; then
    echo "--- diff (первый vs второй файл) ---"
    echo "только в первом:";  comm -23 "$tmpdir/sig.0" "$tmpdir/sig.1"
    echo "только во втором:"; comm -13 "$tmpdir/sig.0" "$tmpdir/sig.1"
fi