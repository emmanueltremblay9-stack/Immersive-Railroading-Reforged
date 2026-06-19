# Porting Status

Last updated: 2026-06-19

## Target

- Project: Immersive Railroading Reforged
- Status: unofficial 1.21.1 NeoForge port scaffold that configures, compiles, builds, and installs into the Prism LAB instance; runtime smoke testing is still not done
- Minecraft: 1.21.1
- Loader: NeoForge
- NeoForge baseline from prompt: 21.1.216
- Java runtime verified locally: Temurin 21.0.11, 64-bit
- Mod id: `immersiverailroading`
- Package root: `cam72cam.immersiverailroading`
- Port branch: `port/1.21.1-neoforge`
- Previous upstream version: `1.10.0`
- Current port test version: `1.10.1`

## Source Commits

| Component | Branch | Commit |
| --- | --- | --- |
| Immersive Railroading | `master` | `36357921121a4d854191f543a6f8b5bdb6e9702f` |
| Universal Mod Core | `1.21.1-neoforge` | `73ac4992fea5996c78954bb899d46fe092fcdd1c` |
| Track API | `neoforge_1.21.1` | `890504fd91f726fc552d8bcb089f19ae18de31d9` |
| Immersive Railroading Integration | `1.21.1-neoforge` | `6dea48f91ac03fd89e0318affeba6df15fa35e24` |

## Completed This Session

- Cloned upstream Immersive Railroading source history into the port repo.
- Created local branch `port/1.21.1-neoforge`.
- Added GitHub remote `https://github.com/emmanueltremblay9-stack/Immersive-Railroading-Reforged.git`.
- Cloned required UMC, TrackAPI, and integration branches outside the repo under `C:\AI-Work\ImmersiveRailroadingReforged-upstreams`.
- Ran the UMC generator. The first pass failed on the integration SSH URL; the second pass succeeded after switching `umc.json` to HTTPS.
- Preserved the generated NeoForge scaffold files in source control.
- Added integration as a Git submodule.
- Updated generated scaffold to target Java 21 and bumped the test version to `1.10.1`.
- Added the supplied port logo to resources and NeoForge metadata.
- Added initial license, notice, migration, compatibility, test, and modification documents.
- Added `install-mod.ps1` for repeatable Prism LAB installation.
- Built the IR production JAR and installed it into the Prism LAB `minecraft\mods` folder.
- Copied the required UMC and TrackAPI runtime dependency jars into the same LAB mods folder after metadata inspection showed they were missing.
- Updated `install-mod.ps1` so each install also mirrors the built IR runtime JAR and required runtime dependency JARs into the fixed project `libs` directory. The installer no longer creates a mirror directory; `libs` is tracked with a README and must exist.

## Command Evidence

Full logs are under `build/reports/port/` in the local workspace. The `build/` directory is generated output and is not committed.

| Command | Result |
| --- | --- |
| `java -version` | Exit 0. Temurin OpenJDK 21.0.11 64-bit. |
| `.\gradlew.bat --version` in UMC | Exit 0. Gradle 8.14, JVM 21.0.11. |
| `.\gradlew.bat --version` in TrackAPI | Exit 0. Gradle 8.14, JVM 21.0.11. |
| `.\gradlew.bat --version` in upstream IR before generation | Exit 1. Wrapper properties were missing before UMC setup. |
| `.\gradlew.bat clean build --stacktrace --warning-mode all` in UMC | Exit 1. Failed at `:neoFormTransformSource`. |
| `.\gradlew.bat clean build --stacktrace --warning-mode all` in TrackAPI | Exit 1. Failed at `:neoFormTransformSource`. |
| `java -jar UMCSetup.jar 1.21.1-neoforge` before HTTPS URL fix | Exit 1. JGit SSH clone failed with `Server key did not validate` for the integration repo. |
| `java -jar UMCSetup.jar 1.21.1-neoforge` after HTTPS URL fix | Exit 0. Generated scaffold and cloned integration branch. |
| `.\gradlew.bat tasks --stacktrace --warning-mode all` in IR | Exit 0. Gradle configuration completed and listed runnable tasks. |
| `.\gradlew.bat clean build --stacktrace --warning-mode all` in IR | Exit 0. `compileJava`, `processResources`, `remapJar`, `sourcesJar`, and `build` completed. |
| `.\install-mod.ps1` first pass | Exit 1 after successful build. Installer rejected ambiguous runtime selection because downgraded/shadow intermediate jars also contained metadata. |
| `.\install-mod.ps1 -SkipBuild` after selector fix | Exit 0. Installed and hash-verified the unclassified production JAR. |
| `.\install-mod.ps1 -SkipBuild` after project `libs` mirror update | Exit 0. Reinstalled Prism LAB jars and mirrored IR, UMC, and TrackAPI into project `libs` with matching SHA-256 hashes. |

## Build Artifacts

| Artifact | Path |
| --- | --- |
| Production JAR | `build/libs/ImmersiveRailroading-1.21.1-neoforge-1.10.1-8803e12.jar` |
| Sources JAR | `build/libs/ImmersiveRailroading-1.21.1-neoforge-1.10.1-8803e12-sources.jar` |
| Install report | `build/install-report.json` |
| Project libs mirror | `libs\ImmersiveRailroading-1.21.1-neoforge-1.10.1-8803e12.jar`, `libs\TrackAPI-1.21.1-neoforge-1.2-a965c1.jar`, `libs\UniversalModCore-1.21.1-neoforge-1.3.0-73ac499.jar` |

## Prism LAB Install Evidence

| Field | Value |
| --- | --- |
| Installed JAR | `C:\Users\Emmanuel Tremblay\AppData\Roaming\PrismLauncher\instances\1.21.1 TesT LaB\minecraft\mods\ImmersiveRailroading-1.21.1-neoforge-1.10.1-3635792.jar` |
| Source SHA-256 | `B8BBAF958CF599ADEA2F6805C9739640209662AEF748D631AA484673179B07A9` |
| Installed SHA-256 | `B8BBAF958CF599ADEA2F6805C9739640209662AEF748D631AA484673179B07A9` |
| Hash match | yes |
| Deleted old IR jars | none found |
| Remaining IR jars | 1 |
| Installed metadata | contains `META-INF/neoforge.mods.toml` |
| Installed logo | contains `immersive_railroading_neoforge_icon.png` |
| Installed entrypoint | contains `cam72cam/immersiverailroading/Mod.class` |

Required runtime dependency jars now present in LAB:

| Mod id | Installed file | SHA-256 |
| --- | --- | --- |
| `trackapi` | `TrackAPI-1.21.1-neoforge-1.2-a965c1.jar` | `1371E2510D22A943F75D216508130138892836B0BAD30A547C8A40C53D29A835` |
| `universalmodcore` | `UniversalModCore-1.21.1-neoforge-1.3.0-73ac499.jar` | `32039570B0B88F9CC4279B6651B8DCCE7400220707274956C616DBC262FFA95F` |

Final primary-mod scan in LAB found exactly:

- `immersiverailroading`: 1 jar
- `trackapi`: 1 jar
- `universalmodcore`: 1 jar

## Current Blockers and Risks

1. **Dependency source builds fail before compilation**
   - Severity: high
   - Affected subsystem: UMC and TrackAPI source-build bootstrap
   - Reproduction: run `.\gradlew.bat clean build --stacktrace --warning-mode all` in either dependency checkout.
   - Evidence: both fail at `:neoFormTransformSource`.
   - Suspected root cause: NeoForge/NeoForm source transformation child Java process failure. The current stacktrace does not expose the child process stderr; rerun with `--info` or inspect NeoForm transform outputs next.

2. **Runtime smoke testing has not been performed**
   - Severity: high
   - Affected subsystem: actual Minecraft client/server startup
   - Current status: build and install are verified, but client title screen, world load, dedicated server startup, and gameplay are untested.

3. **Integration dependency versions need review**
   - Severity: medium
   - Affected subsystem: optional integrations and TrackAPI dependency wiring
   - Evidence: generated integration `dependencies.gradle` references `trackapi:TrackAPI:1.21.1-neoforge-1.2-a965c1`, while the prompt asks to evaluate the current `1.3` branch first.
   - Next action: determine source compatibility before changing the coordinate.

4. **Forge-labeled optional integration artifact appears in Gradle dependency output**
   - Severity: medium
   - Affected subsystem: CC:Tweaked optional integration
   - Evidence: `modImplementation` includes `cc.tweaked:cc-tweaked-1.21.1-forge:1.116.2`.
   - Next action: verify whether this artifact is compatible in NeoForge dev/runtime or replace/isolate it before release.

## Runtime Status

- Client startup: not tested
- Dedicated server startup: not tested
- Gameplay: not tested
- Multiplayer: not tested
- Save migration: not tested
- Resource-pack compatibility: not tested

## Temporary Feature Gates

None introduced.

## Next Highest-Value Step

Run a controlled dedicated-server smoke test, then a client title-screen/world-create smoke test. If startup fails, classify the first runtime failure by subsystem before changing IR domain logic.
