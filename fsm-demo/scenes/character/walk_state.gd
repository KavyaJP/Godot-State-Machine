extends NodeState

func _on_enter():
	print("Entered Walk State")

func _on_process(_delta):
	if not Input.is_action_pressed("ui_right"):
		transition.emit(&"Idle")
