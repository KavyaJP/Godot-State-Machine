# Godot Advanced State Machine

A high-performance, production-ready **State Machine system for Godot 4.x**, designed for scalable gameplay architecture including **player controllers, combat systems, AI, and animation-driven logic**.

This system provides a clean, modular, and extensible foundation for managing complex game behavior while remaining simple to use in everyday development.

---

## 🚀 Features

* **🔁 Data-Driven Transitions**
  Transitions are not just strings—they support payloads and priorities:

  ```gdscript
  transition_requested.emit("jump", {"force": 1.5}, 10)
  ```

  Pass contextual data like velocity, attack info, or direction seamlessly between states.

---

* **🚫 Safe Transition Guards**
  Prevent invalid or unwanted transitions using built-in guard functions:

  * `can_enter(data)`
  * `can_exit()`

  Ensures states like attacks or knockbacks cannot be interrupted improperly.

---

* **⏱️ State Time Tracking**
  Each state automatically tracks how long it has been active:

  ```gdscript
  if time_in_state > 0.2:
      # allow jump apex logic
  ```

---

* **🔄 Transition Queue & Priority System**
  Multiple transitions in a single frame are handled safely:

  * Queued and resolved deterministically
  * Priority-based selection prevents flickering bugs

---

* **📦 Context Injection (No Manual Wiring)**
  Automatically inject a shared `context` (e.g., Player or Enemy) into all states:

  ```gdscript
  var player := context as Player
  ```

  No more assigning references in the inspector for every state.

---

* **🎯 Event System (Reactive Gameplay)**
  Send external events directly into the state machine:

  ```gdscript
  state_machine.send_event("jump_pressed")
  state_machine.send_event("damage_taken", {"amount": 10})
  ```

  Enables clean input handling, AI reactions, and combat triggers.

---

* **🧾 Debug-Friendly Design**
  Easily track:

  * Current state
  * Previous state
  * Time in state

  Perfect for debugging complex gameplay logic.

---

## 📦 Installation

1. Download the latest release from the Releases page (or compile from source).
2. Copy the addon folder into your Godot project:

   ```
   addons/cow_state_machine/
   ```
3. Enable the plugin in:

   ```
   Project Settings → Plugins
   ```
4. You can now use `NodeStateMachine` and `NodeState` in your scenes.

---

## 🛠️ Usage

### 1. Setup

1. Add a `NodeStateMachine` node to your scene
2. Add child states (extending `NodeState`):

   * `IdleState`
   * `RunState`
   * `JumpState`

---

### 2. Example State

```gdscript
extends NodeState

func _on_enter(data := {}):
    print("Entered Idle")

func _on_process(delta):
    if Input.is_action_pressed("move"):
        transition_requested.emit("run", {}, 0)

func _on_exit():
    print("Exiting Idle")
```

---

### 3. Sending Events

```gdscript
state_machine.send_event("jump_pressed")
```

Inside a state:

```gdscript
func on_event(event: StringName, data: Dictionary):
    if event == "jump_pressed":
        transition_requested.emit("jump", {"force": 1.5}, 10)
```

---

### 4. Using Context

```gdscript
var player := context as Player
player.velocity.y += 10
```

---

## 🔧 API Reference

### `NodeState`

Base class for all states.

| Method                       | Description                      |
| ---------------------------- | -------------------------------- |
| `_on_enter(data)`            | Called when entering the state   |
| `_on_exit()`                 | Called when exiting the state    |
| `_on_process(delta)`         | Called every frame               |
| `_on_physics_process(delta)` | Called every physics frame       |
| `can_enter(data)`            | Whether the state can be entered |
| `can_exit()`                 | Whether the state can be exited  |
| `on_event(event, data)`      | Handle external events           |

---

### `NodeStateMachine`

Main controller node.

| Method                       | Description                  |
| ---------------------------- | ---------------------------- |
| `send_event(event, data)`    | Sends event to current state |
| `change_state(target, data)` | Forces state change          |
| `get_current_state()`        | Returns current state        |

---

## 🧠 Design Philosophy

This system is built to be:

* **Modular** → States are independent and reusable
* **Scalable** → Supports complex gameplay systems
* **Safe** → Prevents invalid transitions
* **Performant** → Designed for future C++ GDExtension port

---

## 🎮 Example Use Cases

* Player movement (Idle / Run / Jump)
* Combat systems (Attack / Block / Hit)
* Enemy AI behaviors
* Animation-driven gameplay
* Boss state orchestration

---

## 📝 Compiling to GDExtension (Future)

This system is designed with C++ porting in mind:

* Uses lightweight data types (`StringName`, `Dictionary`)
* Avoids unnecessary allocations
* Clean separation of logic

Future versions may include:

* Full C++ backend
* Editor visualization tools
* Animation graph integration

---

## Credits

### Development

Kavya Prajapati

---

## License

This project is licensed under the MIT License
