# Compatibility Matrix

Status key: `not tested`, `blocked`, `partial`, `pass`, `fail`.

| Area | Status | Evidence / next action |
| --- | --- | --- |
| Clean build on Java 21 | pass | IR `.\gradlew.bat clean build --stacktrace --warning-mode all` completed successfully. UMC and TrackAPI standalone source builds still fail separately at `:neoFormTransformSource`. |
| No Forge artifacts mixed into NeoForge runtime | partial | `modImplementation` dependency output still includes `cc.tweaked:cc-tweaked-1.21.1-forge:1.116.2`; optional integration isolation needs review before release. |
| License and notice files included | partial | Compliance files exist in source; final JAR contains NeoForge metadata, but full license/notice JAR audit is still needed. |
| Sources JAR generated | pass | `build/libs/ImmersiveRailroading-1.21.1-neoforge-1.10.1-3635792-sources.jar` was generated. |
| Client reaches title screen | not tested | Requires successful runtime JAR. |
| Client creates/loads world | not tested | Requires successful runtime JAR. |
| Dedicated server creates/loads world | not tested | Requires successful runtime JAR. |
| Same JAR works client and server | not tested | Build/install verified only; client and dedicated server smoke tests still required. |
| Core loads without optional integrations | not tested | Build/install verified only; optional dependency classloading still requires smoke tests. |
| Straight track | not tested | Requires in-game validation or GameTest. |
| Curved track | not tested | Requires in-game validation or GameTest. |
| Sloped track | not tested | Requires in-game validation or GameTest. |
| Switch track | not tested | Requires in-game validation or GameTest. |
| Crossing/turntable behavior | not tested | Confirm upstream support and run in-game validation. |
| Track preview/final placement | not tested | Requires client and server validation. |
| Chunk-boundary traversal | not tested | Requires GameTest or controlled world test. |
| Steam locomotive | not tested | Requires rolling-stock build/spawn test. |
| Diesel locomotive | not tested | Requires rolling-stock build/spawn test. |
| Passenger car | not tested | Requires rolling-stock build/spawn test. |
| Freight car | not tested | Requires rolling-stock build/spawn test. |
| Tank car | not tested | Requires rolling-stock build/spawn test. |
| Tender | not tested | Requires rolling-stock build/spawn test. |
| Hand car | not tested | Requires rolling-stock build/spawn test. |
| Coupling/uncoupling | not tested | Requires multiplayer-safe server validation. |
| Mount/dismount | not tested | Requires client/server validation. |
| Controls: throttle/reverser/brakes/horn/bell | not tested | Requires networking and input validation. |
| Inventory and fluids | not tested | Requires capability and save/reload validation. |
| Bundled models | not tested | Requires client render test. |
| Custom stock pack | not tested | Requires representative test pack. |
| Part animation | not tested | Requires render and resource-pack validation. |
| Particles | not tested | Requires client render test. |
| Sounds | not tested | Requires client audio test. |
| Overlay controls | not tested | Requires client input/render test. |
| Repeated resource reload | not tested | Requires client resource reload test. |
| Malformed pack diagnostics | not tested | Requires validator or fixture test. |
| Two-player state sync | not tested | Requires dedicated server multiplayer test. |
| Late join sync | not tested | Requires dedicated server multiplayer test. |
| Unauthorized packet rejection | not tested | Requires networking tests. |
| Server restart persistence | not tested | Requires save/reload test. |
| Multiblock machines | not tested | Requires in-game and save/reload validation. |
| Immersive Engineering present/absent | not tested | Requires optional integration isolation test. |
| CC:Tweaked present/absent | not tested | Requires optional integration isolation test. |
| Old item fixture | not tested | Need authentic fixture or capture procedure. |
| Old rolling-stock fixture | not tested | Need authentic fixture or capture procedure. |
| Old coupled consist fixture | not tested | Need authentic fixture or capture procedure. |
| Old rail/block-entity fixture | not tested | Need authentic fixture or capture procedure. |
| Representative old resource pack | not tested | Need licensed fixture pack. |
