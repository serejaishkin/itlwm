# itlwm

**An Intel Wi-Fi Adapter Kernel Extension for macOS, based on the OpenBSD Project.**

## Documentation

We highly recommend exploring our documentation before using this Kernel Extension:

- [Intro](https://OpenIntelWireless.github.io/itlwm)
- [Compatibility](https://openintelwireless.github.io/itlwm/Compat)
- [FAQ](https://openintelwireless.github.io/itlwm/FAQ)

## Sequoia / Tahoe development branch

The `sequoia-tahoe` branch contains experimental work for modern macOS releases, including macOS 26 (Tahoe).

This project is a **KEXT** and still requires `MacKernelSDK`; it is not a DriverKit Wi-Fi driver.

### Build on macOS Tahoe with modern Xcode

The original Xcode project contains legacy deployment targets for older macOS releases. Modern Xcode rejects targets below 10.13, while the Tahoe build should explicitly use macOS 26.

The repository now includes helpers that install `MacKernelSDK` and build the `itlwm` target with `MACOSX_DEPLOYMENT_TARGET=26.0`:

```bash
cd itlwm
bash scripts/build-tahoe.sh
```

If you already have a complete `MacKernelSDK` directory, the setup step will reuse it.

### Why MacKernelSDK is required

`itlwm` is a kernel extension and uses headers such as `mach/mach_types.h` and `libkern/libkern.h`. Those headers are supplied to the project through:

```text
MacKernelSDK/Headers
MacKernelSDK/Library/x86_64
```

If Xcode reports `mach/mach_types.h file not found` or `libkern/libkern.h file not found`, initialize the SDK first:

```bash
bash scripts/setup_mackernelsdk.sh
```

## Download

[![Download from https://github.com/OpenIntelWireless/itlwm/releases](https://img.shields.io/github/v/release/OpenIntelWireless/itlwm?label=Download)](https://github.com/OpenIntelWireless/itlwm/releases)

## Questions and Issues

Check out our [FAQ Page](https://openintelwireless.github.io/itlwm/FAQ) for more info.

If you have other questions or feedback, feel free to [![Join the chat at https://gitter.im/OpenIntelWireless/itlwm](https://badges.gitter.im/OpenIntelWireless/itlwm.svg)](https://gitter.im/OpenIntelWireless/itlwm?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge).

We only accept bug reports in GitHub Issues, before opening an issue, you're recommended to reconfirm it with us on Gitter; once it's confirmed, please use the provided issue template.

## Credits

- [Acidanthera](https://github.com/acidanthera) for [MacKernelSDK](https://github.com/acidanthera/MacKernelSDK)
- [Apple](https://www.apple.com) for macOS
- [AppleIntelWiFi](https://github.com/AppleIntelWiFi) for Black80211-Catalina
- [ErrorErrorError](https://github.com/ErrorErrorError) for UserClient bug fixes
- [Intel](https://www.intel.com) for Wireless Adapter Firmwares and iwlwifi
- [Linux](https://www.kernel.org) for iwlwifi
- [mercurysquad](https://github.com/mercurysquad) for Voodoo80211
- [OpenBSD](https://openbsd.org) for net80211, iwn, iwm, and iwx
- [pigworlds](https://github.com/OpenIntelWireless/itlwm/commits?author=pigworlds) for DVM devices support, MIRA bug fixes, and Tx aggregation for MVM Gen 1 devices
- [rpeshkov](https://github.com/rpeshkov) for black80211
- [usr-sse2](https://github.com/usr-sse2) for implementing the usage of Apple RSN Supplicant and bug fixes
- [zxystd](https://github.com/zxystd) for developing itlwm

## Acknowledgements

- [@penghubingzhou](https://github.com/startpenghubingzhou)
- [@Bat.bat](https://github.com/williambj1)
- [@iStarForever](https://github.com/XStar-Dev)
- [@stevezhengshiqi](https://github.com/stevezhengshiqi)
- [@DogAndPot](https://github.com/williambj1)
- [@Daliansky](https://github.com/Daliansky)
- [@serejaishkin](https://github.com/serejaishkin)
