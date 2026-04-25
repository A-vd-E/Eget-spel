class_name Hitbox extends Area2D

var attacker_dmg: int
var hitbox_lifetime: float
var shape: Shape2D

func _init(_attacker_dmg: int, _hitbox_lifetime: float, _shape: Shape2D) -> void:
		attacker_dmg = _attacker_dmg
		hitbox_lifetime = _hitbox_lifetime 
		shape = _shape
		
func _ready() -> void:
	monitorable = false
	area_entered.connect(_on_area_entered)
	
	if hitbox_lifetime > 0.0:
		var  new_timer = Timer.new()
		add_child(new_timer)
		new_timer.timeout.connect(queue_free)
		new_timer.call_deferred("start", hitbox_lifetime)
	if shape: 
		var collision_shape = CollisionShape2D.new()
		collision_shape.shape = shape
		add_child(collision_shape)
		
	set_collision_layer_value(1, true)
	set_collision_mask_value(1, true)
	
func _on_area_entered(area: Area2D) -> void:
	if not area.has_method("receive_hit"):
		return
	
	if not area.get_owner().is_multiplayer_authority() == true:
		area.receive_hit(attacker_dmg)
		print("HIT:", area, " parent:", area.get_parent().name)
		
