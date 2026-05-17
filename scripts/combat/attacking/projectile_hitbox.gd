class_name ProjectileHitbox
extends Hitbox

@export var speed: int = 800
var velocity: int

func _ready() -> void:
	# Call the parent Hitbox _ready() so collisions still work
	super._ready()
	
	# HACK: Hide the sprite immediately to mask the 1-frame network teleport
	if has_node("Sprite2D"):
		$Sprite2D.visible = false
		# Wait 0.05 seconds (enough time for the MultiplayerSynchronizer to snap it into place)
		await get_tree().create_timer(0.05).timeout
		
		# Make sure the projectile hasn't been destroyed while we were waiting
		if is_instance_valid(self) and has_node("Sprite2D"):
			$Sprite2D.visible = true

func setup(_attacker_dmg: int, _hitbox_lifetime: float, owner_node: Node2D, attacker_id: int, _direction: int, _knockback: Vector2 = Vector2.ZERO) -> void:
		attacker_dmg = _attacker_dmg
		hitbox_lifetime = _hitbox_lifetime 
		self.attacker_id = attacker_id
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
