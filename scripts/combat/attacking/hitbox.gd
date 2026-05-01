class_name Hitbox
extends Area2D

@export var attacker_dmg: int
@export var hitbox_lifetime: float

var attacker: Node2D
var hurtbox_owner
var knockback_vector: Vector2

@onready var collision_shape: CollisionShape2D = $CollisionShape2D


# Assigns the hitbox scene objects with values. setup() is needed 
# since the object will be replicated with multiplayerSpawner, 
# which does not replicate runtime values like global_location - said GPT

func _ready() -> void:
	# Other objects won't detect it for collision
	monitorable = false
	area_entered.connect(_on_area_entered)
	

func start_lifetime() -> void:
	if hitbox_lifetime > 0.0:
			await get_tree().create_timer(hitbox_lifetime).timeout
			queue_free()
	
func _on_area_entered(area: Area2D) -> void:
	
	if not multiplayer.is_server():
		return
	
	# In order to only react to hurtboxes
	if not area.has_method("receive_hit"):
		return
	
	hurtbox_owner = area.owner_id
	
	# To prevent self damage
	if hurtbox_owner == attacker.player_id:
		return

	area.receive_hit(attacker_dmg, knockback_vector, global_position)
