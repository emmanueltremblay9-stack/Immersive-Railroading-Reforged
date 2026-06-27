# External Train Resource Packs

> Draft/spec notice: this document describes current and planned loader behavior for discussion and validation. It is not a stable public pack API until the format is explicitly finalized.

Immersive Railroading Reforged keeps the original Immersive Railroading design goal: train creators should be able to add locomotives, tenders, cars, textures, sounds, and definitions through Minecraft resource packs without editing the base mod.

Public wording:

> Yes, external train/resource-pack support is planned. The goal is to preserve the original Immersive Railroading spirit where creators can add more trains without modifying the base mod. Existing IR packs are a compatibility target, but they must be validated pack-by-pack or supported through an adapter/converter if the old format does not load directly.

## Current Support

The port already loads rolling-stock resources from Minecraft's resource stack:

- `assets/immersiverailroading/rolling_stock/stock.json`
- `assets/immersiverailroading/rolling_stock/stock.caml`
- `assets/immersiverailroading/rolling_stock/gauges.json`
- `assets/immersiverailroading/rolling_stock/gauges.caml`
- `assets/immersiverailroading/rolling_stock/blacklist.json`
- `assets/immersiverailroading/rolling_stock/blacklist.caml`
- `assets/immersiverailroading/track/track.json`
- `assets/immersiverailroading/track/track.caml`

Multiple resource packs can contribute these files. The loader reads all matching resources from the stack, so a pack can append stock entries without replacing the base mod index.

## Stock Types

The stock index supports these lists:

- `locomotives`
- `tender`
- `passenger`
- `freight`
- `tank`
- `hand_car`

Simple entries preserve the original IR convention and resolve under the `immersiverailroading` namespace:

```json
{
  "pack": "My Pack",
  "freight": ["my_flatcar"]
}
```

That entry resolves to:

```text
assets/immersiverailroading/rolling_stock/freight/my_flatcar.json
```

Explicit namespaces are also supported for modern packs:

```json
{
  "pack": "My Pack",
  "freight": ["my_pack:my_flatcar"]
}
```

That entry resolves to:

```text
assets/my_pack/rolling_stock/freight/my_flatcar.json
```

Fully qualified paths also work:

```json
{
  "freight": ["my_pack:rolling_stock/freight/my_flatcar.json"]
}
```

## Required Definition Fields

A minimal freight/passenger/tank/tender definition needs:

- `name`
- `model`
- `properties.weight_kg`
- `passenger`
- `trucks` or `pivot`
- `couplers`

Freight cars also need:

- `freight.slots`
- `freight.width`

Locomotives additionally need their era-specific fields:

- Steam: `era = steam`, boiler/firebox capacity fields, steam sounds as needed.
- Diesel: `era = diesel`, fuel capacity, fuel efficiency, throttle notches, and diesel sounds as needed.

## Metadata

Supported metadata includes:

- `name`
- `modeler`
- `author` as a modern alias when `modeler` is not present
- `pack`
- `description`
- `model_gauge_m`
- `recommended_gauge_m`
- `properties.weight_kg`
- `properties.max_speed_kmh` for locomotive-style definitions
- diesel fuel fields such as `fuel_capacity_l`, `fuel_efficiency_%`, and `fuel_override`

## Asset References

Definitions can reference assets in the base mod namespace or an external pack namespace:

```json
{
  "model": "my_pack:models/rolling_stock/freight/my_flatcar/my_flatcar.obj",
  "sounds": {
    "wheels": "my_pack:sounds/freight/my_flatcar/wheels.ogg"
  }
}
```

Unqualified values default to the `immersiverailroading` namespace for original IR compatibility.

Do not copy third-party assets into this repository unless their license explicitly permits it. The included template uses a small template-owned OBJ placeholder and base default sound references.

## Template Pack

See:

```text
examples/train-pack-template
```

The template demonstrates a resource pack that contributes an external, namespaced stock definition through the original `immersiverailroading` stock index.

## Validation

Run:

```powershell
.\gradlew.bat validateExternalTrainPackTemplate
```

The task writes:

```text
build/reports/train-packs/external-train-pack-template-validation.json
```

To validate another pack root with the same structural checks:

```powershell
.\gradlew.bat validateExternalTrainPackTemplate -PtrainPackDir=C:\Path\To\PackRoot
```

This validates pack metadata, stock index entries, JSON definitions, required fields, and model asset references. CAML definitions are accepted by the runtime loader, but this validation task currently performs only presence checks for CAML files.

## Original IR Compatibility Status

Current status: partially works.

Original-style packs that add `assets/immersiverailroading/rolling_stock/stock.json` or `.caml` and use the old folder layout are a direct compatibility target. They still need pack-by-pack validation because individual packs may depend on old assumptions, missing assets, malformed CAML, legacy sound names, or model group naming that the 1.21.1 port has not tested yet.

If a pack cannot load directly, add a compatibility adapter or converter for the format difference. Do not rewrite third-party pack data manually into this repository.
