class_name MeleeHitbox
extends Hitbox


var offset: Vector2 # How much the hitbox should be offset


func setup(_attacker_dmg: int, _hitbox_lifetime: float, owner_node: Node2D, attacker_id: int, _offset: Vector2, _knockback: Vector2 = Vector2.ZERO) -> void:
		attacker_dmg = _attacker_dmg
		hitbox_lifetime = _hitbox_lifetime 
		self.attacker_id = attacker_id
		attacker = owner_node
		offset = _offset
		knockback_vector = _knockback
		global_position = attacker.global_position + offset
		
		start_lifetime()
		
		
func _physics_process(_delta):
	# Makes the hitbox follow player position
	if attacker:
		global_position = attacker.global_position + offset
