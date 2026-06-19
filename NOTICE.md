# Notice

Immersive Railroading Reforged is an unofficial Minecraft 1.21.1 NeoForge port of Immersive Railroading. It is not sponsored by, endorsed by, or currently authorized as an official TeamOpenIndustry release.

This repository preserves the upstream Immersive Railroading identity internally for compatibility, including the `immersiverailroading` mod id and `cam72cam.immersiverailroading` package root.

## Upstream Sources

| Component | Repository | Branch | Commit | License | Use in this repo |
| --- | --- | --- | --- | --- | --- |
| Immersive Railroading | https://github.com/TeamOpenIndustry/ImmersiveRailroading | `master` | `36357921121a4d854191f543a6f8b5bdb6e9702f` | LGPL-2.1; model assets under MODEL_LICENSE | Primary preserved source tree and assets |
| Universal Mod Core | https://github.com/TeamOpenIndustry/UniversalModCore | `1.21.1-neoforge` | `73ac4992fea5996c78954bb899d46fe092fcdd1c` | LGPL-2.1 | Required platform abstraction dependency; built from source during port validation |
| Track API | https://github.com/TeamOpenIndustry/TrackAPI | `neoforge_1.21.1` | `890504fd91f726fc552d8bcb089f19ae18de31d9` | MIT | Required rail interoperability dependency; built from source during port validation |
| Immersive Railroading Integration | https://github.com/TeamOpenIndustry/ImmersiveRailroadingIntegration | `1.21.1-neoforge` | `6dea48f91ac03fd89e0318affeba6df15fa35e24` | LGPL-2.1 | Tracked as a Git submodule for optional integration wiring |

## Current Modifications

See [MODIFICATIONS.md](MODIFICATIONS.md) for the active modification record.

## Asset Notice

Immersive Railroading model/art assets are governed by [MODEL_LICENSE](MODEL_LICENSE), Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International. Do not distribute builds containing those assets commercially without separate permission from the relevant rights holders.

The NeoForge logo resource `src/main/resources/immersive_railroading_neoforge_icon.png` was supplied for this port workspace.

## Source Availability

Distributions of this port must include corresponding source or a durable source offer satisfying LGPL-2.1 obligations. This repository is intended to provide that source for port builds made from it.
