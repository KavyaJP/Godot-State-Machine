class_name InputManager
extends Node

static func get_movement_direction() -> Vector2:
	var direction: Vector2 = Vector2.ZERO
	
	if Input.is_action_pressed("move_up"):
		direction = Vector2.UP
	elif Input.is_action_pressed("move_down"):
		direction = Vector2.DOWN
	elif Input.is_action_pressed("move_left"):
		direction = Vector2.LEFT
	elif Input.is_action_pressed("move_right"):
		direction = Vector2.RIGHT
	else:
		direction = Vector2.ZERO
	
	return direction

static func is_input_movement() -> bool:
	var direction: Vector2 = get_movement_direction()
	if direction != Vector2.ZERO:
		return true
	return false

static func is_running() -> bool:
	return Input.is_action_pressed("run")
