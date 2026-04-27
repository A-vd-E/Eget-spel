class_name Hitbox2
extends Area2D

@export var attacker_dmg: int
@export var hitbox_lifetime: float

# The hitbox need to follow a player around. If it stays where it
# spawned, the player won't hit accurately if it attacks while moving.
# If the hitbox was a child of player it would follow the player 
# automatically, but since it is replicated via MultiplayerSpawner
# it can't be assigned as a child of the player in an easy way.
# (or I couln't do it at least)
var follow_target: Node2D # The player that spawns the hitbox, 
 # Hitbox should be offset to left/right of the player center.
var offset: Vector2 # How much the hitbox should be offset
var hurtbox_owner

@onready var collision_shape: CollisionShape2D = $CollisionShape2D


# Assigns the hitbox scene objects with values. setup() is needed 
# since the object will be replicated with multiplayerSpawner, 
# which does not replicate runtime values like global_location - said GPT
func setup(_attacker_dmg: int, _hitbox_lifetime: float, owner_node: Node2D, _offset: Vector2) -> void:
		attacker_dmg = _attacker_dmg
		hitbox_lifetime = _hitbox_lifetime 
		
		follow_target = owner_node
		offset = _offset

		global_position = follow_target.global_position + offset
		
		if hitbox_lifetime > 0.0:
			await get_tree().create_timer(hitbox_lifetime).timeout
			queue_free()
		print("Player:", follow_target.player_id, " now has a hitbox following them. Test 3 In hitbox")
		
func _physics_process(delta):
	# Makes the hitbox follow player position
	if follow_target:
		global_position = follow_target.global_position + offset

func _ready() -> void:
	# Other objects won't detect it for collision
	monitorable = false
	area_entered.connect(_on_area_entered)

	
func _on_area_entered(area: Area2D) -> void:
	
	if not multiplayer.is_server():
		return
	
	# In order to only react to hurtboxes
	if not area.has_method("receive_hit"):
		return
	
	
	hurtbox_owner = area.owner_id
	
	print("Player:", hurtbox_owner, " touched the hitbox. Test 4 In hitbox")
	# To prevent self damage
	if hurtbox_owner == follow_target.player_id:
		return

	area.receive_hit(attacker_dmg)
		
		
