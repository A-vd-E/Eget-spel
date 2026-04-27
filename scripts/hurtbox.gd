class_name Hurtbox extends Area2D

@onready var owner_health: Node2D = get_parent()

func _ready() -> void:
	monitoring = false
	monitorable = true
	
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)


func receive_hit(damage: int) -> void:
	owner_health.take_damage(damage)
	print(owner_health.get_parent().name + "took damage")
