extends Node

const HitboxScene = preload("res://scenes/hitbox.tscn")

var can_attack := true

func attack():

	if can_attack: 
		var hitbox = HitboxScene.instantiate()
		add_child(hitbox)
		hitbox.setup(20, 0.2)
		can_attack = false
		$attack_again_timer.start()


func _on_attack_again_timer_timeout() -> void:
	can_attack = true
