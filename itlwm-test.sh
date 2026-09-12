#!/bin/bash
#
# itlwm-test.sh — сборка и диагностика AirportItlwm под Sequoia/Tahoe
#
# Запуск из корня репо itlwm:
#   bash itlwm-test.sh build          — базовая сборка Sonoma14.4 (сток 2.4.0)
#   bash itlwm-test.sh variants       — + варианты Sequoia (__MAC_15_0) и Tahoe (__MAC_26_0)
#   bash itlwm-test.sh all            — build + variants за один проход
#   bash itlwm-test.sh diag [KEXT]    — сбор диагностики (после инъекции kext'а и ребута);
#                                       если передать KEXT-путь — ещё и попытка загрузки.
#                                       Логи пишутся в ./logs/<host>-<os>-<time>, их нужно
#                                       закоммитить и запушить (скрипт печатает команды).
#   bash itlwm-test.sh kextutil /path/AirportItlwm.kext — ручная загрузка с подробным логом
#
# Собранные kext'ы складываются в ./kexts/. Логи диагностики — в ./logs/.
#
# Требования на Mac: полный Xcode (не только Command Line Tools).

set -u

MODE="${1:-build}"
KEXT_PATH="${2:-}"

SCHEME="AirportItlwm (all)"
TARGET="AirportItlwm-Sonoma14.4"
ARCH="x86_64"
DD="build"
OUT_DIR="kexts"
REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"
LOG_HOME="$REPO_ROOT/logs"

echo_banner() {
  echo "============================================================================"
  echo "  $1"
  echo "============================================================================"
}

need_xcode() {
  if ! xcode-select -p >/dev/null 2>&1; then
    echo "Xcode не найден. Установите полный Xcode и выполните:"
    echo "  sudo xcode-select -s /Applications/Xcode.app/Contents/Developer"
    exit 1
  fi
  if [ ! -d MacKernelSDK ]; then
    echo "MacKernelSDK отсутствует — клонирую..."
    git clone --depth=1 https://github.com/acidanthera/MacKernelSDK.git
  fi
  mkdir -p "$OUT_DIR"
}

do_build() {
  local label="$1" define="$2" plist="$3"
  echo_banner "Сборка: $label  (__IO80211_TARGET=$define)"
  xcodebuild -project itlwm.xcodeproj -scheme "$SCHEME" \
    -configuration Debug -derivedDataPath "$DD" \
    -only-target "$TARGET" \
    ARCHS="$ARCH" \
    GCC_PREPROCESSOR_DEFINITIONS="__IO80211_TARGET=$define" \
    INFOPLIST_FILE="$plist" \
    CODE_SIGNING_ALLOWED=NO
  local src="$DD/Build/Products/Debug/$TARGET.kext"
  if [ -d "$src" ]; then
    rm -rf "$OUT_DIR/$label.kext"
    cp -R "$src" "$OUT_DIR/$label.kext"
    echo "-> $OUT_DIR/$label.kext"
  else
    echo "ОШИБКА: kext не собран ($src) — смотрите вывод xcodebuild выше."
  fi
}

build_baseline() {
  do_build "AirportItlwm-Sonoma14.4" "__MAC_14_4" "AirportItlwm/AirportItlwm-Sonoma-Info.plist"
}

build_variants() {
  do_build "AirportItlwm-Sequoia" "__MAC_15_0" "AirportItlwm/AirportItlwm-Sequoia-Info.plist"
  do_build "AirportItlwm-Tahoe" "__MAC_26_0" "AirportItlwm/AirportItlwm-Tahoe-Info.plist"
}

diag() {
  local host osver ts out
  host="$(scutil --get ComputerName 2>/dev/null || hostname)"
  osver="$(sw_vers -productVersion 2>/dev/null)"
  ts="$(date +%Y%m%d-%H%M)"
  out="$LOG_HOME/${host}-${osver}-${ts}"
  mkdir -p "$out"

  echo_banner "Сбор диагностики -> $out"
  sw_vers > "$out/sw_vers.txt" 2>&1
  uname -a > "$out/uname.txt" 2>&1
  nvram boot-args 2>/dev/null > "$out/boot-args.txt"
  xcodebuild -version > "$out/xcode.txt" 2>&1
  csrutil status > "$out/csrutil.txt" 2>&1
  ioreg -lw0 | grep -iE "AppleVTD|IOMapper|VT-d" > "$out/vtd.txt" 2>&1

  for k in IO80211Family IOSkywalkFamily IO80211FamilyLegacy IONetworkingFamily IOPCIFamily; do
    echo "== $k ==" >> "$out/frameworks.txt"
    defaults read "/System/Library/Extensions/$k.kext/Contents/Info.plist" CFBundleVersion 2>&1 >> "$out/frameworks.txt"
    ls -la "/System/Library/Extensions/$k.kext" 2>&1 >> "$out/frameworks.txt"
  done

  sudo kextstat | grep -iE "80211|skywalk|itlw|brcm|airport" > "$out/kextstat.txt"

  # Приватные заголовки и символы сетевого стека — для сверки контракта
  for k in IOSkywalkFamily IO80211Family; do
    K="/System/Library/Extensions/$k.kext"
    [ -d "$K/Contents/Headers" ] && cp -R "$K/Contents/Headers" "$out/headers-$k" 2>/dev/null
    [ -d "$K/Contents/Resources/Headers" ] && cp -R "$K/Contents/Resources/Headers" "$out/resheaders-$k" 2>/dev/null
    for b in "$K/Contents/MacOS/$k" "$K/Contents/PlugIns"/*.kext/Contents/MacOS/*; do
      [ -f "$b" ] && { echo "== $b ==" >> "$out/symbols-$k.txt"; nm -gU "$b" >> "$out/symbols-$k.txt" 2>&1; }
    done
  done
  [ -d "/System/Library/Frameworks/Skywalk.framework" ] && \
    find "/System/Library/Frameworks/Skywalk.framework" -name "*.h" -exec cp {} "$out/fw-Skywalk-" \;

  ifconfig -l > "$out/ifconfig-l.txt"
  ifconfig -a > "$out/ifconfig-a.txt" 2>&1
  ioreg -lw0 | grep -iE "itlw|AirportItlwm|IOPCIDevice.*8086|80211|IOSkywalk" > "$out/ioreg.txt" 2>&1

  sudo log show --last boot --info --debug \
    --predicate 'process == "kernel" OR process == "airportd" OR eventMessage CONTAINS[c] "itlw" OR eventMessage CONTAINS[c] "80211" OR eventMessage CONTAINS[c] "skywalk" OR eventMessage CONTAINS[c] "Airport' \
    > "$out/wifi_log.txt" 2>&1

  ls -lt /Library/Logs/DiagnosticReports/ 2>/dev/null | grep -i kernel > "$out/panics.txt"
  sudo cp /Library/Logs/DiagnosticReports/Kernel*.panic "$out/" 2>/dev/null

  if [ -n "$KEXT_PATH" ]; then
    echo_banner "Попытка ручной загрузки: $KEXT_PATH"
    sudo kextutil -v 6 -verbose-load "$KEXT_PATH"
  fi

  echo_banner "Готово. Содержимое $out:"
  ls -lh "$out" | awk '{print $9, $5}'

  echo_banner "Отправка логов в репо:"
  echo "  cd \"$REPO_ROOT\""
  echo "  git add logs/ && git commit -m \"logs: diag ${host}-${osver}\" && git push origin sequoia-tahoe"
}

kextutil_load() {
  if [ -z "$KEXT_PATH" ]; then
    echo "Укажите путь: bash itlwm-test.sh kextutil /path/AirportItlwm.kext"
    exit 1
  fi
  echo_banner "kextutil: $KEXT_PATH"
  sudo kextutil -v 6 -verbose-load "$KEXT_PATH"
}

case "$MODE" in
  build|variants|all)
    need_xcode
    ;;
  diag)
    ;;
  kextutil)
    kextutil_load
    exit 0
    ;;
  *)
    echo "Неизвестный режим: $MODE"
    echo "Допустимо: build | variants | all | diag [KEXT] | kextutil KEXT"
    exit 1
    ;;
esac

case "$MODE" in
  build)  build_baseline ;;
  variants)
    build_baseline
    build_variants
    ;;
  all)
    build_baseline
    build_variants
    ;;
  diag) diag ;;
esac

echo_banner "Готово. Собранные kext'ы в каталоге ./$OUT_DIR"
echo "Тест в чистой стоковой конфигурации (эталон — BCMC-подход):"
echo "  - инъекция ТОЛЬКО вашего kext'а (после Lilu, если используется);"
echo "  - НЕ подкладывать IOSkywalkFamily/IO80211FamilyLegacy, НЕ блокировать системные kext'ы;"
echo "  - AMFIPass не нужен; csr-active-config можно оставить 00000000 (SIP включён);"
echo "  - для DMA в стоковом стеке желателен VT-d/AppleVTD."
echo "После ребута: bash itlwm-test.sh diag"