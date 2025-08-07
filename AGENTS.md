# AGENTS.md - Architecture & Development Guide

> **This document serves as both an architecture overview for humans and a comprehensive guide for future LLMs working on this codebase.**

## 🎮 Project Overview

**Vibesteroids** is a modern HTML5 Canvas implementation of the classic Asteroids arcade game, built with pure functional programming principles and comprehensive test coverage.

### Core Features
- **Classic Asteroids Gameplay**: Ship, asteroids, bullets, collision detection
- **Progressive Difficulty**: Asteroid count increases each level (configurable)
- **Extra Life System**: Awards life every 20,000 points with 5-chime celebration
- **Death Blossom**: Mobile-only secret weapon (shake to activate, or 'B' key)
  - Temporarily removes player control
  - Ship auto-rotates for 9 full rotations at 3x speed
  - Increases max bullets to 50 and firing rate to 10x
  - Plays Star Trek-style "WHOOP" siren sound
  - Shows neon "DEATH BLOSSOM!" message during activation
- **Mobile Support**: Touch controls with iOS motion permission handling
- **Sound System**: Web Audio API synthesis (no external audio files)
- **Neon Visual Style**: 80's retro aesthetic with glow effects

## 🏗️ Architecture Principles

### **1. Functional Programming**
- **Pure Functions**: All game logic functions must be pure (no side effects)
- **Immutable State**: Game state is never mutated, always returns new state objects
- **Predictable**: Same inputs always produce same outputs

```javascript
// ✅ GOOD: Pure function
function updateShipPosition(ship, deltaTime) {
    return {
        ...ship,
        x: ship.x + ship.vx * deltaTime,
        y: ship.y + ship.vy * deltaTime
    };
}

// ❌ BAD: Mutates input
function updateShipPosition(ship, deltaTime) {
    ship.x += ship.vx * deltaTime;  // NEVER DO THIS
    return ship;
}
```

### **2. State Management**
- **Single Game State**: One immutable `GameState` object contains all game data
- **Deep Copy Pattern**: `updateGameState()` creates new state, never mutates existing
- **State Propagation**: Changes flow from pure functions → new state → game loop

### **3. Test-Driven Development (TDD)**
- **MANDATORY**: All features MUST be developed using TDD
- **Test First**: Write failing tests before implementing features
- **Red-Green-Refactor**: Fail → Pass → Clean up

## 📋 Development Workflow

### **TDD Process (STRICTLY ENFORCED)**
1. **Write Test**: Create failing test that defines expected behavior
2. **Run Test**: Verify it fails (proves test is valid)
3. **Implement**: Write minimal code to make test pass
4. **Run Tests**: Verify test passes and no regressions
5. **Refactor**: Clean up code while keeping tests green

### **Test Quality Standards**
- **No Logic in Tests**: Tests should only setup → call → assert
- **Pure Function Testing**: Tests call functions with scalar inputs, assert on scalar outputs; avoid duplicating business logic in tests
- **Comprehensive Coverage**: All features must have thorough test coverage

```javascript
// ✅ GOOD: Clean test structure
it('should award extra life at 20,000 points', function() {
    // Setup state
    const testState = { score: 19950, lives: 3, nextExtraLifeScore: 20000 };

    // Call function
    const result = updateGameState(testState, {}, 0.016, 1000);

    // Assert on results
    if (result.lives !== 4) {
        throw new Error(`Expected 4 lives, got ${result.lives}`);
    }
});

// ❌ BAD: Logic in test
it('should award extra life', function() {
    // Don't implement fix logic inside test!
    if (score >= threshold) {
        lives++; // This belongs in the actual code, not the test
    }
    // ... assertions
});
```

## 🧪 Testing Framework

### **Running Tests**
```bash
# Run all tests (SHOULD BE DONE FREQUENTLY)
node test/asteroids_test

# Tests are also available in browser at:
# http://localhost:8443/asteroids.html?test
```

### **Test Architecture**
- **Browser as Source of Truth**: All test state managed in browser code
- **Node.js Wrapper**: Simple execution wrapper that reports results
- **Exit Codes**: 0 = success, failure count = exit code (standard Unix behavior)
- **86 Tests**: Comprehensive coverage of all game features

### **Test Categories**
- Utility Functions (distance, collision detection)
- Game State Updates (movement, input handling)
- Collision Detection (bullet-asteroid, ship-asteroid)
- Sound System (all game audio events)
- Death Blossom Feature (complete test suite)
- Extra Life System (bullet-collision triggered rewards)
- Progressive Difficulty (level progression)
- Mobile Controls (touch handling, Death Blossom integration)

## 📁 File Structure

```
vibesteroids/
├── src/
│   └── asteroids.html          # Main game file (HTML + CSS + JS)
├── test/
│   └── asteroids_test          # Node.js test runner
├── flake.nix                   # Nix development environment with HTTPS
├── https_server.py             # Alternative HTTPS server
├── cert.pem / key.pem          # SSL certificates for iOS testing
└── AGENTS.md                   # This file
```

## 🎯 Core Game Functions

### **Pure Function Categories**
1. **State Update**: `updateGameState(state, keys, deltaTime, currentTime)`
2. **Physics**: `updateShipPosition()`, `wrapPosition()`, `detectCollision()`
3. **Game Logic**: `checkExtraLife()`, `activateDeathBlossom()`, `updateDeathBlossomState()`
4. **Rendering**: All draw functions are pure (take state, render to canvas)
5. **Sound**: All sound functions are pure (take state, trigger audio)

### **State Structure**
```javascript
const GameState = {
    // Core game objects
    ship: { x, y, vx, vy, angle, radius, thrusting },
    asteroids: [{ x, y, vx, vy, radius, angle, points }],
    bullets: [{ x, y, vx, vy, distanceTraveled }],
    particles: [{ x, y, vx, vy, life, maxLife }],

    // Game state
    score: 0,
    lives: 3,
    level: 1,
    gameOver: false,
    paused: false,

    // Extra life system
    nextExtraLifeScore: 20000,
    EXTRA_LIFE_INTERVAL: 20000,

    // Death Blossom state
    deathBlossomActive: false,
    deathBlossomStartTime: 0,
    deathBlossomRotations: 0,
    deathBlossomAvailable: true,
    DEATH_BLOSSOM_ROTATION_COUNT: 9,

    // Configuration
    SHIP_ACCELERATION: 300,
    ROTATION_SPEED: 5,
    BULLET_SPEED: 500,
    MAX_BULLETS: 5,
    ASTEROID_SPAWN_COUNT: 5
};
```

## 🔧 Development Environment

### **Setup**
```bash
# Using Nix (recommended)
nix develop

# Start HTTPS development server (required for iOS)
dev-server

# Alternative Python server
python https_server.py
```

### **Key Requirements**
- **HTTPS Required**: iOS motion permissions need HTTPS
- **Hot Reload**: Browser-sync provides automatic refresh
- **SSL Certificates**: Auto-generated for localhost development

## 🎨 Visual Design

### **Neon Aesthetic**
- Multiple glow layers for authentic 80's look
- Color scheme: Magenta, cyan, white cores
- Monospace font: 'Courier New'
- Particle effects for explosions and thrust

### **Rendering Pattern**
```javascript
function drawNeonText(ctx, text, x, y, color) {
    // Outer glow (large, transparent)
    ctx.shadowColor = color;
    ctx.shadowBlur = scale(20);
    ctx.strokeStyle = color;
    ctx.strokeText(text, x, y);

    // Inner core (bright, solid)
    ctx.shadowBlur = scale(5);
    ctx.fillStyle = '#ffffff';
    ctx.fillText(text, x, y);
}
```

## 🚫 Anti-Patterns to Avoid

### **Code Quality**
- ❌ **Never mutate state**: Always return new objects
- ❌ **No side effects in pure functions**: Functions should only transform inputs to outputs
- ❌ **Don't skip tests**: Every feature needs comprehensive test coverage
- ❌ **No logic in tests**: Tests should setup, call, assert - nothing more
- ❌ **Don't ignore test failures**: All tests must pass before continuing

### **Architecture**
- ❌ **No global mutations**: Game state changes only through `updateGameState()`
- ❌ **No direct DOM manipulation in game logic**: Keep rendering separate
- ❌ **No hardcoded values**: Use configurable constants in GameState

## 📈 Future Development

### **Adding New Features**
1. **TDD First**: Write failing tests that define the feature
2. **Pure Functions**: Implement as pure functions that transform state
3. **State Integration**: Add necessary fields to GameState
4. **Comprehensive Testing**: Cover edge cases, error conditions
5. **Documentation**: Update this file with new architecture decisions

### **Performance Considerations**
- Game runs at 60fps with requestAnimationFrame
- Pure functions enable predictable performance
- Immutable state prevents memory leaks from retained references
- Canvas rendering is optimized with proper save/restore patterns

## 🎯 Success Metrics

- **All 86 tests pass** ✅
- **No mutations of game state** ✅
- **All features developed with TDD** ✅
- **Comprehensive test coverage** ✅
- **Clean, readable code** ✅
- **Consistent architecture patterns** ✅

---

## 🤖 Instructions for Future LLMs

When working on this codebase:

1. **ALWAYS run tests first**: `node test/asteroids_test`
2. **Use TDD religiously**: Test → Fail → Implement → Pass → Refactor
3. **Maintain pure functions**: Never mutate inputs, always return new objects
4. **Follow existing patterns**: Study how Death Blossom and Extra Life features are implemented
5. **Update tests immediately**: Any code change requires corresponding test updates
6. **Keep this document current**: Update AGENTS.md when making architectural changes

**Remember**: This codebase prioritizes maintainability, testability, and functional programming principles over quick hacks. Every feature is thoroughly tested and follows consistent patterns.
