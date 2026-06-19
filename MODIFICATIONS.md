# Modifications

This file records material changes made while preparing the unofficial 1.21.1 NeoForge port.

## 2026-06-19

| Path | Purpose |
| --- | --- |
| `.gitignore` | Stop ignoring generated NeoForge scaffold files and the integration checkout so the port repo can build from source instead of relying on local-only generator output. |
| `.gitmodules` | Track `ImmersiveRailroadingIntegration` as a submodule on branch `1.21.1-neoforge`. |
| `umc.json` | Change the integration repository URL from SSH to HTTPS because the generator failed under JGit with `Server key did not validate` for `git@github.com`. |
| `build.gradle` | Preserve UMC-generated NeoForge scaffold, bump the test version to `1.10.1`, and align Java toolchain/release target with Java 21. |
| `settings.gradle` | Preserve UMC-generated Gradle plugin management and project naming. |
| `gradle/wrapper/gradle-wrapper.properties` | Preserve UMC-generated Gradle wrapper configuration for the 1.21.1 NeoForge scaffold. |
| `UMC.md` | Preserve UMC-generated setup note. |
| `src/main/java/cam72cam/immersiverailroading/Mod.java` | Preserve UMC-generated NeoForge mod entrypoint that registers the original `ImmersiveRailroading` class through UMC. |
| `src/main/resources/META-INF/neoforge.mods.toml` | Preserve UMC-generated NeoForge metadata, set LGPL license text, mark the display name as Immersive Railroading Reforged, add project URL, description, and logo file. |
| `src/main/resources/pack.mcmeta` | Update resource pack format for Minecraft 1.21.1. |
| `src/main/resources/immersive_railroading_neoforge_icon.png` | Add supplied port logo resource. |
| `install-mod.ps1` | Add repeatable Windows build/install verification for the Prism LAB mods folder, including runtime JAR selection, old same-mod JAR removal, hash checks, and `build/install-report.json`. |
| `NOTICE.md`, `THIRD_PARTY_LICENSES.md`, `PORTING_STATUS.md`, `COMPATIBILITY_MATRIX.md`, `MIGRATION_NOTES.md`, `TEST_PLAN.md` | Add required status, compliance, migration, and validation documentation for the port. |

No gameplay algorithms, registry names, resource-pack formats, NBT keys, rolling-stock definitions, or physics code have been intentionally changed in this session.
