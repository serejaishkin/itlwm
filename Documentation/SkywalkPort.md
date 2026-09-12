# Skywalk Port: AirportItlwm для Sequoia/Tahoe (research)

Цель: перевести AirportItlwm на штатный Skywalk-стек (IO80211FamilyV2/IOSkywalkFamily)
так, чтобы он работал на стоковых macOS Sequoia (15.x) и Tahoe (26.x) **без**:
- отключения SIP/AMFI,
- инъекций legacy-стека (IO80211FamilyLegacy, IOSkywalkFamily-даунгрейд),
- блокирования системных kext'ов (OC Block) и root-патчей.

## Устройство стека (по публичной документации и RE)

- macOS Sonoma+: Wi-Fi в ядре обслуживается `IO80211Family.kext` + плагинами,
  а сетевой уровень — `IOSkywalkFamily.kext` (core) + userland `Skywalk.framework`.
  Интерфейсная часть — `IO80211SkywalkInterface : IOSkywalkEthernetInterface :
  IOSkywalkNetworkInterface : IOSkywalkInterface` (заголовки в `include/Airport`, срез Sonoma).
- На Sequoia/Tahoe Apple перевела сетевые драйверы на Skywalk; 80211-часть живёт
  внутри `IO80211Family.kext` (в target `__IO80211_TARGET=__MAC_14_4` и выше —
  новый контракт, в `__MAC_15_0`/`__MAC_26_0` ветки ещё не заполнены кодами).
- DMA: нативный стек использует IOMapper/AppleVTD. Intel-платы требуют VT-d/AppleVTD
  либо собственный bounce (см. BCMC `bcmc-disable-io-mapper`).
- AWDL теперь offload-ится в прошивку нативных FullMAC-чипов; Intel-прошивки
  хендшейки WPA выполняют сами (ittlwm это уже использует).

## Reference: AppleBCMWLANCompanion (BCMC), 0xFireWolf

- Публичный репозиторий содержит только README/документацию/прошивки; код закрыт.
- Подтверждает: на **Intel** OC-инъекция стороннего kext'а работает с SIP полностью
  включённым (`csr-active-config=00000000`) и **без AMFIPass**, если не трогать стек.
  Требование BCMC к чистоте: убрать AMFIPass, IOSkywalkFamily-даунгрейд,
  IO80211FamilyLegacy + плагины, убрать OC Block.
- BCMC работает по схеме «камуфляж чипа под нативный BCM (fake chip 4364, модуль lanai)».
  Для Intel (SoftMAC, в стеке Apple нет Intel-MAC) модель невоспроизводима напрямую:
  нужен собственный верхний 80211-слой поверх стокового Skywalk — наш V2-путь.
- Важные boot-args/свойства (для будущего сравнения контрактов):
  `wlan.pcie.detectsabotage=0`, свойства `bcmc-*`, `bcmc-disable-io-mapper=0x01`.

## Статус публичных заголовков (проверено 2026-09)

- `include/Airport/*` — срез Sonoma-эры (автор zxystd); `__MAC_10_13…__MAC_14_4`.
- Репо zxystd: приватных срезов Sequoia/Tahoe нет. crangel660/macOS-80211-WiFi-research —
  только README. Code-search по `IO80211SkywalkInterface.h @ __MAC_26_0` = 0 совпадений.
- Вывод: **эталон контракта Sequoia/Tahoe берём с машин** через `itlwm-test.sh diag`
  (headers-*/symbols-* из IO80211Family.kext и IOSkywalkFamily.kext).

## План (milestone) и зависимость от логов

| # | Шаг | Нужны ли логи |
|---|-----|---------------|
| M1 | Базовый билд стокового Sonoma-kext на Sequoia (Xcode 16) | нет |
| M2 | Прогон на стенде: инъекция ТОЛЬКО нашего kext, сток, SIP вкл. | да (`kextstat`, `wifi_log.txt`, panic) |
| M3 | Снять headers/symbols IO80211Family + IOSkywalkFamily (Sequoia и Tahoe) | да (diag) |
| M4 | Сверка с `include/Airport`, обновление заголовков и vtable-гейтов | по логам M3 |
| M5 | Правки `AirportItlwmV2`/`AirportItlwmSkywalkInterface` под актуальный контракт | после M4 |
| M6 | Версии `OSBundleLibraries` в Info.plist (Sequoia/Tahoe) | да (`frameworks.txt`) |

Быстрые шаги, не требующие логов: M1, а также поддержка макросов `__MAC_15_0`/`__MAC_26_0`
(сделано в `itlwm/PrivateSPI.pch`), Info.plist-варианты (`AirportItlwm-Sequoia/Tahoe-Info.plist`).

## Как читать diag (лог-папка `logs/<host>-<os>-<ts>/`)

- `kextstat.txt` — грузится ли наш kext и какие сетевые kext'ы реально в системе
  (должен быть сток: IOSkywalkFamily + IO80211Family, БЕЗ Legacy/плагинов).
- `headers-IO80211Family/`, `headers-IOSkywalkFamily/` — приватные заголовки эталона.
- `symbols-*.txt` — `nm -gU` экспортов: классы и vtable-методы для сверки layout.
- `frameworks.txt` — CFBundleVersion всех сетевых kext'ов (для OSBundleLibraries).
- `csrutil.txt`, `vtd.txt` — SIP и VT-d/AppleVTD состояние (чистота стенда).
- `panics.txt` + `Kernel*.panic` — при панике: стек вызова прямо указывает слот-расхождение.

## Открытые вопросы

- Реальный diff vtable `IO80211SkywalkInterface` между Sonoma 14.4 и Sequoia/Tahoe.
- Изменился ли набор методов верхнего контракта (RSN/join/bssid) на 15/26.
- Linux-аналог AppleVTD для AMD (стоит ли задачи про IOMapper).