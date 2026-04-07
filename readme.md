# GDExtension FSM Architecture

A reusable Finite State Machine (FSM) architecture for Godot, designed for flexibility, clarity, and performance-conscious usage.

---

## Table of Contents

- [GDExtension FSM Architecture](#gdextension-fsm-architecture)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Architecture](#architecture)
  - [Components](#components)
  - [Core Principles](#core-principles)
  - [Workflow](#workflow)
    - [1. Add Controller](#1-add-controller)
    - [2. Add States](#2-add-states)
    - [3. Set Initial State](#3-set-initial-state)
    - [4. Write State Logic](#4-write-state-logic)
  - [Performance Design](#performance-design)
  - [Performance](#performance)
    - [Benchmark](#benchmark)
  - [Implementation](#implementation)
  - [When to Use What](#when-to-use-what)
    - [Use **GDScript FSM** if:](#use-gdscript-fsm-if)
    - [Use **C++ GDExtension FSM** if:](#use-c-gdextension-fsm-if)
  - [Future Expansion](#future-expansion)
  - [Build System](#build-system)
  - [Key Benefits](#key-benefits)
  - [License](#license)
  - [Contribution](#contribution)
  - [Credits](#credits)

---

## Overview

This system provides a clean and scalable FSM architecture built around two interchangeable implementations:

- **C++ (GDExtension)** → Best when states are also written in C++
- **GDScript** → Best when states are written in GDScript

The goal is not just performance — but **choosing the right tool for your workflow**.

---

## Architecture

The system follows a **flat FSM design**:

- A single **Controller node**
- Multiple **State nodes** as direct children

This keeps the structure:

- Easy to reason
- Fast to iterate
- Simple to debug

---

## Components

| Component           | Responsibility                       |
| ------------------- | ------------------------------------ |
| NodeState           | Base class for all states            |
| NodeStateController | Handles transitions and active state |

---

## Core Principles

- Only one state is active at a time
- States are self-contained
- Transitions are signal-driven
- The controller owns execution flow

---

## Workflow

### 1. Add Controller

Attach a `NodeStateController` to your entity:

```
Player
 └── NodeStateController
```

---

### 2. Add States

Add child nodes extending `NodeState`:

```
NodeStateController
 ├── Idle
 ├── Walk
 └── Jump
```

---

### 3. Set Initial State

Choose the starting state for `NodeStateController` via the Inspector.

---

### 4. Write State Logic

```gdscript
extends NodeState

func _on_physics_process(delta):
    if Input.is_action_pressed("move"):
        move_character(delta)
    else:
        transition.emit(&"idle")
```

States request transitions — the controller handles them.

---

## Performance Design

- Only the active state is processed
- No updates on inactive states
- Cached state lookup for fast transitions
- Minimal runtime overhead

---

## Performance

Benchmark results revealed a critical insight:

> **Mixing C++ controllers with GDScript states introduces interop overhead**

### Benchmark

- 2 Transitions done 100,000 times

| Implementation                  | Time (ms) | Relative Speed |
| ------------------------------- | --------- | -------------- |
| Pure GDScript FSM               | `48.53`   | `1.0x`         |
| Compiled C++ + GDScript (Mixed) | `58.11`   | `0.83x`        |

_(Benchmarked on Ryzen 5 9600X - Windows 11)_

---

## Implementation

- **C++ Implementation:** [`/src/`](src/)
- **GDScript Implementation:** [`/gdscript/`](gdscript/)

---

## When to Use What

### Use **GDScript FSM** if:

- Your states are written in GDScript
- You want fastest iteration
- You want better performance in script-heavy logic

### Use **C++ GDExtension FSM** if:

- Your states are written in C++
- You want full native performance
- You are building large-scale or system-heavy logic

---

## Future Expansion

The system is designed to evolve into a **Hierarchical FSM (HFSM)**:

```
Player FSM
 └── Combat (Controller)
      ├── Attack
      └── Defend
```

---

## Build System

Built using **SCons**, compatible with all Godot-supported platforms:

- Windows
- Linux
- macOS
- Android
- iOS
- Web

---

## Key Benefits

- Clean editor workflow
- Clear separation of logic
- Flexible implementation choices

---

## License

The Project is Licensed under [MIT License](LICENSE).

---

## Contribution

Contributions and improvements are welcome.

---

## Credits

- Huge thanks to
  - ErisEsra's character template. You can check out the assest [here](https://erisesra.itch.io/character-templates-pack).
  - Kenney NL for monochrome tilemap. You can check out the asset [here](https://kenney.nl/assets/monochrome-rpg).
- **If you can then please donate to the artists who can make projects like this possible.**
