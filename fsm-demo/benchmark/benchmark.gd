extends Node

const ITERATIONS = 100000

func _ready() -> void:
	print("--- Node State Controller FSM Benchmark ---")
	print("Iterations: ", ITERATIONS, " state transitions\n")
	
	# Wait a frame to let Godot stabilize the tree
	await get_tree().process_frame
	
	benchmark_gdscript_fsm()
	benchmark_cpp_fsm()

func benchmark_gdscript_fsm() -> void:
	# 1. Setup GDScript FSM
	var fsm = GDNodeStateMachine.new()
	
	var state_a = GDNodeState.new()
	state_a.name = "StateA"
	
	var state_b = GDNodeState.new()
	state_b.name = "StateB"
	
	fsm.add_child(state_a)
	fsm.add_child(state_b)
	fsm.initial_node_state = state_a
	add_child(fsm) # Triggers _ready()

	# 2. Benchmark Transitions
	var start_time = Time.get_ticks_usec()
	
	for i in range(ITERATIONS):
		fsm.transition_to("stateb")
		fsm.transition_to("statea")
		
	var end_time = Time.get_ticks_usec()
	var time_taken_ms = (end_time - start_time) / 1000.0
	
	print("[GDScript] FSM Transitions: ", time_taken_ms, " ms")
	fsm.queue_free()


func benchmark_cpp_fsm() -> void:
	# 1. Setup C++ FSM
	var fsm = NodeStateController.new()
	
	var state_a = NodeState.new()
	state_a.name = "StateA"
	
	var state_b = NodeState.new()
	state_b.name = "StateB"
	
	fsm.add_child(state_a)
	fsm.add_child(state_b)
	fsm.set_initial_node(state_a)
	add_child(fsm) # Triggers _ready()

	# 2. Benchmark Transitions
	var start_time = Time.get_ticks_usec()
	
	for i in range(ITERATIONS):
		fsm.transition_to(&"StateB")
		fsm.transition_to(&"StateA")
		
	var end_time = Time.get_ticks_usec()
	var time_taken_ms = (end_time - start_time) / 1000.0
	
	print("[C++ Native] FSM Transitions: ", time_taken_ms, " ms")
	fsm.queue_free()
