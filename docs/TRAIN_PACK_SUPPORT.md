# External Train / Resource Pack Support

External train/resource-pack support is planned. The goal is to preserve the original Immersive Railroading design where creators can add locomotives, rolling stock, models, textures, sounds, and definitions without modifying the base mod. Existing IR packs are a compatibility target, but compatibility will be tested pack-by-pack. If the old format cannot be loaded directly, an adapter or converter may be used. Until the loader format is finalized, creator documentation should be treated as draft/spec work, not a stable pack API.

## Public Goal

Immersive Railroading Reforged should keep train content data-driven. The base mod should not hardcode every locomotive, tender, freight car, passenger car, texture, sound, or model into runtime code.

The public goal is to let resource-pack creators add train content without editing or rebuilding the base mod, while keeping compatibility claims conservative and evidence-based.

## Planned Support

The support plan covers external resource packs that can provide:

- Locomotive definitions
- Tender definitions
- Freight and passenger rolling stock definitions
- Bogies, trucks, wheels, and related model groups
- OBJ model references
- Texture references
- Sound references
- Metadata such as name, author, gauge, mass, speed, fuel type, and description

The exact supported schema and loader behavior are not a stable public pack API until they are documented as finalized and validated against real packs.

## Original IR Pack Compatibility

Original Immersive Railroading train packs are a compatibility target. That does not mean every existing pack is guaranteed to work in this 1.21.1 NeoForge port.

Compatibility will be validated pack-by-pack. Each pack can differ in folder layout, CAML or JSON formatting, model group names, texture paths, sound paths, dependencies, and license status.

If an original IR pack cannot load directly, the preferred path is a compatibility adapter or converter for the format difference. Do not rewrite or bundle third-party pack data into this repository unless the license and permission status clearly allow it.

## License Boundaries

Third-party train pack assets must not be copied, imported, bundled, or redistributed with this project unless their license explicitly permits it.

Compatibility testing can track links, metadata, errors, and notes. The project should avoid hosting pack assets without clear permission from the author or rights holder.

## Documentation Status

Any creator-facing guide in this repository should be treated as draft/spec work unless it explicitly says the format is stable. Draft documentation may describe current implementation behavior, but it should not be presented as a final pack API.

Related files:

- [Draft train resource pack guide](train-resource-packs.md)
- [Compatibility matrix](TRAIN_PACK_COMPATIBILITY.md)
- [Roadmap issue draft](ROADMAP_TRAIN_PACK_SUPPORT.md)
