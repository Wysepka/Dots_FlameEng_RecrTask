# Dots_FlameEng_RecrTask

A simple arcade game built with **Flutter** and **Flame Engine**.

The player controls a **yellow dot** by dragging it across the screen. The goal is to **absorb green dots** to grow in size and increase the score, while avoiding **red dots** that reduce the player's lives. The run ends when all lives are lost.

## Gameplay

- **Yellow dot** — the player character
- **Green dots** — collectibles that increase score and grow the player
- **Red dots** — enemies that reduce player lives on collision
- **Drag gesture movement** — the player is moved directly with touch / drag input
- **Game over condition** — the game ends when the life count reaches zero

### Rules

- The player starts with **3 lives**.
- Green collectibles are worth **20 points** each.
- Each collected green dot increases the player size by **1.2x**.
- Enemies and collectibles are spawned repeatedly during gameplay.

## Screens

The project contains four main application states / screens:

1. **Start Game** — entry screen with a button to begin the game
2. **Game** — the Flame-powered gameplay screen
3. **Game Over** — shown when the player loses all lives, displays the score
4. **Restart** — allows starting a fresh run after game over

## Tech Stack

- **Flutter**
- **Flame Engine**
- **flutter_bloc** for state management
- **logger** for debug logging

## Project Structure

```text
lib/
├── blocs/
│   ├── game_lifecycle/
│   └── game_stats/
├── core/
│   ├── app_logger.dart
│   ├── enums_container.dart
│   └── game_root_screen.dart
├── game/
│   ├── components/
│   ├── config/
│   ├── containers/
│   ├── managers/
│   ├── utility/
│   ├── dots_game.dart
│   └── dots_world.dart
├── ui/
│   ├── screens/
│   └── widgets/
└── main.dart
```

## Architecture Overview

### Flutter layer
The app starts in `main.dart`, where a `MultiBlocProvider` registers:

- `GameLifecycleBloc` — controls which screen is visible
- `GameStatsBloc` — stores lives and score

`GameRootScreen` listens to the lifecycle state and swaps between menu, gameplay, game over, and restart flow.

### Flame layer
The actual game is hosted inside `DotsGame`, which creates a `CameraComponent` and a `DotsWorld`.

`DotsWorld`:
- enables Flame collision detection
- adds a `ScreenHitbox`
- spawns `ActorsManager`

`ActorsManager`:
- creates the player
- periodically spawns enemy dots
- periodically spawns collectible dots
- keeps track of spawned actors for safe spawning / cleanup

### Components
- `PlayerSpriteComponent` handles drag input and player collision logic
- `EnemySpriteComponent` defines red hostile dots
- `CollectibleSpriteComponent` defines green collectible dots
- `DotActorSpriteComponent` provides shared moving / bouncing logic for spawned actors
- `DotSpriteComponent` provides shared sprite sizing / resize handling

## Game Flow

1. The app opens on the **Start Game** screen.
2. Pressing **Start Game** switches the lifecycle state to gameplay.
3. A Flame `GameWidget` is created and starts the world.
4. The player moves by dragging the yellow dot.
5. Collecting green dots:
   - removes the collectible
   - increases score
   - enlarges the player
6. Hitting red dots:
   - removes the enemy
   - decreases lives
   - triggers a short collision disabling cooldown
7. When lives reach zero, the lifecycle changes to **Game Over**.
8. The player can continue to the **Restart** screen and start a fresh run.

## Collision and Movement

- The player uses a circular hitbox and drag gestures.
- Moving actors bounce off the screen bounds using collision response utilities.
- Spawn logic avoids placing new dots too close to the player or existing actors.
- Player position is clamped to the visible camera area.

## Running the Project

### Prerequisites

Make sure you have installed:

- Flutter SDK
- Dart SDK
- A configured emulator, simulator, or mobile target

### Install dependencies

```bash
flutter pub get
```

### Run the game

```bash
flutter run
```

## Assets

The game uses custom sprite assets located under:

```text
assets/images/components/actors/
```

These include the player, enemy, and collectible dot sprites.

## Notes

This project was created as a recruitment task and focuses on:

- clean separation between UI and game logic
- simple but readable Flame component architecture
- basic Bloc-driven screen flow
- collision handling and repeated actor spawning

## Possible Future Improvements

- Pause screen
- Difficulty progression over time
- Persistent high score
- Sound effects and music
- Better HUD during gameplay
- Object pooling for spawned dots
- Animations and visual feedback polish

## Author

**Marcin Wysocki**

