extends Node2D

const HitboxScene = preload("res://scenes/hitbox.tscn")

@onready var hitbox_container: Node2D = get_tree().current_scene.get_node("Hitboxes")


var can_attack := true
var offset = Vector2(40, 0)
var owner_node
#var direction


func attack():

	if can_attack: 
		
		var hitbox = HitboxScene.instantiate()
		hitbox_container.add_child(hitbox)
		#if direction:
			#offset.x *= -1
		
		owner_node = get_parent()
		hitbox.setup(20, 0.2, owner_node, offset)
		can_attack = false
		$attack_again_timer.start()


func _on_attack_again_timer_timeout() -> void:
	can_attack = true
