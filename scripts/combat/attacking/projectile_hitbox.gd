class_name ProjectileHitbox
extends Hitbox

@export var speed: int = 600
var velocity: int


func setup(_attacker_dmg: int, _hitbox_lifetime: float, owner_node: Node2D, _direction: int, _knockback: Vector2 = Vector2.ZERO) -> void:
		attacker_dmg = _attacker_dmg
		hitbox_lifetime = _hitbox_lifetime 
		attacker = owner_node
		knockback_vector = _knockback
		global_position = attacker.global_position
		velocity = speed * _direction
		start_lifetime()
		
		
func _physics_process(delta):
	# Makes the hitbox follow player position
	if not multiplayer.is_server():
		return
	
	global_position.x += velocity * delta
