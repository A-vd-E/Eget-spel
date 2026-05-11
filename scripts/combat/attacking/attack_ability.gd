extends Node2D

const MeleeHitboxScene = preload("res://scenes/melee_hitbox.tscn")
const ProjectileHitboxScene = preload("res://scenes/projectile_hitbox.tscn")

# The spawnpoint for the hitbox MultiplayerSpawner
@onready var hitbox_spawnpoint: Node2D = get_tree().current_scene.get_node("SpawningContainers").get_node("Hitboxes")
@onready var player := $".."

@export var base_knockback := Vector2(700, -400)

var player_id: int
var can_attack := true
var owner_node

@export var melee_attack_duration := 0.2
@export var attack_damage := 20
@export var projectile_duration := 0.5

func melee_attack():
	if can_attack: 
		player.add_turn_lock("attack")
		
		var hitbox = MeleeHitboxScene.instantiate()
		hitbox_spawnpoint.add_child(hitbox, true)
		
		var facing_direction = player.facing_direction
		var offset = Vector2(40, 0) * facing_direction
		owner_node = get_parent()
		player_id = player.player_id
		
		hitbox.setup(
			attack_damage, 
			melee_attack_duration, 
			owner_node, player_id, 
			offset, 
			base_knockback
			)
		can_attack = false
		$attack_again_timer.start()
		$lock_turning_timer.start()
		
		

func ranged_attack():
	if can_attack: 
		var hitbox = ProjectileHitboxScene.instantiate()
		hitbox_spawnpoint.add_child(hitbox)
		
		var facing_direction = player.facing_direction
		owner_node = get_parent()
		player_id = player.player_id
		
		hitbox.setup(
			attack_damage, 
			projectile_duration, 
			owner_node, player_id, 
			facing_direction, 
			base_knockback)
		can_attack = false
		$attack_again_timer.start()
func _on_attack_again_timer_timeout() -> void:
	can_attack = true
	$attack_again_timer.stop()


func _on_lock_turning_timer_timeout() -> void:
	player.remove_turn_lock("attack")
	
	$lock_turning_timer.stop()
	
