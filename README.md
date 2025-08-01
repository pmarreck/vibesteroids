# Vibesteroids

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A functional-style Asteroids clone implemented in vanilla JavaScript in a single HTML file with a pure, immutable game state architecture.
The game code was started using a locally-running model (GLM-4.5-Air) running on an M4 128GB Macbook Pro, and then refined using Claude 4.
This project showcases LLM-aided development with a focus on clean code, testability, and functional programming principles.

## Features

- 🎮 Classic Asteroids gameplay with smooth controls
- 🧪 Comprehensive test suite
- 🎨 Pure functional design with immutable state
- 🔊 Dynamic sound effects
- 👶 Kid Mode for easier gameplay
- 🚀 Single HTML file for easy distribution
- 🛠️ POSIX-compliant launcher script for all Unix-like systems

## Quick Start

### Web Version
Simply open `src/asteroids.html` in any modern web browser.

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

### Core Components

- **Game State**: A single object containing all game data
- **Update Function**: Pure function that computes the next game state
- **Renderer**: Handles drawing the game state to the canvas
- **Input Handler**: Manages keyboard input
- **Sound System**: Handles all sound effects

## Testing

The game includes a comprehensive test suite that can be run in both Node.js and the browser.

### Running Tests

#### In the Browser
1. Open `src/asteroids.html?test` in your browser (or type shift-T in the game)
2. Test results will be displayed on the screen

#### Command Line (requires Node.js)
```bash
# Make the test file executable if it's not already
chmod +x test/asteroids_test
# Run the test suite
./test/asteroids_test
```

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
├── src/
│   └── asteroids.html    # Main game file (HTML/JS/CSS)
├── test/
│   └── asteroids_test    # Test runner
├── asteroids             # POSIX-compliant launcher script
└── README.md             # This file
```

## Contributing

Contributions are welcome! Please ensure all tests pass before submitting a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Inspired by the classic Atari Asteroids game
- Built with vanilla JavaScript (no external dependencies)
- Sound effects generated with the Web Audio API
