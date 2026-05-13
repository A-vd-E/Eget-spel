extends Node2D

@export var max_health: int = 100
@export var sync_health: int:
	set(value):
		sync_health = value
		health_changed.emit(value)
var owner_id: int # The player that owns the health component 



signal health_changed(new_value: int)
signal died
signal knockback_received(actual_knockback: Vector2)

# Starts character with full health
func _ready() -> void:
	if is_multiplayer_authority():
		
		sync_health = max_health
		
	

## Decreases the characters health by the input amount.
func take_damage(damage: int, base_knockback: Vector2 = Vector2.ZERO, source_position: Vector2 = Vector2.ZERO):
	sync_health = max(sync_health - damage, 0)
	
	# Calculate and emit knockback if a valid vector was provided
	if base_knockback != Vector2.ZERO:
		var body = get_parent()
		# Determine relative direction: 1 for right, -1 for left
		var x_dir = sign(body.global_position.x - source_position.x)
		if x_dir == 0: 
			x_dir = 1 # Fallback if positions are perfectly identical
		
		var actual_knockback = Vector2(base_knockback.x * x_dir, base_knockback.y)
		knockback_received.emit(actual_knockback)

	if sync_health == 0:
		dies()

func dies():
	died.emit()
	
	
func respawn():
	if not multiplayer.is_server():
		return
	var character = get_parent()
	character.global_position = character.respawn_point
	character.velocity = Vector2.ZERO
	character.sync_position = character.respawn_point
	
# Sets the owner id for this node, input taken in "Player" = player_id
# Assigns the same id to owner id of "Hurtbox"
func set_owner_id(id):
	owner_id = id
	$Hurtbox.set_owner_id(id)
	
