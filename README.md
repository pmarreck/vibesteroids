# Vibesteroids

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A functional-style Asteroids clone implemented in vanilla JavaScript in a single HTML file with a pure, immutable game state architecture.

## Why "Vibesteroids"?

This project was an experiment in **100% "vibe coding"** - an emerging development paradigm where developers direct and guide the coding process through natural language conversation with AI models, never writing code directly themselves. The name "Vibesteroids" reflects this approach where every single line of code was written by AI through conversational direction. The game code was started using a locally-running model (GLM-4.5-Air) running on an M4 128GB Macbook Pro, and then refined using Claude 4. This project showcases what's possible with pure conversational programming while maintaining focus on clean code, testability, and functional programming principles.

*Note: Any overly pedantic or verbose explanations in this README are also the result of the no-human-code rule - blame Claude! 🤖*

## Features

- 🎮 Classic Asteroids gameplay with smooth controls
- 🧪 Comprehensive test suite (108 tests)
- 🎨 Pure functional design with immutable state
- 🔊 Dynamic sound effects
- 👶 Kid Mode for easier gameplay
- 🚀 **Single HTML file containing everything** - game, tests, and all assets
- 🛠️ POSIX-compliant launcher script for all Unix-like systems

## Quick Start

### Web Version
Simply open `src/asteroids.html` in any modern web browser, or visit the [live demo](https://pmarreck.github.io/vibesteroids/) hosted on GitHub Pages.

### Command Line (Unix-like systems)
```bash
# Make the script executable if it's not already
chmod +x asteroids

# Run the game
./asteroids
```

### Nix Development Environment
For Nix users, this project includes a flake for a reproducible development environment with Node.js 22 LTS to run the test with:

```bash
# Enter the development shell
nix develop

# Or run commands directly
nix develop --command ./test/asteroids_test
```

## Game Controls

- **Arrow Up**: Thrust forward
- **Arrow Left/Right**: Rotate ship
- **Space**: Fire weapon
- **shift-B**: Activate Death Blossom (desktop)
- **Shake device**: Activate Death Blossom (mobile)
- **shift-K**: Toggle Kid Mode (no scoring, no deaths)
- **shift-T**: Run Tests (press Back button to return to game)
- **esc**: Pause/Resume game

## Game Modes

### Normal Mode
- Standard Asteroids gameplay
- Realistic physics and difficulty
- Full sound effects
- Normal scoring and lives lost

### Kid Mode
- Score and lives left are hidden
- No deaths/lives lost
- No scoring is added
- Toggle with the 'K' key while holding Shift (to prevent accidental activation)

## Technical Design

The game follows a functional architecture with these key principles:

1. **Immutable State**: The entire game state is treated as a single immutable object
2. **Pure Functions**: Game logic is implemented as pure functions
3. **Separation of Concerns**: Clear separation between game logic and rendering
4. **Testability**: All game logic is easily testable
5. **Self-Contained**: Everything (game, tests, assets) exists in a single HTML file for maximum portability

### Core Components

- **Game State**: A single object containing all game data
- **Update Function**: Pure function that computes the next game state
- **Renderer**: Handles drawing the game state to the canvas
- **Input Handler**: Manages keyboard input
- **Sound System**: Handles all sound effects

## Testing

The game includes a comprehensive test suite with 108 tests that can be run in both Node.js and the browser.

### Running Tests

#### In the Browser
1. Open `src/asteroids.html?test` in your browser (or type shift-T in the game)
2. Test results will be displayed on the screen
3. To run with a specific seed for reproducible randomness: `src/asteroids.html?test&seed=12345`

#### Command Line (requires Node.js)
```bash
# Make the test file executable if it's not already
chmod +x test/asteroids_test

# Run the test suite
./test/asteroids_test

# Run with a specific seed for reproducible test results
./test/asteroids_test --seed 12345

# Alternative: use node directly
node test/asteroids_test
node test/asteroids_test --seed 12345
```

*Note: The command-line test runner uses some extraction logic to pull the JavaScript test code out of the HTML file, since the entire test suite is embedded within the single HTML file alongside the game itself.*

### Test Reproducibility

Tests use deterministic randomness with seeds for reproducible results. When a test fails, the seed is displayed in the output (e.g., `[SEED] Using random seed: 608320`) so you can reproduce the exact same test conditions by running with that seed.

### Test Coverage

The test suite covers:
- Game mechanics (movement, collisions, scoring)
- Utility functions
- Edge cases
- Sound system
- Game state management

## Development

### Prerequisites

- Modern web browser (Chrome, Firefox, Safari, Edge)
- Node.js (for running tests from command line)
- Unix-like system (for the launcher script)

### Project Structure

```
.
├── docs/
│   └── index.html        # Main game file (HTML/JS/CSS) - served by GitHub Pages
├── src/
│   └── asteroids.html    # Symlink to ../docs/index.html for local development
├── test/
│   └── asteroids_test    # Test runner
├── asteroids             # POSIX-compliant launcher script
└── README.md             # This file
```

*Note: The `src/asteroids.html` is a symbolic link to `docs/index.html` to support both local development and GitHub Pages deployment from the same file.*

## Contributing

Contributions are welcome! Please ensure all tests pass before submitting a pull request.

## Game Mechanics

### Level Progression
- **Ship Acceleration**: Increases as levels progress
- **Ship Rotation Speed**: Increases as levels progress  
- **Bullet Speed**: Increases as levels progress
- **Fire Rate**: Increases (faster firing) as levels progress
- **Asteroid Count**: Increases by 1 per level
- **Asteroid Max Velocity**: Increases as levels progress

### Physics & Movement
- **Ship Friction**: Applied each frame (violates astrophysics but improves gameplay)
- **Bullet Travel Distance**: Half the screen diagonal before despawning
- **Collision Detection**: Simple circle-based collision system

### Scoring System
- **Points per Asteroid**: 100 points each (all sizes)
- **Extra Life**: Awarded every 20,000 points
- **Death Blossom**: Special ability indicated by ☀️ emoji, one per ship
  - Desktop: Activate with **shift-B**
  - Mobile: Activate by **shaking device**

### Special Features
- **Safe Respawn Zone**: 20% larger collision detection area when waiting for ship respawn
- **Kid Mode**: Hides scoring, prevents death, no lives system
- **Sound Effects**: Dynamic Web Audio API generated sounds
- **Mobile Support**: Touch controls with full-screen angle mapping

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by the classic Atari Asteroids game
- Built with vanilla JavaScript (no external dependencies)
- Sound effects generated with the Web Audio API
