extends Node
const MeleeHitboxScene = preload("res://scenes/melee_hitbox.tscn")

@onready var hitbox_spawnpoint: Node2D = get_tree().current_scene.get_node("SpawningContainers").get_node("Hitboxes")
var owner_node = self
var attacker_id = -1000
@export var base_knockback := Vector2(700, -400)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var hitbox = MeleeHitboxScene.instantiate()
	hitbox_spawnpoint.add_child(hitbox)
		
	hitbox.setup(20, 0, owner_node, attacker_id, Vector2.ZERO, base_knockback)
