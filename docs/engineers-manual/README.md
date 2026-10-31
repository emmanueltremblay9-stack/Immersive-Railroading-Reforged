# Engineer Manual Implementation Notes

This directory tracks the in-game Engineer Manual work for the unofficial Immersive Railroading Reforged port.

Current scope:

- Target: Minecraft 1.21.1, NeoForge, Java 21.
- Owning mod for the first implementation pass: `immersiverailroading`.
- Existing item id to preserve: `item_manual`.
- Runtime target: Immersive Engineering Engineer's Manual.
- IE manual resource root: `assets/immersiverailroading/manual/`.
- First-party coverage source root: `assets/immersiverailroading/engineers_manual/`.
- Current implementation stage: complete first-party IE manual export generated from `FULL_CONTENT.json`.
- Current validated resource count: 24 categories, 55 entries, 66 audited IR features documented.
- Current IE manual target: one `Immersive Railroading Reforged` category with 55 entries.

Explicit exclusions from the active task, by user instruction:

- TrackAPI technical reference appendix.
- Universal Mod Core technical reference appendix.
- Dedicated TrackAPI/UMC example compilation, screenshots, and technical-reference coverage gates.

These exclusions do not remove the existing runtime dependencies from the mod. They only remove the technical-reference authoring tasks from this Engineer Manual task.

## Commands

```powershell
.\tools\generate-engineers-manual-scaffold.ps1
.\gradlew.bat validateEngineersManual
.\gradlew.bat testEngineersManual
.\gradlew.bat reportEngineersManualLocalization
.\gradlew.bat reportEngineersManualCoverage
.\gradlew.bat verifyManualExamples
```

The standard build now runs the manual validation tasks through Gradle `check`.
Reports are written under `build/reports/engineers-manual/`, including:

- `manual-validation.json`
- `localization-coverage.json`
- `feature-coverage.json`
- `example-verification.json`
