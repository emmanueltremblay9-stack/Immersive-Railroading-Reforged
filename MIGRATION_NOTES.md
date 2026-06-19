# Migration Notes

This file tracks save, NBT, data-component, registry, and resource-pack migration work for the 1.21.1 NeoForge port.

## Current Status

No migration layer has been implemented or validated yet. Do not claim backward compatibility until fixture tests pass.

## Compatibility Rules

- Preserve entity ids, block ids, item ids, block-entity ids, resource locations, definition ids, gauge ids, NBT keys, JSON keys, packet meanings, and registry names unless a documented 1.21.1 constraint forces a change.
- Preserve rolling-stock UUID relationships, consist/coupler state, controls, inventory, fluid, fuel, paint, definition id, position, velocity, and gauge information.
- Read old data before writing new data. If direct legacy NBT is no longer appropriate, use a versioned compatibility layer.
- Never mutate an authentic user world during automated migration testing.
- Produce recoverable errors for unsupported legacy data instead of silently deleting state.

## Fixture Plan

Authentic fixtures are still required for:

- 1.16.5 item stacks
- rolling stock with controls/fuel/inventory
- coupled consist
- rail and preview block entities
- multiblock machine state
- fluid tank car
- custom resource-pack stock identifier

If authentic fixtures are unavailable, create a fixture-capture procedure and mark backward compatibility as unverified.

## Registry Migration

No registry renames are planned. The mod id remains `immersiverailroading`.

## Resource-Pack Migration

Existing `assets/immersiverailroading/rolling_stock` lookup semantics should be preserved. No automatic third-party pack rewrite is planned.
