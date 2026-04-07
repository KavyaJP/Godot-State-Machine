class_name GDNodeStateMachine
extends Node

@export var initial_node_state : GDNodeState 

var node_states : Dictionary = {}
var current_node_state : GDNodeState 
var current_node_state_name : StringName # Changed to StringName for fast comparison

func _ready() -> void:
	for child in get_children():
		if child is GDNodeState: 
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
	
	if current_node_state:
		current_node_state._on_exit()
	
	new_node_state._on_enter()
	
	current_node_state = new_node_state
	current_node_state_name = node_state_name
