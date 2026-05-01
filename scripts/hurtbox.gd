class_name Hurtbox extends Area2D

@onready var player_health: Node2D = get_parent()

var owner_id: int

func _ready() -> void:
	# Determines if this objects searches for other collision objects
	monitoring = false
	# Determines if other objects can detect this collision object
	monitorable = true
	
	

func receive_hit(damage: int, base_knockback: Vector2 = Vector2.ZERO, source_position: Vector2 = Vector2.ZERO) -> void:
	player_health.take_damage(damage, base_knockback, source_position)
	


func set_owner_id(id):
	owner_id = id
