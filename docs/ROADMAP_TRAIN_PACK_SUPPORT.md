# Roadmap Issue Draft: External Train / Resource Pack Support

## Title

External train/resource-pack support roadmap

## Public Statement

External train/resource-pack support is planned. The goal is to preserve the original Immersive Railroading design where creators can add locomotives, rolling stock, models, textures, sounds, and definitions without modifying the base mod. Existing IR packs are a compatibility target, but compatibility will be tested pack-by-pack. If the old format cannot be loaded directly, an adapter or converter may be used. Until the loader format is finalized, creator documentation should be treated as draft/spec work, not a stable pack API.

## Scope

- Support external locomotive, tender, freight, passenger, model, texture, sound, and definition resources.
- Preserve data-driven loading where practical.
- Validate original IR train packs one pack at a time.
- Track compatibility evidence in `docs/TRAIN_PACK_COMPATIBILITY.md`.
- Avoid bundling third-party assets unless license permission is clear.

## Non-Goals

- No blanket claim that all original IR packs work.
- No copying third-party train pack assets into the base mod.
- No stable public pack API promise until the loader format is finalized.
- No manual rewrite of third-party pack data into this repository.

## Proposed Milestones

1. Document current loader behavior and known gaps.
2. Collect pack compatibility reports through the train pack compatibility issue form.
3. Validate a small set of clearly licensed or author-permitted packs.
4. Identify direct-load failures that need an adapter or converter.
5. Draft the pack schema after the loader behavior is proven.
6. Mark creator documentation as stable only after schema, validation tooling, and compatibility expectations are settled.

## Acceptance Criteria

- Compatibility matrix contains tested packs with source, license/permission status, tested versions, result, and notes.
- Issue reports include enough logs and screenshots to reproduce failures.
- The project can explain which parts of original IR pack loading work directly, which require adapter/converter work, and which are blocked by license or missing data.
- Creator documentation clearly distinguishes draft/spec behavior from stable API behavior.

## Risks

- Original packs may rely on old loader behavior, old CAML quirks, or model group naming assumptions.
- Some packs may have unclear redistribution or testing permission.
- Partial compatibility may be pack-specific and should not be generalized.
- Converter work may be needed if old formats cannot be loaded directly.
