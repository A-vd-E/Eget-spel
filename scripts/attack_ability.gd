extends Node2D

const HitboxScene = preload("res://scenes/hitbox.tscn")

# The spawnpoint for the hitbox MultiplayerSpawner
@onready var hitbox_spawnpoint: Node2D = get_tree().current_scene.get_node("Hitboxes")
@onready var player := $".."

@export var base_knockback := Vector2(700, -400)

var can_attack := true
var owner_node


func attack():
	if can_attack: 
		var hitbox = HitboxScene.instantiate()
		hitbox_spawnpoint.add_child(hitbox)
		
		var facing_direction = player.facing_direction
		var offset = Vector2(40, 0) * facing_direction
		owner_node = get_parent()
		
		hitbox.setup(20, 0.2, owner_node, offset, base_knockback)
		can_attack = false
		$attack_again_timer.start()
		


func _on_attack_again_timer_timeout() -> void:
	can_attack = true
