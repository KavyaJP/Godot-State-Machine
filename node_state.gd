class_name NodeState
extends Node

# Using StringName is faster than String for dictionary lookups and comparisons,
# which is critical for the State Machine's internal routing.
signal transition_requested(target_state: StringName, data: Dictionary)

@export var tags: Array[StringName] = []

var time_in_state: float = 0.0
# The parent state machine injects its reference here during _ready().
# This allows states to query the machine (e.g., checking if it's transitioning) without get_parent().
var machine: NodeStateMachine 

func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	# Accumulating time automatically saves boilerplate in every state script
	# and ensures time-based logic (like input lockouts) relies on consistent physics ticks.
	time_in_state += _delta

func _on_enter(_data: Dictionary = {}) -> void:
	time_in_state = 0.0

func _on_exit() -> void:
	pass

# Guard clauses prevent the State Machine from executing invalid transitions.
# Override these in specific states (e.g., preventing exit from 'Stunned' state until a timer finishes).
func can_enter(_data: Dictionary = {}) -> bool:
	return true

func can_exit() -> bool:
	return true

# Hooks into the FSM's event bus to react to global signals (like a parry or external damage)
# without needing to poll input or external managers in _physics_process.
func on_event(_event_name: StringName, _data: Dictionary = {}) -> void:
	pass

func has_tag(tag: StringName) -> bool:
	return tag in tags