extends GDNodeState

@export var player: PlayerGD
@export var animated_sprite_2d: AnimatedSprite2D

func _on_enter():
	#print("Entered Walk State")
	pass

func _on_process(_delta):
	if not InputManager.is_input_movement():
		transition.emit("idle")
	if InputManager.is_running() and InputManager.is_input_movement():
		transition.emit("run")

func _on_physics_process(_delta: float) -> void:
	var direction: Vector2 = InputManager.get_movement_direction()
	player.last_direction = direction
	
	if direction == Vector2.DOWN:
		animated_sprite_2d.play("walk_front")
	elif direction == Vector2.UP:
		animated_sprite_2d.play("walk_back")
	elif direction == Vector2.LEFT:
		animated_sprite_2d.flip_h = true
		animated_sprite_2d.play("walk_right")
	elif direction == Vector2.RIGHT:
		animated_sprite_2d.flip_h = false
		animated_sprite_2d.play("walk_right")
	
	player.velocity = direction * player.speed
	player.move_and_slide()

func _on_exit() -> void:
	animated_sprite_2d.stop()
