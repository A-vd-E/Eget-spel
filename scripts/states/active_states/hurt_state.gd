extends State

class_name HurtState



func  _ready():
	allowed_actions = {
		Actions.PlayerAction.MOVE: false,
		Actions.PlayerAction.JUMP: false,
		Actions.PlayerAction.DASH: false,
		Actions.PlayerAction.MELEE: false,
		Actions.PlayerAction.RANGED: false
	}


func enter():

	$stun_duration_timer.start()
	# Stop conflicting movement states
	character.dashing = false

	# Optional: lock turning/attacks if you use them
	character.add_turn_lock("hurt")
	



func physics_update(delta: float):

	character.apply_gravity(delta)
	
	character.velocity.x = move_toward(character.velocity.x, 0, 1000 * delta) 




func _on_stun_duration_timer_timeout() -> void:
	

	$stun_duration_timer.stop()
	character.remove_turn_lock("hurt")
	
	state_machine.change_state("idlestate") 
