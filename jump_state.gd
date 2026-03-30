extends NodeState

# The FSM handles the logic, but the root dependencies are explicitly defined 
# per state, keeping the base system agnostic to your specific game entities.
@export var player: Player
@export var sprite: Hybrid2D3DAnimatedSprite

var launch_velocity: float = 0.0

# Guarding entry ensures we only allow double jumps if a specific payload says so,
# or we prevent jumping entirely if rooted.
func can_enter(data: Dictionary = {}) -> bool:
	if player.is_rooted:
		return false
	return true

func _on_enter(data: Dictionary = {}) -> void:
	super._on_enter(data) # Resets time_in_state safely
	
	# Extracting payload data allows dynamic behaviors, like varying jump height 
	# based on if they bounced off an enemy vs jumping off the ground.
	launch_velocity = data.get("force", player.jump_velocity)
	player.velocity.y = launch_velocity
	
	sprite.set_pose("jump_s", 1)

func _on_physics_process(delta: float) -> void:
	super._on_physics_process(delta) # Continues accumulating time_in_state
	
	player.velocity.y -= WorldPhysics.gravity * delta
	player.move_and_slide()
	
	# Minimum time in state prevents immediate transitions due to 
	# single-frame physics inconsistencies (e.g., Godot reporting is_on_floor() during frame 1 of a jump).
	if time_in_state > 0.05 and player.is_on_floor():
		transition_requested.emit(&"idle", {})
	elif player.velocity.y < 0:
		transition_requested.emit(&"fall", {"from_jump": true})

# Reacting to events rather than polling Input keeps states clean.
func on_event(event_name: StringName, data: Dictionary = {}) -> void:
	if event_name == &"hit_by_enemy":
		transition_requested.emit(&"knockback", data)