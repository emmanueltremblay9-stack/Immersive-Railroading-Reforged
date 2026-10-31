# Engineer Manual Decisions

## 2026-06-19: Exclude TrackAPI And UMC Technical References

User instruction excludes:

- TrackAPI technical reference.
- Universal Mod Core technical reference.

Impact:

- Do not execute Notion prompt sections 12 and 13.
- Do not implement Phase 8 technical appendices for TrackAPI or UMC.
- Do not add compile-tested TrackAPI/UMC API examples or dedicated appendix screenshots.
- Keep existing runtime dependency checks intact because the mod still depends on both jars.

## 2026-06-19: Use Immersive Engineering Manual As Runtime Target

User clarified that the target UI is the Immersive Engineering Engineer's Manual shown in game, not a separate IR-owned book screen.

Decision:

- Export all IR manual entries into `assets/immersiverailroading/manual/` using per-entry `.json` files and localized `.txt` files.
- Put IE's runtime discovery file at `assets/immersiveengineering/manual/autoload.json`; it must use fully namespaced `immersiverailroading:*` category and entry ids so IE discovers the addon category at startup.
- Show the entries under one IE category: `manual.immersiverailroading.immersive_railroading`.
- Make the IR manual item open the IE Engineer's Manual through the Immersive Engineering integration when IE is loaded.
- Do not ship or register a separate `EngineersManualGui`.
- Keep TrackAPI and UMC technical-reference material excluded by user instruction.

## 2026-06-19: Start With Resource Contract And Validation

The complete manual is large enough that shipping UI code before a validated content contract would make later coverage checks unreliable.

Decision:

- Add a first-party resource root and minimal validated entries first.
- Add Gradle validation/report tasks before replacing `ItemManual` behavior.
- Keep generated first-party resources as the source-backed coverage contract, then export them into IE manual resources for runtime.

## 2026-06-19: Generate Source-Backed Coverage Scaffold

The Notion prompt requires every audited player-facing IR feature to map to a manual entry. Writing final curated prose for all features is still a larger content pass, but leaving uncovered features makes later UI and coverage work ambiguous.

Decision:

- Generate missing IR-owned categories and entries deterministically from `FEATURE_COVERAGE.csv`.
- Mark generated rows as `scaffolded`, not final `complete`, unless they were already complete.
- Use source-backed feature ids and registry/class names in each entry so the pages are not empty placeholders.
- Keep TrackAPI and UMC technical-reference material excluded by user instruction.
- Require the generated resources to pass the same link, widget, coverage, and localization validation as hand-written entries.

## 2026-06-20: Promote the IE Manual Export to Full First-Party Content

The follow-up task requested full implementation inside the Immersive Engineering Engineer's Manual instead of the earlier generic scaffold.

Decision:

- Add `FULL_CONTENT.json` as the maintained content map for player-facing IE manual prose.
- Generate 24 categories, 55 entries, and 66 documented coverage rows from the content map and source coverage data.
- Keep the runtime discovery file under `assets/immersiveengineering/manual/autoload.json`.
- Keep TrackAPI and UMC technical-reference appendices excluded by prior user scope; the runtime dependencies remain documented as dependencies, not expanded technical manuals.
