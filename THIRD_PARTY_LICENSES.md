# Third-Party Licenses

This file summarizes third-party licensing relevant to the port. It does not replace the upstream license files.

| Component | License | Notes |
| --- | --- | --- |
| Immersive Railroading code | LGPL-2.1 | Preserved from upstream source. See [LICENSE](LICENSE). |
| Immersive Railroading models/assets | CC BY-NC-SA 4.0 | Preserved from upstream assets. See [MODEL_LICENSE](MODEL_LICENSE). |
| Universal Mod Core | LGPL-2.1 | Consumed as `cam72cam.universalmodcore:UniversalModCore`. Source branch and commit are recorded in [NOTICE.md](NOTICE.md). |
| Immersive Railroading Integration | LGPL-2.1 | Tracked as a submodule. Source branch and commit are recorded in [NOTICE.md](NOTICE.md). |
| Track API | MIT | Required dependency. Source branch and commit are recorded in [NOTICE.md](NOTICE.md). |
| NeoForge | LGPL-2.1 | Build/runtime dependency; not vendored here. |
| Minecraft | Proprietary | Runtime dependency; not distributed by this repository. |
| CC:Tweaked | MPL-2.0 | Optional integration dependency referenced by the integration branch; not vendored here. |
| Immersive Engineering | Custom/third-party project license | Optional integration dependency referenced by the integration branch; not vendored here. |

Before publishing any binary release, inspect the final JAR contents and dependency report to confirm no unapproved third-party binaries, local paths, credentials, generated worlds, logs, or proprietary resource packs are included.
