# The Sacred Flame
**CS50 Game Development — Final Project**
**Platform:** LÖVE2D / Lua
**Genre:** Metroidvania Platformer
**Version:** 0.1 (Design Document)


credits:
Ruined temple background: https://szadiart.itch.io/background-ruined-temple
Music:
https://madmakingmistery.itch.io/temple-of-comfort
https://gerytsch.itch.io/darkmusicpack
Torch asset: https://carloszepter.itch.io/cat-fantasy-asset-pack-torches
Dark Series assets: https://itch.io/s/145923/dark-series-bundle
Ancient temple asset: https://aamatniekss.itch.io/ancient-temple-tileset
Fire: https://stealthix.itch.io/fire-animations
SFX: CS50
---

## Overview

The Sacred Flame is a Metroidvania platformer about descending a corrupted temple, rekindling its sacred flames, and defeating the dark entity that extinguished them. The player carries the last ember of the sacred flame — an orb that serves as weapon, health indicator, and the last hope of restoring the temple.

**Core goal:** Descend to the depths of the temple, illuminate the darkness along the way, defeat dark enemies, and destroy the boss at the bottom to seal the rift and restore the sacred flame.

---

## World Structure

**Total rooms:** 14
- 1 Temple Entry (tutorial)
- 5 Main shaft areas (center column, primary descent)
- 3 Left side rooms (torch chambers and exploration)
- 4 Right side rooms (torch chambers and exploration)
- 1 Boss Room

**Special areas:**
- Area 4 contains the mini boss
- 1 optional secret passage connecting Area 3 to Area 5, bypassing Area 4

**Map layout (3 columns):**
```
         [Temple Entry]
[Left] -- [Area 1] -- [Right R1]
[Left R5]-- [Area 2] -- [X blocked]
[Left R6]-- [Area 3] -- [Right R2]
[X blocked]-- [Area 4: Mini Boss] -- [Right R3]
[Left R7]-- [Area 5] -- [Right R4]
              ↓
          [Boss Room]
```

---

## Torch System

**Total torches:** 12
- 1 per main shaft area (Areas 1-5) — 5 torches
- 1 per side room (R1, R2, R3, R4, R5, R6, R7) — 7 torches
- Area 4 torch is **locked** — only lights after mini boss is defeated
- Boss room contains a final sacred brazier — lights automatically on boss defeat

**Minimum torches to access boss room:** 7 of 12

**Torch functions:**
- Save point — game saves on torch lighting
- Room transformation — dark void room converts to warm temple
- Orb restoration — restores one orb strength level
- Boss scaling — number of torches lit determines boss difficulty

---

## The Orb (Sacred Flame)

The orb is the central mechanic of the game. It is simultaneously:
- The player's weapon
- The player's health indicator
- The player's lives system
- The last ember of the sacred flame

**Orb strength levels:** 5

| Strength | Appearance | State |
|---|---|---|
| 5 | Bright, large, vibrant | Full power |
| 4 | Slightly dimmed | Healthy |
| 3 | Noticeably dimmer | Hurt |
| 2 | Flickering, small | Critical |
| 1 | Barely glowing | Last chance |
| 0 | Extinguished | Game over |

**Orb strength changes:**
- Taking damage dims the orb
- Dying reduces orb strength by one level
- Lighting a torch restores one strength level
- Orb extinguished = permanent game over

---

## Health & Loss Conditions

**Health recovery:**
- Enemies drop flame energy on death — small health restore
- Passive slow regeneration when out of combat
- Lighting a torch restores full health

**Respawn system:**
- Die in a regular room — respawn at last lit torch, orb loses one strength level
- Orb reaches zero strength — permanent game over, flame extinguished

**Loss conditions:**
- Orb extinguished (strength reaches 0) anywhere in the temple — game over
- Death during boss fight — permanent game over, no respawn
- Both lead to game over screen with retry or return to main menu

**Boss room access requirement:**
- Minimum 7 of 12 torches lit
- Door remains sealed below this threshold

---

## Boss Scaling

The final boss scales inversely with torches lit. More torches lit = weaker boss.

| Torches Lit | Boss HP | Boss Damage | Notes |
|---|---|---|---|
| 7 / 12 | +50% | +40% | Minimum access, very hard |
| 8-9 / 12 | +25% | +20% | Hard |
| 10-11 / 12 | Base | Base | Intended experience |
| 12 / 12 | -20% | -10% | Fully restored, easiest |

---

## Mini Boss (Area 4)

- Located in Area 4 of the main descent shaft
- Defeating it unlocks the Area 4 torch
- Defeating it grants a combat reward (TBD)
- Can be bypassed entirely via the secret passage (Area 3 → Area 5)
- Bypassing means missing the Area 4 torch and its reward

---

## Secret Passage

- Hidden connection between Area 3 and Area 5
- Bypasses Area 4 and the mini boss entirely
- Contains a significant powerup reward
- Trade off: faster descent but miss Area 4 torch, harder boss scaling

**Player choice created:**
- Main path: fight mini boss, light Area 4 torch, easier boss
- Secret path: skip mini boss, gain secret powerup, harder boss
- Both: hardest playthrough, maximum rewards, weakest boss

---

## Combat

**Player attacks:**
- Fire Dart — orb fires projectile forward, fast, ranged
- Melee Strike — short range burst from orb, higher damage, close range

**Enemies:**
- 2 regular enemy types with distinct AI behaviors
- 1 mini boss (Area 4)
- 1 final boss (boss room, 2-3 phases)

---

## Game States

| State | Type | Purpose |
|---|---|---|
| StartState | Base | Title screen, start game, continue, quit |
| PlayState | Base | Core gameplay, traversal, combat, exploration |
| TorchLightingState | Pushed | Animation plays when torch lit, room transforms, game saves. Player cannot move. Pops back to PlayState when complete |
| BossState | Pushed | Final boss encounter — special music, boss health bar, camera locks to arena. Pushed on top of PlayState |
| PauseState | Pushed | Mid-game pause menu, pushed over PlayState |
| RespawnState | Pushed | Brief fade in after regular death — "The flame endures..." — resumes PlayState from save data with orb strength reduced |
| GameOverState | Base | Triggered when orb strength reaches 0 or boss kills player. Shows "The sacred flame was extinguished." Options: retry from last save or return to main menu |
| VictoryState | Base | Boss defeated, final brazier lights, flame restored, credits |

**State stack pattern (from Pokemon lecture):**
- Base states replace each other
- Pushed states sit on top of PlayState and pop back when done
- PlayState never fully unloads during torch lighting, pause, or boss fight

---

## Technical Foundation

- **Mario (CS50):** Platformer physics, tile rendering, camera system
- **Zelda (CS50):** Room transition system adapted vertically, enemy AI, hitbox combat
- **Angry Birds (CS50):** Box2D for environmental physics (moving platforms, hazards)
- **Pokemon (CS50):** State stacks for pause and interaction states, GUI system

**Original systems:**
- Orb companion entity with lerp following behavior
- Boss scaling tied to player exploration choices
- Torch system combining save points, health restore, and room transformation
- Metroidvania room connection system (4 directional transitions)
- Sacred flame strength as unified health and lives system

---

## Assets

- **Environment:** Dark Series asset pack (penusbmic) + Underground Temple tileset
- **Player:** Hooded protagonist sprite sheet
- **Enemies:** Dark Series enemy sprites
- **Boss:** TBD from Dark Series
- **Fire VFX:** Fire Pixel Art VFX pack + Fire Animations pack
- **Projectile:** Fire Pixel Bullet pack

---

## Scope

### Must Have
- Player movement, jump, collision
- Orb companion — follows player, fires projectiles, visual health indicator
- Room system with 4-directional transitions
- 14 rooms hand-authored in Tiled
- Torch lighting mechanic — save point, health restore, room transformation, orb restoration
- 12 torches, 7 minimum for boss access
- Boss scaling based on torches lit
- Flame fragments dropped by enemies — small health restore
- 2 regular enemy types with distinct AI
- 1 mini boss (Area 4, locked torch)
- 1 final boss (2-3 phases, scales with torches)
- Sacred flame orb strength system (5 levels, death penalty, game over at 0)
- All 5 game states
- Win and loss conditions
- Secret passage (Area 3 to Area 5)
- Debug mode for graders
- README

### Nice To Have
- Parallax backgrounds
- Screen shake on hit
- Fall damage
- Sprite animations beyond placeholders
- Basic sound effects
- Transition room temple to void aesthetic
- Orb color progression with upgrades
- Victory stats screen
- Moving platforms via Box2D

### Wishes
- NPC survivors with dialogue
- Merchant NPC with shop
- Currency system using flame fragments
- Full Dark Series enemy roster
- Music tracks
- Mini map
- Multiple endings
- Lore tablets and environmental storytelling

---

## Debug Mode

A debug mode is available for graders and testers. Toggle with **F1** during gameplay.

**Debug features:**
- **F1** — toggle debug mode on/off
- **F2** — jump to boss room instantly
- **F3** — jump to any room by number
- **F4** — toggle invincibility (no death)
- **F5** — toggle one-hit kill on enemies
- **F6** — set torch count manually (test boss scaling)
- **F7** — restore orb to full strength
- **F8** — toggle collision boxes visible

Debug mode will be clearly documented in the README so graders know it exists.

---

## Development Tools

**Game Engine:**
- LÖVE2D 11.5 — game framework
- Lua — programming language

**Level Design:**
- Tiled Map Editor (mapeditor.org) — paint tile-based rooms, place objects, export as Lua
- LDtk / Level Designer Toolkit (ldtk.io) — alternative to Tiled, more powerful auto-tile and randomization rules

**LÖVE Libraries:**
- STI (Simple Tiled Implementation) — loads Tiled .lua exports into LÖVE
- anim8 — sprite animation system
- hump.camera — camera follow with boundaries
- knife — state machine
- push — resolution scaling
- lume — Lua utility functions
- rotLove — roguelike toolkit, used for interior room randomization
- jumper — pathfinding (available if needed for enemy AI)
- class.lua — OOP class system
- require.lua — cleaner file requiring

**Asset Tools:**
- Tiled — tileset slicing and room design
- Aseprite (optional) — sprite editing if assets need modification

**Asset Sources:**
- Dark Series asset pack (penusbmic on itch.io) — enemies, bosses, environment, FX, decor
- Hooded protagonist sprite sheet (itch.io)
- Fire Pixel Art VFX pack
- Fire Animations pack
- Fire Pixel Bullet pack (free)

---

*README v0.1 — April 2026 — updated as development progresses*
