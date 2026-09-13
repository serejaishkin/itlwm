# Test Bench Quickstart (стенд Ryzentosh + сборщик MBP)

Чек-лист для прогона M2/M3: инжекция ТОЛЬКО нашего kext на стоковом стеке,
SIP включён, без AMFIPass/legacy/OC Block.

## 1. Сборка на MBP (MacBook Pro 11,1, Sequoia, Xcode 16)

```bash
git pull origin sequoia-tahoe
bash scripts/build-tahoe.sh
```

Результат:
```
build-tahoe/Build/Products/Debug/Sonoma14.4/AirportItlwm.kext
build-tahoe/Build/Products/Debug/Sequoia/AirportItlwm.kext
build-tahoe/Build/Products/Debug/Tahoe/AirportItlwm.kext
```

Проверка, что гейт `__IO80211_TARGET` реально применился (скрипт сам это
проверяет, но и вручную):

```bash
strings -a build-tahoe/Build/Products/Debug/Tahoe/AirportItlwm.kext/Contents/MacOS/AirportItlwm | grep SkywalkContract
# ожидаем: SkywalkContract:15plus  (Sonoma вариант даёт SkywalkContract:14_4)
```

После сборки готовые kext автоматически коммитятся в репо и лягут в корень
проекта: `AirportItlwm-Sonoma14.4.kext`, `AirportItlwm-Sequoia.kext`,
`AirportItlwm-Tahoe.kext`.

## 1.5 Добавление kext в OpenCore (что прописывать)

В `EFI/OC/config.plist` → `Kernel` → `Add` — новый элемент:

| Ключ | Значение |
|------|----------|
| `BundlePath` | `AirportItlwm-Tahoe.kext` |
| `ExecutablePath` | `Contents/MacOS/AirportItlwm` |
| `PlistPath` | `Contents/Info.plist` |
| `Enabled` | `true` |
| `MinKernel`/`MaxKernel` | опционально: `26.0.0` / – (привязать к ОС; для Tahoe-варианта логично `MinKernel=15.0.0`+) |

Больше ничего из kext'а вручную прописывать НЕ нужно — но важно:
- версии зависимостей в `Info.plist` (ключ `OSBundleLibraries`) должны
  совпадать с версиями `IO80211Family`/`IOSkywalkFamily` на целевой ОС —
  сейчас в `AirportItlwm-Tahoe-Info.plist` стоит затычка от Sonoma, пока не
  пришлёте `frameworks.txt` с Tahoe-машины (M6);
- остальная чистота стенда — см. раздел 2.

## 2. Чистота стенда (RYZENTOSH)

В EFI/OC **должно быть**:

| Что | Значение |
|-----|----------|
| `csr-active-config` | `00000000` (SIP полностью включён) |
| AMFIPass / boot-arg `amfi_get_out_of_my_way=1` | **отсутствуют** |
| `IO80211FamilyLegacy.kext` + плагины | **отсутствуют** |
| OC `Block` (блокирование системных kext) | **пусто** |
| DOWNGRADE IOSkywalkFamily | **не делать** |
| Boot-args | `-itlwmdbg -itlwmcontract` плюс, при необходимости, debug itlwm |
| VT-d / AppleVTD | включён в BIOS (SVM/IOMMU), в OC `vt-d` не выключен |

Из `IO80211Family.kext`/`IOSkywalkFamily.kext` **не выносить** ничего наружу.

Инжектируем строго один kext: `AirportItlwm-Variant.kext` из шага 1
(рекомендую начинать с Tahoe-варианта, свежий контракт).

## 3. Что ожидать в системе после загрузки

```bash
ioreg -lw0 | grep -i SkywalkContract
# SkywalkContractString = "SkywalkContract:15plus"  — какой контракт скомпилирован
# SkywalkContract = <число>                          — числовое значение __IO80211_TARGET

log show --last 5m --predicate 'eventMessage CONTAINS "CONTRACT"' | grep CONTRACT
# строки фингерпринта vtable: CONTRACT idx=.. addr=0x.. kind=O/.  (нужен -itlwmcontract)
```

Если kext стартует — снимаем дамп фингерпринта (`kind=O` индексы).
Если panics — логи паники напрямую дают слот-расхождение.

## 4. Диагностика и присылка логов

```bash
bash itlwm-test.sh diag     # собирает logs/<host>-<os>-<timestamp>/
# в папке: kextstat.txt, frameworks.txt, csrutil.txt, vtd.txt,
#          wifi_log, panics.txt, headers-IO80211Family/, headers-IOSkywalkFamily/,
#          symbols-IO80211Family.txt, symbols-IOSkywalkFamily.txt,
#          skywalk-contract.txt
```

Из папки `logs/<...>` нужно снять и прислать (или запушить в репо ветки):
- `log show` c `CONTRACT idx=...` строками (можно добавить в `wifi_log`);
- остальные файлы diag.

## 5. Что я из этого возьму

- `framework.txt` → реальные `CFBundleVersion` → правильные `OSBundleLibraries`
  в `AirportItlwm-Sequoia-Info.plist` / `AirportItlwm-Tahoe-Info.plist` (M6).
- `headers-*` / `symbols-*` → сверка `include/Airport` и обновление vtable-гейтов (M4).
- `CONTRACT idx=.. kind=O` с Sequoia и Tahoe → `scripts/analyze-contract.sh`
  покажет, какие слоты контракта сдвинулись между ОС (критично для M4/M5).
- `kextstat.txt`, `csrutil.txt`, `vtd.txt` → чистота стенда.

## Примечание

`scripts/analyze-contract.sh <sequoia-contract.log> <tahoe-contract.log>` —
пример запуска: кладём в файлы выжимки `log show ... | grep CONTRACT` с
каждой машины, скрипт выдаёт подписи «наших» индексов и их diff.