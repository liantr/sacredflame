# The Sacred Flame
**CS50 Game Development — Final Project**
**Author:** Lian Randle — lir140@g.harvard.edu
**Engine:** LÖVE2D 11.5 / Lua
**Genre:** 2D Platformer


## Running the Game
Requires LÖVE2D 11.5. From the project root:

```
love .
```

## Controls

| Key | Action |
| Arrow Left / Right | Move |
| Space | Jump |
| Left Shift | Run |
| Z | Sword swing |
| X | Sword combo attack |
| C | Dash (grants brief invulnerability) |
| L | Light torch (when in range) |
| O | Open door (when in range) |
| P | Pause |
| Enter | Confirm (menus) |

## Debug Mode

Toggle in `src/constants.lua`:

```lua
DEBUG = true   -- shows collision boxes, hitboxes, hurtboxes.
```

When `DEBUG` is true, the player also starts with all powerups unlocked (wall hold, double jump, attack combo),
which allows testing later rooms without playing through the full game.

Set `DEBUG = false` before final play-through for the intended experience.

## Gameplay Overview

The player descends through 7 interconnected rooms of a corrupted ancient temple, fighting enemies and rekindling sacred torches. Each torch lit is a respawn point and restores full health. A minimum number of torches must be lit to open the door to the boss room.

The final boss scales in difficulty based on how many torches have been lit — the more torches lit, the weaker the boss. This creates a trade-off between taking time to explore and rushing to the boss.

**Win condition:** Defeat the boss.
**Loss condition:** Die 3 times. After 3 deaths, the game over screen appears.

## Room Structure

| Room | Description |
|---|---|
| `entry` | Starting room. One torch. Introduces basic movement. |
| `main1` | First combat room. Dagger bandits and archer bandits on multiple platforms. |
| `main2` | Platforming room. No enemies. Wall-hold powerup at the bottom. Two entries from main1. |
| `main3` | Long vertical descent. Heavy enemy placement across multiple elevation levels. Double-jump powerup near the top. |
| `main4` | Pre-boss room. Door requires minimum torches to open. Side room accessible via east exit. |
| `main4-right` | Optional side room east of main4. Contains one torch. No enemies. Combo attack powerup near the bottom right. |
| `boss` | Boss arena. Boss spawns when player crosses approaches the room's midpoint. Boss music triggers in the BattleState. |

**Total torches:** 6 (one per room except boss room)
**Minimum to open boss door:** 5

## Torch System

Torches serve three functions:

1. **Save point** — lighting a torch saves the player's current room and position as a respawn point
2. **Health restore** — lighting a torch restores the player to full health
3. **Boss scaling** — each torch lit reduces the boss's starting health by 2 HP (base health 30, minimum 18 with all 6 lit)

The torch proximity prompt renders above the foreground layer so it is visible in all lighting conditions.

## Enemy Types

| Enemy | Behavior |
|---|---|
| Dagger Bandit | Melee. Idles, detects player within range, chases, attacks at close range. |
| Archer Bandit | Ranged. Chases to attack distance, fires a volley attack at the player's position with a brief delay to allow dodging. |
| Spitter | Melee. Similar chase/attack pattern to dagger bandit. |
| Ghoul | Same as Spitter |
| Boss | Three attack patterns. Teleports around the room. |

All regular enemies have a 4% chance to drop a health pickup on death. Health pickups apply immediately and trigger a particle effect on the player.

Enemies in cleared rooms stay dead unless the player dies and respawns, at which point all rooms reset.

## Boss Battle

The boss battle is triggered when the player crosses the horizontal midpoint of the boss room. At that point:

- Boss music starts
- `BossBattleState` is pushed onto the state stack
- The boss spawns via `Room:spawnBoss` and enters the `appear` state

The boss uses a state machine with the following cycle:

- **appear** → 50/50 chase or immediate attack
- **chase** → attack when within range
- **attack1** → wide horizontal sweep in both directions
- **attack2** → boss moves across the room while swinging its sword on a timer
- **attack3** → diagonal projectile pattern that strikes twice
- After attack1/attack3 → 50/50 idle or disappear
- **idle** → brief dwell (0.5–1s) then chase
- **disappear** → reappear near the player

The boss uses a separate hurtbox system from its Box2D body. This allows the hurtbox shape to change per animation frame, which is needed because the boss sprite changes shape between attacks. The hurtbox table is built at init from the def and looked up per animation frame in `Boss:update`.

If the player leaves the boss room during a battle, the battle state is cleaned up — boss music stops, boss is removed, and `bossBattleInitiated` resets so the battle can retrigger on re-entry.

## Powerups

| Powerup | Location | Effect |
|---|---|---|
| Wall Hold | Main 2 (bottom left) | Player can grab and hold walls, enabling wall jumping |
| Double Jump | Main 3 (top right) | Player can jump a second time in the air |
| Combo Attack | Main 4 Right (bottom left) | Player can press X to deal double damage |

Powerups float via a sine wave and collision is handled by Box2D.


## State Architecture

The game uses two state patterns:

**StateStack** — states layered on top of each other. Only the top state updates, but all states render (bottom to top). Used for:
- PlayState (base gameplay)
- BossBattleState (pushed over PlayState during boss fight — must manually call `playState:update` since it sits on top)
- PauseState
- FadeInState / FadeOutState
- DialogueState
- GameOverState
- VictoryState
- StartState

**StateMachine** — per-entity state machines for player, enemies, boss, flame, torches, and doors. Each entity owns its state machine.

## Physics

Box2D is used for all collisions, except hitboxes and the boss body. Key design decisions:

- All room collision bodies are created at room init but set to inactive. They activate on `Room:enter` and deactivate on `Room:exit`. This prevents bodies from rooms
  the player is not currently in from being in play.
- Player/enemy and player/boss collisions are disabled in `preSolve` (enemies cannot push the player and vice versa).
- Player/torch and player/powerup collisions are also disabled in `preSolve` (pass-through).
- Door collision is disabled in `preSolve` when the door is open.
- Spike damage fires in `beginContact`.
- The boss does not use Box2D for its hurtbox — hurtboxes are manually computed from the body position each frame. This is because the boss changes shape
  during it's attacks which means the Box2D body would need to be destroyed and recreated each frame so the body is not used for collision between the 
  boss and the player.

## Room Transitions

Rooms connect via gaps in their tile maps. Each connection defines:
- `gapX` / `gapY` — the position of the opening in the current room
- `spawnX` / `spawnY` — where the player appears in the destination room

North/south transitions check whether the player's X is within the gap range.

East/west transitions check whether the player's Y is within the gap range.

On transition, a fade-out/fade-in tween plays. Music changes only if the new room uses a different music track.

## File Structure

```
main.lua                        Entry point. LÖVE callbacks, push setup, global state stack.
src/
  Dependencies.lua              All requires. Loaded once from main.lua.
  constants.lua                 Game-wide constants. DEBUG flag here.
  Util.lua                      Global helper functions: quad generation, hitbox/damage helpers,
                                animation creation, distance utilities, generateFramesList.
  Animation.lua                 Frame-based animation class. Supports looping, offsets, named frames.
                                Extended from CS50 base with name, offsetX, offsetY fields.
  HitBox.lua                    Simple data class: x, y, width, height.
  HUD.lua                       Renders health bar (scissor-clipped) and lit torch count.
  Room.lua                      Loads Tiled map, manages collidable bodies, enemies, objects, attacks.
                                Handles enter/exit (activating/deactivating bodies), spawn, render,
                                darkness overlay via stencil.

  defs/
    entity_defs.lua             All entity definitions: player, flame, all enemy types, boss.
                                Includes animations, hitboxes, hurtboxes, stats. Boss attack 3
                                hitboxes are generated procedurally via generateBossAttack3HitBoxesDef.
    object_defs.lua             Torch, powerup, and door definitions including animations.
    room_defs.lua               Room map paths, music, spawn points, connected rooms, enemy and
                                object placements.

  entities/
    Entity.lua                  Base class for all entities. Box2D body creation, animation playback,
                                invulnerability flashing, health/death logic, health drop on death.
    Player.lua                  Extends Entity. Input handling, wall grab logic, particle system
                                for health restore effect, glow surrounding the player sprite render.
    Boss.lua                    Extends Entity. Custom hurtbox system per animation frame. Health
                                scaled by torches lit at spawn time.
    Flame.lua                   Extends Entity. Kinematic body. Follows player and has a sine
                                float.

  objects/
    Object.lua                  Base class for room objects. Box2D static body, basic render.
    Torch.lua                   Extends Object. Lit/unlit states, light radius expansion, save point
                                on lighting, proximity prompt rendering above the foreground layer.
    Door.lua                    Extends Object. Open/closed states with animation. Torch requirement
                                check. Prompt renders when player is in range.
    Powerup.lua                 Extends Object. Sine float animation. Consumed flag removes t the room.

  states/
    BaseState.lua               Empty interface. All states inherit from this.
    StateMachine.lua            Per-entity state machine. Supports update, render, processAI.
    StateStack.lua              Global state stack. Only top state updates; all states render.
    PlayState.lua               Core game loop. Box2D world, room map, player/flame spawn,
                                collision callbacks (beginContact/endContact/preSolve/postSolve),
                                camera, room transitions, respawn, torch counting, boss battle trigger.
    BossBattleState.lua         Pushed over PlayState during boss fight. Starts boss music, spawns
                                boss. Manually calls playState:update since StateStack only updates
                                the top state.
    StartState.lua              Title screen. Press Enter to start.
    PauseState.lua              Pause menu. Resume or Quit.
    GameOverState.lua           Game over screen. Clears stack and returns to StartState.
    VictoryState.lua            Victory screen after boss death. Clears stack and returns to StartState.
    FadeInState.lua             Black fade in. Pops itself on complete, then calls callback.
    FadeOutState.lua            Black fade out. Pops itself on complete, then calls callback.
    DialogueState.lua           Text dialogue overlay. Used for tutorial, control panel and powerup acquisition text.

    player/
      PlayerIdleState.lua       Stops horizontal movement. Transitions to walk, run, jump, dash, attack.
      PlayerWalkState.lua       Handles movement input. Transitions to run, jump, fall, attack, dash.
      PlayerRunState.lua        Extends PlayerWalkState. Checks lshift release to return to walk.
      PlayerJumpState.lua       Applies jump velocity. Transitions to falling when velocity goes positive.
      PlayerFallingState.lua    Raycasts downward to detect ground. Supports double jump, wall grab, attack.
      PlayerDashState.lua       Timed dash via Timer. Grants invulnerability for dash duration.
      PlayerWallHoldState.lua   Zeroes velocity. Checks arrow key hold. Wall jump on space.
      PlayerSwordSwingState.lua Handles both swing and combo animations. Per-frame hitbox damage.
      PlayerDeathState.lua      Plays death animation. After 3 deaths, it pushes GameOverState and otherwise respawns.

    enemy/
      EnemyChaseState.lua       Extends EntityWalkState. Chases player, transitions to attack or idle.
      EnemyAttackState.lua      Plays attack animation. Per-frame hitbox damage. Spawns VolleyAttack
                                for ranged enemies on last animation frame.
      EnemyDeathState.lua       Plays death animation. Sets dead flag. Handles boss death sequence
                                (stops music, triggers victory after delay).

    entity/
      EntityIdleState.lua       Base idle for enemies. Detects player, transitions to chase.
      EntityWalkState.lua       Base walk for enemies. Raycasts ahead for ground. Random direction
                                changes. Detects player to transition to chase.

    boss/
      BossIdleState.lua         Brief dwell (0.5-1s) then chases player.
      BossChaseState.lua        Extends EnemyChaseState. Picks random attack on range. Disappears
                                if player goes out of detection range.
      BossAttackState.lua       Extends EnemyAttackState. Handles all three attack patterns.
                                Attack2 is looping with a duration timer. Per-frame hitboxes recreated
                                each frame since boss moves during attack2.
      BossAppearState.lua       Positions boss near room center (random left/right side). After
                                animation completes, 50/50 chase or immediate attack.
      BossDisappearState.lua    Plays the disappear animation. After 1s transitions to appear, guarded
                                by bodyDestroyed flag to handle respawn cleanup safely.

    objects/
      TorchUnlitState.lua       Sets unlit animation.
      TorchLitState.lua         Sets lit animation and the lit flag.
      DoorClosedState.lua       Sets closed animation.
      DoorOpenState.lua         Sets open animation. Sets door.open = true at frame 9.

    flame/
      FlameFollowingState.lua   Calls Flame:returnToPlayer every update.

  gui/
    Panel.lua                   Bordered panel rendering utility.
    Textbox.lua                 Scrolling text display for dialogue.

  VolleyAttack.lua              Archer bandit ranged attack. Spawned at player position with a brief
                                delay. Not a Box2D body - uses manual AABB collision via
                                damagePlayerWithHitBox.

assets/
  graphics/
    map/                        Tiled-exported Lua maps for each room.
    characters/                 Sprite sheets for player, all enemies, boss.
    ruinedTemple/               Parallax background layers (4 layers).
    objects/                    Torch, door spritesheets.
    powerups/                   Wall-hold, double-jump icons.
    health/                     Health bar decoration, health bar fill, particle texture.
    fire/                       Flame companion sprite sheet.
  sounds/                       BGM tracks (temple, depths, boss) and hit SFX.

fonts/                          MedievalSharp.ttf (titles/menus), font.ttf (HUD/prompts).

lib/
  class.lua                     OOP class system.
  push.lua                      Resolution scaling (virtual 640x368, window 1280x736).
  knife/timer.lua               Timer, tween, after - used throughout for animation timing.
  sti/                          Simple Tiled Implementation - loads Tiled Lua map exports.
```

## Design Decisions

**Why Box2D for a platformer?**
Box2D handles collision detection, physics response, and raycasting well. The sensor fixture pattern (used for torches, powerups, flame) avoids writing custom overlap code. The cost is that Box2D bodies cannot change shape after creation, which is why the boss uses a manual hurtbox system instead.

**Why separate hitbox and hurtbox systems?**
Regular enemies use their Box2D body as a hurtbox — player sword swing checks collision against the body AABB. The boss cannot do this because its effective damage area changes significantly between animations and attack phases. The manual hurtbox system in `Boss.lua` looks up dimensions per animation name and frame from a prebuilt table, allowing precise per-frame control without modifying the physics body.

**Why is BossBattleState pushed over PlayState instead of replacing it?**
The boss fight happens within the existing playable world. Replacing PlayState would require reconstructing the entire Box2D world and all room states. Pushing BossBattleState keeps the world intact and adds boss-specific behavior (music, spawn) on top. The trade-off is that BossBattleState must manually call `playState:update` since StateStack only updates the top state.

**Why does respawn reset all room enemies?**
The design intent is that lighting a torch is meaningful progress. Enemy state is not meaningful progress, so rooms reset on death to maintain challenge. Torches, powerups, and door state persist across respawns because those represent player achievement.

**Why are all room bodies created at init but activated on enter?**
If all bodies were always active, Box2D would process collisions between entities in rooms the player is not in, causing incorrect behavior. Enemies in other rooms taking damage, incorrect ground detection etc.

**Why does the boss use bodyDestroyed flag instead of checking body:isActive()?**
In LÖVE/Box2D, calling any method on a destroyed body throws a Lua error — the Lua reference remains valid but the underlying C object is gone. A boolean flag set before `body:destroy()` is the only safe way to guard against this in timer callbacks that may fire after a body has been destroyed.

## Known Limitations
- From BEST: Secret passage, mini boss and flame attack were not implemented due to time constraints.
- SFX limited to hit sounds only

## Credits

| Asset | Source |
|---|---|
| Ruined Temple Background | szadiart.itch.io/background-ruined-temple |
| Ancient Temple Tileset | aamatniekss.itch.io/ancient-temple-tileset |
| Dark Series Asset Bundle | itch.io/s/145923/dark-series-bundle |  (all characters except the fire)
| Fire Animations | stealthix.itch.io/fire-animations |
| Torch Asset | carloszepter.itch.io/cat-fantasy-asset-pack-torches |
| Music: Temple BGM | madmakingmistery.itch.io/temple-of-comfort |
| Music: Depths BGM | gerytsch.itch.io/darkmusicpack |
| Music: Boss Battle | megumi-ryu.itch.io/free-epic-battle-music-asset-dark-queen-battle-bgm |
| SFX | CS50 Game Development course assets |
| Animation, BaseState, StateMachine, StateStack, FadeIn/Out, Dialogue | Colton Ogden / CS50 (extended) |