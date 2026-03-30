class_name NodeStateMachine
extends Node

@export var initial_state: NodeState

var states: Dictionary = {}
var current_state: NodeState
var current_state_name: StringName

# Concurrency locks prevent a state from triggering a new transition 
# while the previous transition's _on_enter or _on_exit logic is still executing.
var _is_transitioning: bool = false
var _queued_transition: StringName = &""
var _queued_transition_data: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is NodeState:
			var state_name = StringName(child.name.to_lower())
			states[state_name] = child
			child.machine = self
			child.transition_requested.connect(_on_transition_requested)
	
	if initial_state:
		initial_state._on_enter({})
		current_state = initial_state
		current_state_name = StringName(initial_state.name.to_lower())

func _process(delta: float) -> void:
	if current_state:
		current_state._on_process(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state._on_physics_process(delta)
		
	# Processing queued transitions at the end of the physics frame ensures 
	# the current state finishes its entire simulation step before being ripped out.
	if _queued_transition != &"":
		_execute_transition(_queued_transition, _queued_transition_data)
		_queued_transition = &""
		_queued_transition_data = {}

func _on_transition_requested(target_state: StringName, data: Dictionary) -> void:
	if _is_transitioning:
		_queued_transition = target_state
		_queued_transition_data = data
		return
		
	_execute_transition(target_state, data)

func _execute_transition(target_state_name: StringName, data: Dictionary) -> void:
	if target_state_name == current_state_name:
		return
		
	var new_state = states.get(target_state_name)
	if not new_state:
		push_warning("State Machine: Target state not found - ", target_state_name)
		return
		
	# Respecting guard clauses enforces strict control flow. 
	# If a state refuses to yield or the new state rejects the payload, we silently abort.
	if current_state and not current_state.can_exit():
		return
		
	if not new_state.can_enter(data):
		return
		
	_is_transitioning = true
	
	if current_state:
		current_state._on_exit()
		
	new_state._on_enter(data)
	
	current_state = new_state
	current_state_name = target_state_name
	_is_transitioning = false

# Allows external managers (like a HitboxManager or InputHandler) to broadcast 
# events directly down to whatever logic the current state holds.
func on_event(event_name: StringName, data: Dictionary = {}) -> void:
	if current_state:
		current_state.on_event(event_name, data)

func current_state_has_tag(tag: StringName) -> bool:
	if current_state:
		return current_state.has_tag(tag)
	return false