<h1 align="center">
    <br>
        <a href=""><img src="https://i.imgur.com/GibETo1.png" alt="Immersive Railroading" width="250"></a>
    <br>
    Immersive Railroading
    <br>
</h1>
<h4 align="center">
    Immersive Railroading is a Minecraft mod for 1.16, 1.15, 1.14, 1.12, 1.11, 1.10, and 1.7.  It adds a new transport system (item and players) to the game.  It is based in real world physics (where possible) and uses life size models to convey the true scale and grandeur of Railroading.
</h4>

## Immersive Railroading Reforged

This branch is an unofficial Minecraft 1.21.1 NeoForge port scaffold. It is not an official TeamOpenIndustry release and is not currently a playable release candidate.

Current target:

- Minecraft 1.21.1
- NeoForge baseline 21.1.216
- Java 21
- Mod id `immersiverailroading`
- Package root `cam72cam.immersiverailroading`
- Port branch `port/1.21.1-neoforge`

Clone with submodules:

```powershell
git clone --recurse-submodules https://github.com/emmanueltremblay9-stack/Immersive-Railroading-Reforged.git
```

Current evidence and blockers are tracked in [PORTING_STATUS.md](PORTING_STATUS.md). Compatibility and release validation are tracked in [COMPATIBILITY_MATRIX.md](COMPATIBILITY_MATRIX.md), [MIGRATION_NOTES.md](MIGRATION_NOTES.md), and [TEST_PLAN.md](TEST_PLAN.md).

## External Train / Resource Pack Support

External train/resource-pack support is planned. The goal is to preserve the original Immersive Railroading design where creators can add locomotives, rolling stock, models, textures, sounds, and definitions without modifying the base mod. Existing IR packs are a compatibility target, but compatibility will be tested pack-by-pack. If the old format cannot be loaded directly, an adapter or converter may be used. Until the loader format is finalized, creator documentation should be treated as draft/spec work, not a stable pack API.

Roadmap and compatibility tracking:

- [Train pack support roadmap](docs/TRAIN_PACK_SUPPORT.md)
- [Train pack compatibility matrix](docs/TRAIN_PACK_COMPATIBILITY.md)

<p align="center">
  <a href="https://minecraft.curseforge.com/projects/immersive-railroading">
    <img src="http://cf.way2muchnoise.eu/full_277736_downloads.svg">
  </a>
  <a href="">
     <img src="http://cf.way2muchnoise.eu/versions/For%20MC_277736_all.svg">
  </a>
  <a href="">
    <img src="https://github.com/TeamOpenIndustry/ImmersiveRailroading/workflows/Immersive%20Railroading%20Build%20Pipeline/badge.svg">
  </a>
  <!--<a href="https://files.minecraftforge.net/">
     <img src="https://img.shields.io/badge/forge-14.23.1.2555-orange.svg">
  </a>-->
  <!--<a href="https://discordapp.com/invite/CS2RTGq">
    <img src="https://img.shields.io/discord/355731184157720578.svg">
  </a>-->
</p>

<p align="center">
  <a href="#installation">Installation</a> •
  <a href="#dependencies">Dependencies</a> •
  <a href="#rolling-stock">Rolling stock</a> •
  <a href="#bugs-and-suggestions">Bugs and Suggestions</a> •
  <a href="#help">Help</a> •
  <a href="#license">License</a> •
  <a href="#links">Links</a>
</p>

![screenshot](https://i.imgur.com/1gnRu0K.png)

## Installation
You can download the latest version of Immersive Railroading on [Curseforge](https://minecraft.curseforge.com/projects/immersive-railroading/files).
### Dependencies
To get the mod to work you need to add the dependencies to your Mod Folder:
 - [Track API](https://minecraft.curseforge.com/projects/track-api)
 - [Universal Mod Core](https://www.curseforge.com/minecraft/mc-mods/universal-mod-core)
 
We also recommend to add these mods for full functionality of Immersive Railroading:
 - [Immersive Engineering](https://minecraft.curseforge.com/projects/immersive-engineering)
 - [Open Computers](https://minecraft.curseforge.com/projects/opencomputers)
 - [In-Game-Wiki Mod](https://minecraft.curseforge.com/projects/in-game-wiki-mod)
  
## Rolling stock
The original Immersive Railroading design allowed additional trains through external resource packs. For the 1.21.1 NeoForge port, that remains a compatibility target and roadmap item, but existing packs must be tested pack-by-pack before compatibility is claimed.
Creator-facing documentation in this repository is currently draft/spec work unless a document explicitly marks the format as stable.

## Bugs and Suggestions
If you found a bug please open an Issue here on GitHub or report it in the *#bug-reports* Channel on our [Discord](https://discordapp.com/invite/CS2RTGq).
Please make sure to explain the bug as exactly as possible (and add screenshots if possible).

If you want to suggest a feature for the mod, you can do that with opening an Issue.
If you want to suggest rolling stock, please do that in the *#suggestions* Channel on our [Discord](https://discordapp.com/invite/CS2RTGq), not here on Github!

## Help
If you need support you can ask in the *#help* Channel on our [Discord](https://discordapp.com/invite/CS2RTGq). 
Make sure to read *#faq* before asking your question.

## Building
To build ImmersiveRailroading, you will need to have Java 8 installed.  
After cloning, run the `UMCSetup.jar` from the terminal, passing in [the version of UMC](https://github.com/TeamOpenIndustry/UniversalModCore/branches/all) to set up.[^1]  
To perform the build, open a terminal and run `./gradlew build` on Linux/macOS, or `gradle build` on Windows.

[^1]: For example, to set up a build environment for Forge 1.12.2, you would run `java -jar UMCSetup.jar 1.12.2-forge`.

## License
Immersive Railroading is licensed under the *GNU LESSER GENERAL PUBLIC LICENSE*. See [LICENSE](https://github.com/cam72cam/ImmersiveRailroading/blob/master/LICENSE).
The Models are licensed under the [MODEL_LICENSE](https://github.com/cam72cam/ImmersiveRailroading/blob/master/MODEL_LICENSE).

## Links
 - Curseforge: https://minecraft.curseforge.com/projects/immersive-railroading
 - Wiki: https://github.com/cam72cam/ImmersiveRailroading/wiki
 - Discord: https://discord.gg/CS2RTGq
 - Subreddit: https://www.reddit.com/r/ImmersiveRailroading
