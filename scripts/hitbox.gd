class_name Hitbox2
extends Area2D

@export var attacker_dmg: int
@export var hitbox_lifetime: float

@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func setup(_attacker_dmg: int, _hitbox_lifetime: float) -> void:
		attacker_dmg = _attacker_dmg
		hitbox_lifetime = _hitbox_lifetime 
		
		if hitbox_lifetime > 0.0:
			var timer = get_tree().create_timer(hitbox_lifetime)
			timer.timeout.connect(queue_free)



func _ready() -> void:
	monitorable = false
	area_entered.connect(_on_area_entered)
		
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)
	
func _on_area_entered(area: Area2D) -> void:
	
	if not multiplayer.is_server():
		return
	
	if not area.has_method("receive_hit"):
		return
	
	
	area.receive_hit(attacker_dmg)
		
		
