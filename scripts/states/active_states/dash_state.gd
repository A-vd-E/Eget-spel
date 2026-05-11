extends State

class_name DashState


func  _ready():
	allowed_actions = {
		Actions.PlayerAction.MOVE: false,
		Actions.PlayerAction.JUMP: false,
		Actions.PlayerAction.DASH: false,
		Actions.PlayerAction.MELEE: false,
		Actions.PlayerAction.RANGED: false
	}

func enter():
	#print("Entering dash state")
	character.can_dash = false
	
	$dash_timer.start()
	# Dash cooldown
	$dash_again_timer.start()
	
	
	
func physics_update(delta: float):
	if character.movement_locked:
		state_machine.change_state("idlestate")
		return
	
	character.velocity.x =  (
		character.facing_direction
	 	* character.DASH_SPEED 
	)
	
	character.velocity.y = 0
	
	if character.is_on_wall() and not character.is_on_floor():
		end_dash()
	
	
func end_dash():
	state_machine.change_state("idlestate")
func _on_dash_again_timer_timeout() -> void:
	character.can_dash = true


func _on_dash_timer_timeout() -> void:
	end_dash()
