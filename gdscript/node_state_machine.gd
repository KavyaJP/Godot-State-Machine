class_name NodeStateController
extends Node

# Definition of the signal used to notify the other components for changing of the state
signal state_changed(old_state: NodeState, new_state: NodeState)

@export var initial_node_state : NodeState 

var node_states : Dictionary = {}
var current_node_state : NodeState 
var current_node_state_name : StringName # Changed to StringName for fast comparison

func _ready() -> void:
	for child in get_children():
		if child is NodeState: 
			# Cache the state using StringName exactly as it's spelled
			var state_name = StringName(child.name)
			node_states[state_name] = child
			child.transition.connect(transition_to)
	
	if initial_node_state:
		initial_node_state._on_enter()
		current_node_state = initial_node_state
		current_node_state_name = StringName(current_node_state.name)

func _process(delta : float) -> void:
	if current_node_state:
		current_node_state._on_process(delta)

func _physics_process(delta: float) -> void:
	if current_node_state:
		current_node_state._on_physics_process(delta)
		current_node_state._on_next_transitions()

func transition_to(node_state_name : StringName) -> void:
	# Pointer comparison
	if node_state_name == current_node_state_name:
		return
	
	# Dictionary lookup using StringName
	var new_node_state = node_states.get(node_state_name)
	
	if !new_node_state:
		return
	
	# Cache the old state before overwriting it
	var old_state = current_node_state
	
	if current_node_state:
		current_node_state._on_exit()
	
	new_node_state._on_enter()
	
	current_node_state = new_node_state
	current_node_state_name = node_state_name
	
	# Emittion of the signal used to notify the other components for changing of the state
	state_changed.emit(old_state, current_node_state)
	print("Signal Emitted")
