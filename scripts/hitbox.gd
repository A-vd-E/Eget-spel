class_name Hitbox2
extends Area2D

@export var attacker_dmg: int
@export var hitbox_lifetime: float
var follow_target: Node2D
var offset: Vector2


@onready var collision_shape: CollisionShape2D = $CollisionShape2D


func setup(_attacker_dmg: int, _hitbox_lifetime: float, owner_node: Node2D, _offset: Vector2) -> void:
		attacker_dmg = _attacker_dmg
		hitbox_lifetime = _hitbox_lifetime 
		
		follow_target = owner_node
		offset = _offset

		global_position = follow_target.global_position + offset
		
		if hitbox_lifetime > 0.0:
			await get_tree().create_timer(hitbox_lifetime).timeout
			queue_free()

func _physics_process(delta):
	if follow_target:
		global_position = follow_target.global_position + offset

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
		
		
