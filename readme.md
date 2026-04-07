# GDExtension FSM Architecture

A high-performance, reusable Finite State Machine (FSM) architecture for Godot using GDExtension (C++) and GDScript.

---

## Overview

This system is designed to combine:

- C++ performance for core systems such as state management, memory handling, and execution flow
- GDScript flexibility for fast and intuitive gameplay logic

The architecture follows a simple flat hierarchy consisting of:

- A single Controller node
- Multiple State nodes as its children

This design keeps the system easy to use, scalable, and efficient.

---

## Architecture Summary

| Component           | Responsibility                          |
| ------------------- | --------------------------------------- |
| NodeState           | Base class for all states               |
| NodeStateController | Manages state transitions and execution |

---

## Core Concepts

- Only one state is active at a time
- All states are direct children of the controller
- State transitions are handled using signals
- State lookup is optimized internally for fast switching

---

## Core Classes

### NodeState

The base class that all states extend.

- Acts as the interface between the engine and your gameplay logic
- Designed to be extended in GDScript
- Provides lifecycle hooks for entering, exiting, and updating states

Each state is responsible only for its own behavior.

---

### NodeStateController

The central manager of the FSM.

- Keeps track of all available states
- Controls which state is currently active
- Handles transitions between states
- Ensures only the active state is updated

---

## Developer Workflow

### 1. Scene Setup

- Add a NodeStateController to your entity (player, enemy, etc.)

---

### 2. Create States

- Add child Node nodes under the controller
- Attach scripts that extend NodeState

Example state names:

- Idle
- Walk
- Jump

---

### 3. Assign Initial State

- Select the controller node
- Assign the initial state using the Inspector

---

### 4. Implement State Logic

Example:

```gdscript
extends NodeState

func _on_physics_process(delta):
    if Input.is_action_pressed("move"):
        move_character(delta)
    else:
        transition.emit(&"idle")
```

States emit a transition signal to request a change. The controller handles the switch automatically.

---

## Performance Design

- Only the active state is processed at runtime
- No unnecessary updates on inactive states
- Fast state switching through internal caching
- Designed to scale efficiently for complex behaviors

---

## Build System (SCons)

The project uses SCons for building the GDExtension.

### Platform Support

This system supports all platforms that Godot supports, including:

- Windows
- Linux
- macOS
- Android
- iOS
- Web

---

## Future Expansion

The current implementation is a flat FSM, but it is designed to support future expansion into hierarchical state machines.

This would allow:

- State machines inside other state machines
- More complex and modular behavior systems

Example structure:

```
Player FSM
 └── Combat State (Controller)
      ├── Attack
      ├── Defend
```

---

## Key Benefits

- Clean and simple setup in the Godot editor
- Clear separation between engine logic and gameplay logic
- High performance through native code
- Fast iteration using GDScript
- Scalable design for larger projects

---

## Performance Benchmark

Because **Node State Controller** is written entirely in C++ as a GDExtension, it handles state caching, Dictionary lookups, and virtual method execution with zero script-level overhead.

You can take a look at the C++ implementation in `src/` and GDScript implementation in `fsm-demo/scripts/gd_state_machine/` and a look at the benchmark script in `fsm-demo/benchmark`

_Benchmark running continuous 100000 state transitions:_

| Implementation                | Time Taken (ms) | Speed Increase     |
| :---------------------------- | :-------------- | :----------------- |
| **Pure GDScript FSM**         | `48.23`         | 1.0x (Baseline)    |
| **C++ Node State Controller** | `89.16`         | **`0.54`x Faster** |

_(Tested on Godot 4.x - Windows 11 - Ryzen 5 9600X 6 Cores 12 Threads)_

### Future Enhancment

- Optimise C++ as much as possible for better performance

---

## License

This project is licensed under the [MIT License](LICENSE).

---

## Contribution

Contributions, improvements, and extensions are welcome.

---

## Credits

- Huge thanks to
  - ErisEsra's character template. You can check out the assest [here](https://erisesra.itch.io/character-templates-pack).
  - Kenney NL for monochrome tilemap. You can check out the asset [here](https://kenney.nl/assets/monochrome-rpg).
- If you can then please donate to the artists who can make projects like this possible.

---

## Summary

This FSM architecture provides a strong foundation for building responsive and maintainable gameplay systems in Godot by combining:

- Native execution speed
- Script-level flexibility
- A clean and intuitive structure

---
