extends NodeState

func _on_enter():
	print("Entered Idle State")

func _on_process(_delta):
	if Input.is_action_pressed("ui_right"):
		transition.emit(&"Walk") # Emits the signal defined in C++
