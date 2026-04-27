class_name Hurtbox extends Area2D

@onready var player_health: Node2D = get_parent()

var owner_id: int

func _ready() -> void:
	monitoring = false
	monitorable = true
	

	
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)


func receive_hit(damage: int) -> void:
	player_health.take_damage(damage)
	print("Player:", owner_id, " called take damage. Test 5 In Hurtbox")
	


func set_owner_id(id):
	owner_id = id
