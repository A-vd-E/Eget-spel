extends Node2D

const HitboxScene = preload("res://scenes/hitbox.tscn")

# The spawnpoint for the hitbox MultiplayerSpawner
@onready var hitbox_spawnpoint: Node2D = get_tree().current_scene.get_node("Hitboxes")
@onready var player := $".."

var can_attack := true
var owner_node


func attack():

	if can_attack: 
		
		var hitbox = HitboxScene.instantiate()
		hitbox_spawnpoint.add_child(hitbox)
		
		
		
		var facing_direction = player.facing_direction
		var offset = Vector2(40, 0) * facing_direction
		
		owner_node = get_parent()
		
		hitbox.setup(20, 0.2, owner_node, offset)
		can_attack = false
		$attack_again_timer.start()
		
		print("Player:", owner_node.player_id, " executed attack. Test 2 In AttackComp")


func _on_attack_again_timer_timeout() -> void:
	can_attack = true
